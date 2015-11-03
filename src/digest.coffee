crypto = require 'crypto'

_ = require 'lodash'

md5 = (string) ->
    hash = crypto.createHash 'md5'
    hash.update string
    hash.digest 'hex'

module.exports = digest =

    parseChallenge: (challengeString) ->
        # header is something like this:
        # Digest realm="DataFeeds", qop="auth", nonce="69e3391d503ae9fd43e9b5202390d15a", opaque="0753652c1f86cb100ec28975b6a72fbf"

        obj = {}
        _.each challengeString.substring(7).split(/,\s+/), (part) ->
            [key, valueInQuotes] = part.split '='
            obj[key] = valueInQuotes.replace /"/g, ''
        return obj

    renderResponse: (challenge, username, password, path) ->
        h1 = md5 [username, challenge.realm, password].join ':'
        h2 = md5 ['GET', path].join ':'
        md5 [h1, challenge.nonce, '000001', '', 'auth', h2].join ':'

    renderDigest: (challenge, username, password, path) ->
        params =
            username: username
            realm: challenge.realm
            nonce: challenge.nonce
            uri: path
            qop: challenge.qop
            response: digest.renderResponse challenge, username, password, path
            nc: '000001'
            cnonce: ''
            opaque: challenge.opaque

        parts = _.map _.keys(params), (key) -> "#{key}=\"#{params[key]}\""

        'Digest ' + parts.join ', '
