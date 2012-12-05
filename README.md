# amazon-associate

[![Build Status](https://travis-ci.org/snd/amazon-associate.png)](https://travis-ci.org/snd/amazon-associate)

amazon-associate is a simple interface to amazon associate reports for nodejs

### install

    npm install amazon-associate

### use

```coffeescript

Amazon = require 'amazon-associate'

amazon = new Amazon
    associateId: 'your amazon associate id'
    password: 'your password'
    debug: true # print debug output to the console (optional)

amazon.getEarnings (new Date 2012, 5, 22), (err, earnings) ->
    throw err if err?
    console.log earnings
```

### api

- `getEarnings(date, cb)` calls `cb` of the earnings of the given date.
    each earning has the following properties:
    - `asin` that is the [amazon standard identification number](http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number) of the product
    - `category` that is the id of the category of the product
    - `date` that is the date in a format like `September 25, 2012`
    - `edate` that is the date as posix time
    - `earnings` that is the amount that was earned for the associate program
    - `linktype`
    - `price` that is the price of the product
    - `qty` that is the quantity that was bought of the product
    - `rate` that is the percentage of the earnings on the price
    - `revenue`
    - `seller` that is the name of the product's seller
    - `subtag` that is the subtag used in the affiliate link
    - `tag` that is the associate id
    - `title` that is the title of the product
- `getOrders(date, cb)` calls `cb` of the orders of the given date.
    each order has the following properties:
    - `asin` that is the [amazon standard identification number](http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number) of the product
    - `category` that is the id of the category of the product
    - `clicks`
    - `conversion`
    - `dqty`
    - `date` that is the date in a format like `September 25, 2012`
    - `linktype`
    - `nqty`
    - `price` that is the price of the product
    - `qty` that is the quantity that was bought of the product
    - `subtag` that is the subtag used in the affiliate link
    - `tag` that is the associate id
    - `title` that is the title of the product

### license: MIT
