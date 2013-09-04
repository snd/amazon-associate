ReportParser = require '../src/report-parser'

module.exports =
    'empty reports are parsed correctly': (test) ->
        parser = new ReportParser

        parser.on 'error', -> test.fail()
        parser.on 'end', (reports) ->
            test.deepEqual reports, []
            test.done()

        parser.write "<HTML><HEAD><LINK href='stylesheets/style.css' rel='stylesheet' type='text/css'/></HEAD><BODY><TABLE class='datatable'><TR><TH>Filename</TH><TH>Last Modified</TH><TH>MD5</TH><TH>Size</TH><TH>Download URL</TH></TR></TABLE></BODY></HTML>"

        parser.close()

    'a single report is parsed correctly': (test) ->
        parser = new ReportParser

        parser.on 'error', -> test.fail()
        parser.on 'end', (reports) ->
            test.deepEqual reports,
                [
                    {
                        filename: 'gynny-21-earnings-report-20120506.tsv.gz'
                        lastModified: 'Thu Jun 07 14:42:40 GMT 2012'
                        md5: '"9e65e79b66679c779ff322a658c479df"'
                        size: '186'
                        url: 'getReport?filename=gynny-21-earnings-report-20120506.tsv.gz'
                    }
                ]
            test.done()

        parser.write "<HTML><HEAD><LINK href='stylesheets/style.css' rel='stylesheet' type='text/css'/></HEAD><BODY><TABLE class='datatable'><TR><TH>Filename</TH><TH>Last Modified</TH><TH>MD5</TH><TH>Size</TH><TH>Download URL</TH></TR><TR><TD>gynny-21-earnings-report-20120506.tsv.gz</TD><TD>Thu Jun 07 14:42:40 GMT 2012</TD><TD>\"9e65e79b66679c779ff322a658c479df\"</TD><TD>186</TD><TD><a href='getReport?filename=gynny-21-earnings-report-20120506.tsv.gz'>click to download</a></TD></TR></TABLE></BODY></HTML>"

        parser.close()

    'three reports are parsed correctly': (test) ->
        parser = new ReportParser

        parser.on 'error', -> test.fail()
        parser.on 'end', (reports) ->
            test.deepEqual reports,
                [
                    {
                        filename: 'gynny-21-earnings-report-20120506.tsv.gz'
                        lastModified: 'Thu Jun 07 14:42:40 GMT 2012'
                        md5: '"9e65e79b66679c779ff322a658c479df"'
                        size: '186'
                        url: 'getReport?filename=gynny-21-earnings-report-20120506.tsv.gz'
                    }
                    {
                        filename: 'gynny-21-earnings-report-20120506.xml.gz'
                        lastModified: 'Thu Jun 07 14:42:35 GMT 2012'
                        md5: '"f317a5689822bd67c72e133f39f431ee"'
                        size: '823'
                        url: 'getReport?filename=gynny-21-earnings-report-20120506.xml.gz'
                    }
                    {
                        filename: 'gynny-21-earnings-report-20120507.tsv.gz'
                        lastModified: 'Thu Jun 07 14:42:30 GMT 2012'
                        md5: '"0cba75d3edb2fd4e9c14696166de322b"'
                        size: '186'
                        url: 'getReport?filename=gynny-21-earnings-report-20120507.tsv.gz'
                    }
                ]
            test.done()

        parser.write "<HTML><HEAD><LINK href='stylesheets/style.css' rel='stylesheet' type='text/css'/></HEAD><BODY><TABLE class='datatable'><TR><TH>Filename</TH><TH>Last Modified</TH><TH>MD5</TH><TH>Size</TH><TH>Download URL</TH></TR><TR><TD>gynny-21-earnings-report-20120506.tsv.gz</TD><TD>Thu Jun 07 14:42:40 GMT 2012</TD><TD>\"9e65e79b66679c779ff322a658c479df\"</TD><TD>186</TD><TD><a href='getReport?filename=gynny-21-earnings-report-20120506.tsv.gz'>click to download</a></TD></TR><TR><TD>gynny-21-earnings-report-20120506.xml.gz</TD><TD>Thu Jun 07 14:42:35 GMT 2012</TD><TD>\"f317a5689822bd67c72e133f39f431ee\"</TD><TD>823</TD><TD><a href='getReport?filename=gynny-21-earnings-report-20120506.xml.gz'>click to download</a></TD></TR><TR><TD>gynny-21-earnings-report-20120507.tsv.gz</TD><TD>Thu Jun 07 14:42:30 GMT 2012</TD><TD>\"0cba75d3edb2fd4e9c14696166de322b\"</TD><TD>186</TD><TD><a href='getReport?filename=gynny-21-earnings-report-20120507.tsv.gz'>click to download</a></TD></TR></TABLE></BODY></HTML>"

        parser.close()
