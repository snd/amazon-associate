# amazon-associate

simple interface to amazon associate reports

**this is very much work in progress**

### Install

    npm install amazon-associate

### Use

```coffeescript

Amazon = require 'amazon-associate'

amazon = new Amazon
    associateId: 'your amazon associate id'
    password: 'your password'
    # debug: true

amazon.getEarnings (new Date 2012, 5, 22), (err, earnings) ->
    throw err if err?
    console.log earnings
```

### API

- `getEarnings(cb)` calls `cb` with an array of earnings objects
    - String `asin` that is the [amazon standard identification number](http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number) of the product
    - String `category`
    - String `date`
    - String `edate`
    - String `earnings`
    - String `linktype`
    - String `price`
    - String `qty`
    - String `rate`
    - String `revenue`
    - String `seller` that is the name of the product's seller
    - String `subtag`
    - String `tag` that is the associate id
    - String `title` that is the product's title

### License: MIT
