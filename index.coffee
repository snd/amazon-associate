_ = require 'underscore'
moment = require 'moment'

Client = require './lib/client'
ItemParser = require './lib/item-parser'
ReportParser = require './lib/report-parser'

parseResponse = (res, parser, cb) ->
    parser.on 'error', (err) -> cb err
    parser.on 'end', (result) -> cb null, result

    res.on 'error', (err) -> cb err
    res.on 'data', (data) -> parser.write data

    res.on 'end', -> parser.close()

module.exports = class

    debug: (args...) -> console.error 'amazon-associate:', args... if @options.debug

    constructor: (@options) ->
        throw new Error 'missing associateId option' if not @options.associateId?
        throw new Error 'missing password option' if not @options.password?
        _.defaults @options,
            host: 'assoc-datafeeds-eu.amazon.com'
            reportPath: '/datafeed/listReports'
            debug: false
        clientOptions =
            debug: @options.debug
            credentials: {}
        clientOptions.credentials[@options.host] =
            type: 'digest'
            username: @options.associateId
            password: @options.password
        @client = new Client clientOptions

    getReportUrl: (date, type) ->
        datestring = moment(date).format 'YYYYMMDD'
        filename = "#{@options.associateId}-#{type}-report-#{datestring}.xml.gz"
        "/datafeed/getReport?filename=#{filename}"

    _getItems: (date, type, cb) ->
        @client.request {
            https: true
            host: @options.host
            path: @getReportUrl date, type
            unzip: true
        }, (err, res) ->
            return cb err if err?
            datestring = moment(date).format 'YYYY-MM-DD'
            if res.headers['content-length'] is '0'
                return cb new Error "no #{type} for date #{datestring}"
            parser = new ItemParser
            parseResponse res, parser, cb

    getOrders: (date, cb) -> @_getItems date, 'orders', cb
    getEarnings: (date, cb) -> @_getItems date, 'earnings', cb

    getReports: (cb) ->
        @client.request {
            https: true
            host: @options.host
            path: @options.reportPath
            unzip: false
        }, (err, res) ->
            return cb err if err?
            parser = new ReportParser
            parseResponse res, parser, cb
