# BookingSync OAuth Helper

Small sinatra application to help you get your OAuth Token for your BookingSync Application.
This is specially useful to play around BookingSync API v3.

## Usage

### Requirements:

[POW](http://pow.cx/) - To run this Sinatra application.
[Tunnelss](https://github.com/rchampourlier/tunnelss) - To use SSL

_Note: Tricks for [persiting SSL with Tunnelss over reboot](http://www.sebgrosjean.com/en/news/2014/2/9/rails-with-ssl-in-development-with-pow-and-tunnels)_

### 1) Install dependencies

```sh
bundle install
```

### 2) Setup your BookingSync Application credentials

```sh
cp .powenv.sample .powenv
```

Edit the `BOOKINGSYNC_CLIENT_ID`, `BOOKINGSYNC_CLIENT_SECRET` and `BOOKINGSYNC_SCOPE` environment variables from the `.powenv` file.

### 3) Restart Pow

Make sure to restart Pow, using:

```sh
touch tmp/restart.txt
```

You can then use the [BookingSync API gem](https://github.com/BookingSync/bookingsync-api) to consume the API

Example in IRB console:

```ruby
require 'bookingsync-api'
require 'json'
api = BookingSync::API.new(YOUR_OAUTH_TOKEN)
api.rentals.first.name
```

## License

Copyright (c) 2014-present Sébastien Grosjean and [BookingSync.com](http://www.bookingsync.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.