# amazon-associate

[![Build Status](https://travis-ci.org/snd/amazon-associate.png)](https://travis-ci.org/snd/amazon-associate)

amazon-associate is a simple interface to amazon associate reports for nodejs

### install

```
npm install amazon-associate
```

### use

```javascript
var Amazon = require('amazon-associate');

var amazon = new Amazon({
    associateId: 'your amazon associate id',
    password: 'your password',
    host: 'assoc-datafeeds-na.amazon.com', // (default 'assoc-datafeeds-eu.amazon.com')
    debug: true // print debug output to the console (optional)
})

amazon.getEarnings(new Date(2012, 5, 22), function(err, earnings) {
    if (err) {
        throw err;
    }
    console.log(earnings);
});
```

### api

- `getEarnings(date, cb)` calls `cb` with the earnings of the given date.
    each earning has the properties:
    - `asin` [amazon standard identification number](http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number) of the product
    - `category` id of the category of the product
    - `date` date in a format like `September 25, 2012`
    - `edate` date as posix time
    - `earnings` amount that was earned for the associate program
    - `linktype`
    - `price` price of the product
    - `qty` quantity that was bought of the product
    - `rate` percentage of the earnings on the price
    - `revenue`
    - `seller` name of the product's seller
    - `subtag` subtag used in the affiliate link
    - `tag` associate id
    - `title` title of the product
- `getOrders(date, cb)` calls `cb` with the orders of the given date.
    each order has the properties:
    - `asin` [amazon standard identification number](http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number) of the product
    - `category` id of the category of the product
    - `clicks`
    - `conversion`
    - `dqty`
    - `date` date in a format like `September 25, 2012`
    - `linktype`
    - `nqty`
    - `price` price of the product
    - `qty` quantity that was bought of the product
    - `subtag` subtag used in the affiliate link
    - `tag` associate id
    - `title` title of the product

### license: MIT
