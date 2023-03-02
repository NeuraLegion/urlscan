# urlscan

TODO: Write a description here

## Installation

TODO: Write installation instructions here

## Usage

Simple example:

```bash
urlscan --url https://www.google.com --method GET
```

This will output the request and response body as HAR to the console.
You can use a simple pipe to save it to a file:

```bash
urlscan --url https://www.google.com --method GET > google.har
```

Full usage:

```bash
Usage: urlscan [arguments]
    -u URL, --url=URL                Target URL
    -m METHOD, --method=METHOD       HTTP Method to use (GET/POST/etc..)
    -b BODY, --body=BODY             Body to send
    -H HEADER, --header=HEADER       Header to send (NAME:VALUE)
    -h, --help
```


## Contributing

1. Fork it (<https://github.com/NeuraLegion/urlscan/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Bar Hofesh](https://github.com/your-github-user) - creator and maintainer
