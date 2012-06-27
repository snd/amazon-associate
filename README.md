# amazon associate

simple interface to amazon associate reports

**NOTE** this is very much work in progress

### Install

    npm install amazon-associate

### Use

```coffeescript

Amazon = require 'amazon-associate'

amazon = new Amazon
    associateId: 'your amazon associate id'
    password: 'your password'
    # debug: true

amazon.getReports (err, reports) ->
    throw err if err?
    console.log reports

    amazon.getEarnings (new Date 2012, 5, 22), (err, earnings) ->
        throw err if err?
        console.log earnings

        amazon.getOrders (new Date 2012, 5, 22), (err, orders) ->
            throw err if err?
            console.log orders
```

### License: MIT
