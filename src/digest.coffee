util = require './util'

module.exports.parseChallenge = (challengeString) ->
    # header is something like this:
    # Digest realm="DataFeeds", qop="auth", nonce="69e3391d503ae9fd43e9b5202390d15a", opaque="0753652c1f86cb100ec28975b6a72fbf"

    obj = {}
    challengeString.substring(7).split(/,\s+/).forEach (part) ->
        [key, valueInQuotes] = part.split '='
        obj[key] = valueInQuotes.replace /"/g, ''
    return obj

module.exports.renderResponse = (challenge, username, password, path) ->
    h1 = util.md5 [username, challenge.realm, password].join ':'
    h2 = util.md5 ['GET', path].join ':'
    return util.md5 [h1, challenge.nonce, '000001', '', 'auth', h2].join ':'

module.exports.renderDigest = (challenge, username, password, path) ->
    params =
        username: username
        realm: challenge.realm
        nonce: challenge.nonce
        uri: path
        qop: challenge.qop
        response: module.exports.renderResponse challenge, username, password, path
        nc: '000001'
        cnonce: ''
        opaque: challenge.opaque

    parts = Object.keys(params).map (key) ->
        "#{key}=\"#{params[key]}\""

    return 'Digest ' + parts.join ', '
