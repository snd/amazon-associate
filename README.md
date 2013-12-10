# amazon-associate

[![Build Status](https://travis-ci.org/snd/amazon-associate.png)](https://travis-ci.org/snd/amazon-associate)

amazon-associate is a simple interface to amazon associate reports for nodejs

### install

```
npm install amazon-associate
```

**or**

put this line in the dependencies section of your `package.json`:

```
"amazon-associate": "0.4.0"
```

then run:

```
npm install
```

### use

```javascript
var newAmazon = require('amazon-associate');

var amazon = newAmazon({
    associateId: 'your amazon associate id', // mandatory
    username: 'your amazon username', // (default: the same as the associateId option)
    password: 'your password', // mandatory
    host: 'assoc-datafeeds-na.amazon.com', // (default 'assoc-datafeeds-eu.amazon.com')
    debug:
        // a function that will be called by amazon associate with debug information (optional)
        function () {
            args = ['AMAZON ASSOCIATE DEBUG'].concat(arguments);
            console.log.apply(null, args);
        }
})

amazon.getEarnings(new Date(2012, 5, 22), function(err, earnings) {
    if (err) {
        throw err;
    }
    console.log(earnings);
});

amazon.getOrders(new Date(2012, 5, 22), function(err, orders) {
    if (err) {
        throw err;
    }
    console.log(orders);
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
