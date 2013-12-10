https = require 'https'
http = require 'http'
url = require 'url'

_ = require 'underscore'

digest = require './digest'
newUnzippingResponseDecorator = require './unzipping-response-decorator'

# adds digest auth, following redirects and response unzipping on top of http api

module.exports = ->
    digests = {}
    requestNumber = 0

    httpRequest = (options, cb) ->
        # defensive cloning
        options = _.extend {}, options

        options.unzip ?= false

        currentRequestNumber = requestNumber++

        debug = (args...) ->
            console.error "##{requestNumber}", args... if options.debug?

        debug 'REQUEST digests[options.host] =', digests[options.host]

        optionsCopy = _.extend {}, options

        if digests[options.host]?
            optionsCopy.headers ?= {}
            optionsCopy.headers.Authorization = digests[options.host]

        debug 'REQUEST options =', options

        httpOrHttps = if options.https then https else http

        onResponse = (res) ->
            debug 'RESPONSE res.statusCode =', res.statusCode
            debug 'RESPONSE res.headers =', res.headers

            res.on 'close', (err) ->
                debug 'RESPONSE err =', err

            handlers = {}

            handlers[200] = =>
                if options.unzip
                    return cb null, newUnzippingResponseDecorator res
                res.setEncoding 'utf-8'
                cb null, res

            handlers[301] = handlers[302] = =>
                location = res.headers.location
                debug 'RESPONSE moved to', location

                parsedUrl = url.parse location

                debug 'redirect to', parsedUrl

                httpRequest _.extend({}, options, parsedUrl, {
                    https: parsedUrl.protocol is 'https'
                }), cb

            handlers[401] = =>
                # we have a digest cached for this host, but it
                if digests[options.host]?
                    return cb new Error 'wrong credentials'
                credentials = options?.credentials?[options.host]
                unless credentials?
                    cb new Error "authentication required but no credentials provided for host #{options.host}"

                debug 'AUTH not authorized'

                challenge = digest.parseChallenge res.headers['www-authenticate']

                debug 'AUTH challenge =', challenge
                d = digest.renderDigest challenge,
                    credentials.username
                    credentials.password
                    options.path
                digests[options.host] = d
                debug 'AUTH digest =', d
                # retry with the digest
                httpRequest options, cb

            handler = handlers[res.statusCode]
            unless handler?
                return cb new Error "failed to get #{options.path}. server status #{res.statusCode}"
            handler()

        req = httpOrHttps.request optionsCopy, onResponse
        req.on 'error', (err) ->
            return cb err
        req.end()

    return httpRequest
