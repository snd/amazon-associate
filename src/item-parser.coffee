events = require 'events'

sax = require 'sax'

module.exports = ->
    itemsSoFar = []
    mode = 'searching-for-item-list'

    itemParser = new events.EventEmitter

    strict = false
    saxParser = sax.parser strict
    saxParser.onerror = (err) ->
        itemParser.emit 'error', err
    saxParser.onend = ->
        itemParser.emit 'end', itemsSoFar
    saxParser.onopentag = ({name, attributes}) ->
        if mode is 'searching-for-item-list' and name is 'ITEMS'
            mode = 'searching-for-next-item'

        if mode is 'searching-for-next-item' and name is 'ITEM'
            item = {}
            Object.keys(attributes).forEach (key) ->
                item[key.toLowerCase()] = attributes[key]
            itemsSoFar.push item

    itemParser.write = (data) ->
        saxParser.write data
    itemParser.close = ->
        saxParser.close()

    return itemParser
