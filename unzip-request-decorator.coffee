{EventEmitter} = require 'events'
zlib = require 'zlib'

# decorate a response to unzip data on the fly

module.exports = class extends EventEmitter

    constructor: (res) ->
        @statusCode = res.statusCode
        @httpVersion = res.httpVersion
        @headers = res.headers
        @trailers = res.trailers

        gunzip = zlib.createUnzip()

        res.on 'data', (data) -> gunzip.write data
        res.on 'end', -> gunzip.end()
        res.on 'close', (err) => @emit 'close', err

        gunzip.on 'data', (data) => @emit 'data', data.toString()
        gunzip.on 'error', (err) => @emit 'close', err
        gunzip.on 'end', => @emit 'end'

        @res = res

    setEncoding: (encoding) -> @res.setEncoding encoding
    pause: -> @res.pause()
    resume: -> @res.resume()
