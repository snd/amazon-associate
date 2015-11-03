{EventEmitter} = require 'events'

_ = require 'lodash'
sax = require 'sax'

module.exports = class extends EventEmitter
    constructor: ->
        @items = []
        @mode = 'search-item-list'

        @parser = sax.parser false
        @parser.onerror = (err) => @emit 'error', err
        @parser.onend = => @emit 'end', @items

        @parser.onopentag = ({name, attributes}) =>
            @mode = 'next-item' if @mode is 'search-item-list' and name is 'ITEMS'

            if @mode is 'next-item' and name is 'ITEM'
                item = {}
                _.each _.keys(attributes), (key) ->
                    item[key.toLowerCase()] = attributes[key]
                @items.push item

    write: (data) -> @parser.write data
    close: -> @parser.close()
