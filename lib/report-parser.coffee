{EventEmitter} = require 'events'

sax = require 'sax'

module.exports = class extends EventEmitter
    constructor: ->
        @reports = []
        @report = {}
        @mode = 'search-table-head-end'

        @parser = sax.parser false
        @parser.onerror = (err) => @emit 'error', err
        @parser.onend = => @emit 'end', @reports

        @parser.onopentag = ({name}) =>
            @mode = 'read-filename' if @mode is 'next-row' and name is 'TR'

        @parser.ontext = (text) =>
            switch @mode
                when 'read-filename'
                    @report.filename = text
                    @mode = 'read-last-modified'
                when 'read-last-modified'
                    @report.lastModified = text
                    @mode = 'read-md5'
                when 'read-md5'
                    @report.md5 = text
                    @mode = 'read-size'
                when 'read-size'
                    @report.size = text
                    @mode = 'read-url'

        @parser.onattribute = ({name, value}) =>
            if @mode is 'read-url' and name is 'HREF'
                @report.url = value
                @reports.push @report
                @report = {}
                @mode = 'next-row'

        @parser.onclosetag = (name) =>
            @mode = 'next-row' if @mode is 'search-table-head-end' and name is 'TR'

    write: (data) -> @parser.write data
    close: -> @parser.close()
