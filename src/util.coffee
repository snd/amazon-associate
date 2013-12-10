crypto = require 'crypto'

module.exports.md5 = (string) ->
    hash = crypto.createHash 'md5'
    hash.update string
    return hash.digest 'hex'

module.exports.parseResponse = (res, parser, cb) ->
    parser.on 'error', (err) ->
        cb err
    parser.on 'end', (result) ->
        cb null, result

    res.on 'error', (err) ->
        cb err
    res.on 'data', (data) ->
        parser.write data

    res.on 'end', ->
        parser.close()
