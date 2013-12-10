_ = require 'underscore'
moment = require 'moment'

newClient = require './client'
newItemParser = require './item-parser'
newReportParser = require './report-parser'
util = require './util'

module.exports = (options) ->
    # defensive cloning
    options = _.extend {}, options

    throw new Error 'missing option: "associateId"' if not options.associateId?
    throw new Error 'missing option: "password"' if not options.password?

    debug = (args...) ->
        options.debug args... if options.debug

    _.defaults options,
        host: 'assoc-datafeeds-eu.amazon.com'
        reportPath: '/datafeed/listReports'
        username: options.associateId

    sharedOptions =
        debug: options.debug
        credentials: {}

    sharedOptions.credentials[options.host] =
        type: 'digest'
        username: options.username
        password: options.password

    httpRequest = newClient()

    amazon = {}

    amazon.getReportUrl = (date, type) ->
        datestring = moment(date).format 'YYYYMMDD'
        filename = "#{options.associateId}-#{type}-report-#{datestring}.xml.gz"
        "/datafeed/getReport?filename=#{filename}"

    amazon.getItems = (date, type, cb) ->
        httpRequest _.extend({}, sharedOptions, {
            https: true
            host: options.host
            path: amazon.getReportUrl date, type
            unzip: true
        }), (err, res) ->
            return cb err if err?
            datestring = moment(date).format 'YYYY-MM-DD'
            if res.headers['content-length'] is '0'
                return cb new Error "no #{type} for date #{datestring}"
            parser = newItemParser()
            util.parseResponse res, parser, cb

    amazon.getOrders = (date, cb) ->
        amazon.getItems date, 'orders', cb

    amazon.getEarnings = (date, cb) ->
        amazon.getItems date, 'earnings', cb

    amazon.getReports = (cb) ->
        httpRequest _.extend({}, sharedOptions, {
            https: true
            host: options.host
            path: options.reportPath
            unzip: false
        }), (err, res) ->
            return cb err if err?
            parser = newReportParser()
            util.parseResponse res, parser, cb

    return amazon
