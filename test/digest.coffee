digest = require '../src/digest'

challengeString = 'Digest realm="DataFeeds", qop="auth", nonce="69e3391d503ae9fd43e9b5202390d15a", opaque="0753652c1f86cb100ec28975b6a72fbf"'

challengeObject =
    realm: 'DataFeeds'
    qop: 'auth'
    nonce: '69e3391d503ae9fd43e9b5202390d15a'
    opaque: '0753652c1f86cb100ec28975b6a72fbf'

module.exports =

    'parseChallenge': (test) ->
        parsed = digest.parseChallenge challengeString
        test.deepEqual parsed, challengeObject
        test.done()

    'renderResponse': (test) ->
        response = digest.renderResponse challengeObject, 'user', 'password', 'path'
        test.equal response, '73aa51dddb42a1a2241db345a00a27ad'
        test.done()

    'renderDigest': (test) ->
        d = digest.renderDigest challengeObject, 'user', 'password', 'path'
        test.equal d, 'Digest username="user", realm="DataFeeds", nonce="69e3391d503ae9fd43e9b5202390d15a", uri="path", qop="auth", response="73aa51dddb42a1a2241db345a00a27ad", nc="000001", cnonce="", opaque="0753652c1f86cb100ec28975b6a72fbf"'
        test.done()
