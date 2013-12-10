events = require 'events'

sax = require 'sax'

module.exports = ->
    reportsSoFar = []

    currentIncompleteReport = {}
    mode = 'searching-for-end-of-table-head'

    reportParser = new events.EventEmitter

    strict = false
    saxParser = sax.parser strict
    saxParser.onerror = (err) ->
        reportParser.emit 'error', err
    saxParser.onend = ->
        reportParser.emit 'end', reportsSoFar
    saxParser.onopentag = ({name}) ->
        if mode is 'searching-for-next-row' and name is 'TR'
            mode = 'reading-filename'
    saxParser.ontext = (text) ->
        switch mode
            when 'reading-filename'
                currentIncompleteReport.filename = text
                mode = 'reading-last-modified'
            when 'reading-last-modified'
                currentIncompleteReport.lastModified = text
                mode = 'reading-md5'
            when 'reading-md5'
                currentIncompleteReport.md5 = text
                mode = 'reading-size'
            when 'reading-size'
                currentIncompleteReport.size = text
                mode = 'reading-url'
    saxParser.onattribute = ({name, value}) =>
        if mode is 'reading-url' and name is 'HREF'
            currentIncompleteReport.url = value
            reportsSoFar.push currentIncompleteReport
            currentIncompleteReport = {}
            mode = 'searching-for-next-row'
    saxParser.onclosetag = (name) ->
        # the first closing TR is the end of the table head
        if mode is 'searching-for-end-of-table-head' and name is 'TR'
            mode = 'searching-for-next-row'

    reportParser.write = (data) ->
        saxParser.write data
    reportParser.close = ->
        saxParser.close()

    return reportParser
