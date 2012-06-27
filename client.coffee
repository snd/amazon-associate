https = require 'https'
http = require 'http'
url = require 'url'

_ = require 'underscore'

digest = require './digest'

UnzipRequestDecorator = require './unzip-request-decorator'

# simplified request handling
# decorates http api for digest auth, following redirects and unzipping
# just adds functionality

module.exports = class

    constructor: (@options) ->
        @digests = {}

    debug: (args...) -> console.error 'DEBUG: request', args... if @options.debug

    request: (options, cb) ->

        options.unzip ?= false

        @debug 'options', options

        currentDigest = @digests[options.host]

        clonedOptions = _.extend {}, options
        if currentDigest?
            clonedOptions.headers ?= {}
            _.extend clonedOptions.headers,
                Authorization: currentDigest

        httpOrHttps = if options.https then https else http

        req = httpOrHttps.request clonedOptions, (res) =>
            @debug 'response status code', res.statusCode
            @debug 'response headers', res.headers

            res.on 'close', (err) => @debug 'response error', err

            handlers = {}

            handlers[200] = =>
                return cb null, new UnzipRequestDecorator res if options.unzip
                res.setEncoding 'utf-8'
                cb null, res

            handlers[301] = handlers[302] = =>
                @debug 'moved', res.headers
                location = res.headers.location
                @debug 'moved to', location

                parsedUrl = url.parse location

                @debug 'redirect location', parsedUrl

                @request _.extend({}, parsedUrl, {
                    https: parsedUrl.protocol is 'https'
                    state: options.state
                    unzip: options.unzip
                }), cb

            handlers[401] = =>
                msg1 = 'wrong credentials'
                return cb new Error msg1 if currentDigest?
                msg2 = 'authentication required, but `digest` option is not set'
                credentials = @options?.credentials?[options.host]
                return cb new Error msg2 if not credentials?
                @debug 'not authorized: authorizing'

                challenge = digest.parseChallenge res.headers['www-authenticate']
                @debug 'challenge:', challenge
                digest = digest.renderDigest challenge,
                    credentials.username
                    credentials.password
                    options.path
                @digests[options.host] = digest
                @debug 'digest:', digest
                # retry with the digest
                @request _.extend({}, options), cb

            handler = handlers[res.statusCode]
            msg = "failed to get #{options.path}. server status #{res.statusCode}"
            return cb new Error msg if not handler?
            handler()

        req.end()
