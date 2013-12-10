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
            console.error 'REQUEST', requestNumber, args... if options.debug?

        debug 'options', options

        currentDigest = digests[options.host]

        debug 'currentDigest', currentDigest

        if currentDigest?
            options.headers ?= {}
            options.headers.Authorization = currentDigest

        httpOrHttps = if options.https then https else http

        req = httpOrHttps.request options, (res) =>
            debug 'response status code', res.statusCode
            debug 'response headers', res.headers

            res.on 'close', (err) ->
                debug 'response error', err

            handlers = {}

            handlers[200] = =>
                return cb null, newUnzippingResponseDecorator res if options.unzip
                res.setEncoding 'utf-8'
                cb null, res

            handlers[301] = handlers[302] = =>
                location = res.headers.location
                debug 'moved to', location

                parsedUrl = url.parse location

                debug 'redirect to', parsedUrl

                httpRequest _.extend({}, options, parsedUrl, {
                    https: parsedUrl.protocol is 'https'
                }), cb

            handlers[401] = =>
                msg1 = 'wrong credentials'
                return cb new Error msg1 if currentDigest?
                msg2 = 'authentication required, but `digest` option is not set'
                credentials = options?.credentials?[options.host]
                return cb new Error msg2 if not credentials?
                debug 'not authorized: authorizing...'

                challenge = digest.parseChallenge res.headers['www-authenticate']
                debug 'challenge:', challenge
                d = digest.renderDigest challenge,
                    credentials.username
                    credentials.password
                    options.path
                digests[options.host] = d
                debug 'new digest:', d
                # retry with the digest
                httpRequest options, cb

            handler = handlers[res.statusCode]
            msg = "failed to get #{options.path}. server status #{res.statusCode}"
            return cb new Error msg if not handler?
            handler()

        req.end()

    return httpRequest
