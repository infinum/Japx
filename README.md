# JSONAPIParser

[![CI Status](http://img.shields.io/travis/vlaho.poluta@infinum.hr/JSONAPIParser.svg?style=flat)](https://travis-ci.org/vlaho.poluta@infinum.hr/JSONAPIParser)
[![Version](https://img.shields.io/cocoapods/v/JSONAPIParser.svg?style=flat)](http://cocoapods.org/pods/JSONAPIParser)
[![License](https://img.shields.io/cocoapods/l/JSONAPIParser.svg?style=flat)](http://cocoapods.org/pods/JSONAPIParser)
[![Platform](https://img.shields.io/cocoapods/p/JSONAPIParser.svg?style=flat)](http://cocoapods.org/pods/JSONAPIParser)

Lightweight [JSON:API](http://jsonapi.org/) parser that flattens complex [JSON:API](http://jsonapi.org/) structure and turns it into simple JSON and vice versa.
It works by transferring `Dictionary` to `Dictionary`, so you can use [Codable](https://developer.apple.com/documentation/swift/codable), [Unbox](https://github.com/JohnSundell/Unbox), [Wrap](https://github.com/JohnSundell/Wrap), [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) or any other object mapping tool that you prefer.

# Basic example

For given example of JSON object:
```json
{
    "data": {
        "id": "1",
        "type": "users",
        "attributes": {
            "email": "john@infinum.co",
            "username": "john"
        }
    }
}
```

parser will convert it to object where all properties inside `attributes` object will be flatted to the root of `data` object:

```json
{
    "data": {
        "email": "john@infinum.co",
        "id": "1",
        "username": "john",
        "type": "users"
    }
}
```

## Advanced examples

### Parsing relationships

Simple `Article` object which has its `Author`:

```json
{
    "data": [
        {
            "type": "articles",
            "id": "1",
            "attributes": {
                "title": "JSON API paints my bikeshed!",
                "body": "The shortest article. Ever.",
                "created": "2015-05-22T14:56:29.000Z",
                "updated": "2015-05-22T14:56:28.000Z"
            },
            "relationships": {
                "author": {
                    "data": {
                        "id": "42",
                        "type": "people"
                    }
                }
            }
        }
    ],
    "included": [
        {
            "type": "people",
            "id": "42",
            "attributes": {
                "name": "John",
                "age": 80,
                "gender": "male"
            }
        }
    ]
}
```

will be flattened to:

```json
{
    "data": [
        {
            "updated": "2015-05-22T14:56:28.000Z",
            "author": {
                "age": 80,
                "id": "42",
                "gender": "male",
                "type": "people",
                "name": "John"
            },
            "id": "1",
            "title": "JSON API paints my bikeshed!",
            "created": "2015-05-22T14:56:29.000Z",
            "type": "articles",
            "body": "The shortest article. Ever."
        }
    ]
}
```

### Parsing additional information

All nested object which do not have keys defined in [JSON:API Specification](http://jsonapi.org/format) will be left inside root object intact (same goes for `links` and `meta` objects):

```json
{
    "data": [
        {
            "type": "articles",
            "id": "3",
            "attributes": {
                "title": "JSON API paints my bikeshed!",
                "body": "The shortest article. Ever.",
                "created": "2015-05-22T14:56:29.000Z",
                "updated": "2015-05-22T14:56:28.000Z"
            }
        }
    ],
    "meta": {
        "total-pages": 13
    },
    "links": {
        "self": "http://example.com/articles?page[number]=3&page[size]=1",
        "first": "http://example.com/articles?page[number]=1&page[size]=1",
        "prev": "http://example.com/articles?page[number]=2&page[size]=1",
        "next": "http://example.com/articles?page[number]=4&page[size]=1",
        "last": "http://example.com/articles?page[number]=13&page[size]=1"
    },
    "additional": {
        "info": "My custom info"
    }
}
```

Parsed JSON:

```json
{
    "data": [
        {
            "updated": "2015-05-22T14:56:28.000Z",
            "id": "3",
            "title": "JSON API paints my bikeshed!",
            "created": "2015-05-22T14:56:29.000Z",
            "type": "articles",
            "body": "The shortest article. Ever."
        }
    ],
    "meta": {
        "total-pages": 13
    },
    "links": {
        "prev": "http://example.com/articles?page[number]=2&page[size]=1",
        "first": "http://example.com/articles?page[number]=1&page[size]=1",
        "next": "http://example.com/articles?page[number]=4&page[size]=1",
        "self": "http://example.com/articles?page[number]=3&page[size]=1",
        "last": "http://example.com/articles?page[number]=13&page[size]=1"
    },
    "additional": {
        "info": "My custom info"
    }
}
```

## Installation

JSONAPIParser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod 'JSONAPIParser'
```
We've added some more functionalites by conforming to Codable for object mapping or Alamofre for networking.
You can find those convinience extansions here: 

With Codable (i.e. Decodable / Encodable):
```ruby
pod 'JSONAPIParser/Codable'
```

With Alamofire:
```ruby
pod 'JSONAPIParser/Alamofire'
```

With Alamofire and RxSwift using Single trait:
```ruby
pod 'JSONAPIParser/RxAlamofire'
```

With Alamofire and Codable:
```ruby
pod 'JSONAPIParser/CodableAlamofire'
```

With Alamofire, Codable and RxSwift:
```ruby
pod 'JSONAPIParser/RxCodableAlamofire'
```

## Usage

TODO

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Authors

* Vlaho Poluta, vlaho.poluta@infinum.hr
* Filip Gulan, filip.gulan@infinum.hr

Maintained by [Infinum](http://www.infinum.co)

![Infinum](https://assets.infinum.co/infinum.png)


## License

JSONAPIParser is available under the MIT license. See the LICENSE file for more info.
