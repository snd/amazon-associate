events = require 'events'
zlib = require 'zlib'

# decorate/wrap a response to unzip data on the fly

module.exports = (response) ->

    decorator = new events.EventEmitter

    gunzip = zlib.createUnzip()

    # res -> gunzip

    res.on 'data', (data) ->
        gunzip.write data
    res.on 'end', ->
        gunzip.end()
    res.on 'close', (err) ->
        decorator.emit 'close', err

    # gunzip -> decorator

    gunzip.on 'data', (data) ->
        decorator.emit 'data', data.toString()
    gunzip.on 'error', (err) ->
        decorator.emit 'close', err
    gunzip.on 'end', ->
        decorator.emit 'end'

    decorator.statusCode = res.statusCode
    decorator.httpVersion = res.httpVersion
    decorator.headers = res.headers
    decorator.trailers = res.trailers
    decorator.setEncoding = (encoding) ->
        res.setEncoding encoding
    decorator.pause = ->
        res.pause()
    decorator.resume = ->
        res.resume()

    return decorator
