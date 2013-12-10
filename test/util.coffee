util = require '../src/util'

module.exports =

    'md5': (test) ->
        hashed = util.md5('test')
        test.equal hashed, '098f6bcd4621d373cade4e832627b4f6'
        test.done()

