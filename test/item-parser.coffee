ItemParser = require '../src/item-parser'

module.exports =
    'empty items are parsed correctly': (test) ->
        parser = new ItemParser

        parser.on 'error', (err) -> test.fail()
        parser.on 'end', (earnings) ->
            test.deepEqual earnings, []
            test.done()

        xml = "<?xml version=\"1.0\"?><Data><Items></Items><AMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></AMZNShipmentTotals><NonAMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></NonAMZNShipmentTotals><ShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ShipmentTotals><ReturnedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReturnedTotals><RefundedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></RefundedTotals><ReferralFeeTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReferralFeeTotals><EventTotals></EventTotals><FinalEarnings>0,00</FinalEarnings><ProductLine_array><ProductLine><GLProductGroupID>86</GLProductGroupID><ProductGroupName>Garten &amp; Freizeit</ProductGroupName></ProductLine></ProductLine_array></Data>"

        parser.write xml
        parser.close()

    'one item is parsed correctly': (test) ->
        parser = new ItemParser

        parser.on 'error', (err) -> test.fail()
        parser.on 'end', (earnings) ->
            test.deepEqual earnings, [
                {
                    asin: '0060527307'
                    category: '14'
                    date: 'July 07, 2008'
                    edate: '1215414000'
                    earnings: '0.60'
                    linktype: 'asn'
                    price: '7.99'
                    qty: '1'
                    rate: '7.51'
                    revenue: '7.99'
                    seller: 'Amazon.com'
                    tag: 'cse-ce- 20'
                    subtag: '92164|1|ma'
                    title: 'Double Shot (Goldy Culinary Mysteries, Book 12)'
                }
            ]
            test.done()

        xml = "<?xml version=\"1.0\"?><Data><Items><Item ASIN=\"0060527307\" Category=\"14\" Date=\"July 07, 2008\" EDate=\"1215414000\" Earnings=\"0.60\" LinkType=\"asn\" Price=\"7.99\" Qty=\"1\" Rate=\"7.51\" Revenue=\"7.99\" Seller=\"Amazon.com\" Tag=\"cse-ce- 20\" SubTag=\"92164|1|ma\" Title=\"Double Shot (Goldy Culinary Mysteries, Book 12)\"/></Items><AMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></AMZNShipmentTotals><NonAMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></NonAMZNShipmentTotals><ShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ShipmentTotals><ReturnedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReturnedTotals><RefundedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></RefundedTotals><ReferralFeeTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReferralFeeTotals><EventTotals></EventTotals><FinalEarnings>0,00</FinalEarnings><ProductLine_array><ProductLine><GLProductGroupID>86</GLProductGroupID><ProductGroupName>Garten &amp; Freizeit</ProductGroupName></ProductLine></ProductLine_array></Data>"

        parser.write xml
        parser.close()

    'three items are parsed correctly': (test) ->
        parser = new ItemParser

        parser.on 'error', (err) ->
            console.log err
            test.fail()
        parser.on 'end', (earnings) ->
            expected = [
                {
                    asin: '0060527307'
                    category: '14'
                    date: 'July 07, 2008'
                    edate: '1215414000'
                    earnings: '0.60'
                    linktype: 'asn'
                    price: '7.99'
                    qty: '1'
                    rate: '7.51'
                    revenue: '7.99'
                    seller: 'Amazon.com'
                    tag: 'cse-ce- 20'
                    subtag: '92164|1|ma'
                    title: 'Double Shot (Goldy Culinary Mysteries, Book 12)'
                }
                {
                    asin: '0060527323'
                    category: '14'
                    date: 'July 07, 2008'
                    edate: '1215414000'
                    earnings: '0.60'
                    linktype: 'asn'
                    price: '7.99'
                    qty: '1'
                    rate: '7.51'
                    revenue: '7.99'
                    seller: 'Amazon.com'
                    tag: 'cse-ce- 20'
                    subtag: '92165|3|mb'
                    title: 'Dark Tort (Goldy Culinary Mysteries, Book 13)'

                }
                {
                    asin: '0060723939'
                    category: '14'
                    date: 'July 07, 2008'
                    edate: '1215414000'
                    earnings: '1.12'
                    linktype: 'asn'
                    price: '14.93'
                    qty: '1'
                    rate: '7.50'
                    revenue: '14.93'
                    seller: 'Amazon.com'
                    tag: 'cse- ce-20'
                    subtag: '92166|3|mc'
                    title: 'Crooked Little Vein: A Novel'
                }
            ]

            test.deepEqual earnings, expected
            test.done()


        xml = "<?xml version=\"1.0\"?><Data><Items><Item ASIN=\"0060527307\" Category=\"14\" Date=\"July 07, 2008\" EDate=\"1215414000\" Earnings=\"0.60\" LinkType=\"asn\" Price=\"7.99\" Qty=\"1\" Rate=\"7.51\" Revenue=\"7.99\" Seller=\"Amazon.com\" Tag=\"cse-ce- 20\" SubTag=\"92164|1|ma\" Title=\"Double Shot (Goldy Culinary Mysteries, Book 12)\"/><Item ASIN=\"0060527323\" Category=\"14\" Date=\"July 07, 2008\" EDate=\"1215414000\" Earnings=\"0.60\" LinkType=\"asn\" Price=\"7.99\" Qty=\"1\" Rate=\"7.51\" Revenue=\"7.99\" Seller=\"Amazon.com\" Tag=\"cse-ce- 20\" SubTag=\"92165|3|mb\" Title=\"Dark Tort (Goldy Culinary Mysteries, Book 13)\"/><Item ASIN=\"0060723939\" Category=\"14\" Date=\"July 07, 2008\" EDate=\"1215414000\" Earnings=\"1.12\" LinkType=\"asn\" Price=\"14.93\" Qty=\"1\" Rate=\"7.50\" Revenue=\"14.93\" Seller=\"Amazon.com\" Tag=\"cse- ce-20\"SubTag=\"92166|3|mc\" Title=\"Crooked Little Vein: A Novel\"/></Items><AMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></AMZNShipmentTotals><NonAMZNShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></NonAMZNShipmentTotals><ShipmentTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ShipmentTotals><ReturnedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReturnedTotals><RefundedTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></RefundedTotals><ReferralFeeTotals><Earnings>0,00</Earnings><Revenue>0,00</Revenue><Units>0</Units></ReferralFeeTotals><EventTotals></EventTotals><FinalEarnings>0,00</FinalEarnings><ProductLine_array><ProductLine><GLProductGroupID>86</GLProductGroupID><ProductGroupName>Garten &amp; Freizeit</ProductGroupName></ProductLine></ProductLine_array></Data>"

        parser.write xml
        parser.close()
