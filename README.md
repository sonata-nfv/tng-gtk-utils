[![Join the chat at https://gitter.im/sonata-nfv/Lobby](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/sonata-nfv/Lobby)

<p align="center"><img src="https://github.com/sonata-nfv/tng-api-gtw/wiki/images/sonata-5gtango-logo-500px.png" /></p>

# 5GTANGO Gatekeeper utils
This is the 5GTANGO Gatekeeper utils gem, which implements some utilitary features shared across the different Gatekeeper repositories: [`tng-gtk-common`](https://github.com/sonata-nfv/tng-gtk-common), [`tng-gtk-sp`](https://github.com/sonata-nfv/tng-gtk-sp) and [`tng-gtk-vnv`](https://github.com/sonata-nfv/tng-gtk-vnv).

The code for this utility library was extracted from those repositories and made available to them so that code shouldn't hang around duplicated.

For details on the overall 5GTANGO architecture please check [here](https://5gtango.eu/project-outcomes/deliverables/2-uncategorised/31-d2-2-architecture-design.html) and also in the [previously](https://github.com/sonata-nfv/tng-gtk-common) [mentioned](https://github.com/sonata-nfv/tng-gtk-sp) [repositories](https://github.com/sonata-nfv/tng-gtk-vnv).

## Features
This library implements some of the features that were being duplicated in the 5GTANGO Gatekeeper repositories mentioned above, [`tng-gtk-common`](https://github.com/sonata-nfv/tng-gtk-common), [`tng-gtk-sp`](https://github.com/sonata-nfv/tng-gtk-sp) and [`tng-gtk-vnv`](https://github.com/sonata-nfv/tng-gtk-vnv).

### Logger
Ruby's standard library already provides a [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html), which we want to extend and make it providing outputs such as the following (in JSON format):

```json
{
  "type": "I",
  "timestamp": "2018-10-18 15:49:08 UTC",
  "status": "END",
  "component": "tng-api-gtw",
  "operation": "package upload",
  "result": "package uploaded 201",
  "status_code": "201",
  "time_elapsed": "00:01:20"
}
```
The usual approach of redefining the formatter (see below) doesn't have the full flexibility. 

```ruby
Logger.new(logdev, formatter: proc {|severity, datetime, progname, msg|
  JSON.dump(timestamp: "#{datetime.to_s}", message: msg)
})
```

It should also support a `LOGLEVEL` variable that may assume one of the usual values `debug`, `info`, `warning`, `error`, `fatal` or `unknown` (defaults to `warning`, so only logging messages marked as `unknown`, `fatal`, `error` or `warning` are shown).

#### Example
```ruby
```

#### Dependencies

### Cache
The first ...

The `Tng::Gtk::Utils`' cache API is detailled next.

To use this, you need to require this library (`tng/gtk/utils`):

```ruby
require `tng/gtk/utils'
```

Then, in the `module` or `class` you want to use cache, just extend the module:
```ruby
  extend Tng::Gtk::Utils
```

Whenever you want to cache an `Hash`, just use the `cache` macro (or `module method`):
```ruby
cache {uuid: '4345444a-d659-4843-a618-ea43b8a1f9ba', whatever: 'else'}.to_json
```
For checking if we've got some `UUID` cached, just use the `cached?` macro:

```ruby
x = cached? '4345444a-d659-4843-a618-ea43b8a1f9ba'
```

#### Example
```ruby
require 'json'
require `tng/gtk/utils'

class Fetch
  extend Tng::Gtk::Utils
  
  class << self
    def call(params)
      do_validation_stuff
      
      cached = cached? params[:uuid] # now check if we've got this cached
      return JSON.parse(cached, symbolize_names: :true) if cached

      real_value = fetch_real_value # if here, then it's not cached: fetch real value
      cache real_value.to_json # and cache it for next time (and return it)
    end
  end  
end
```

#### Dependencies
uses Logger

### Fetch
The `Fetch` class works very much like Euby-on-Rails' `ActiveModel` gem, without all the complexities around it.

#### Example
```ruby
```

#### Dependencies
uses Cache and Logger

## Installing

This gem is implemented in [ruby](https://www.ruby-lang.org/en/), version **2.4.3**. 

### Installing globally

To install this gem in your system, please do:

```shell
git clone https://github.com/sonata-nfv/tng-gtk-utils.git # Clone this repository
cd tng-gtk-utils && gem build tng-gtk-utils.gemspec       # Build the gem
[sudo] gem install tng-gtk-utils-0.0.1.gem                # Install it (the filename/version may vary)
```
### Installing it via a Gemfile

To install this gem using a Gemfile, please add the following line to that file:

```ruby
gem 'tng-gtk-utils', git: 'https://github.com/sonata-nfv/tng-gtk-utils'
```

## Developing
This section covers all the needs a developer has in order to be able to contribute to this project.

### Dependencies
We are using the following libraries (also referenced in the [`Gemfile`](https://github.com/sonata-nfv/tng-gtk-sp/Gemfile) file) for development:

* `activerecord` (`5.2`), the *Object-Relational Mapper (ORM)*;
* `bunny` (`2.8.0`), the adapter to the [RabbitMQ](https://www.rabbitmq.com/) message queue server;
* `pg` (`0.21.0`), the adapter to the [PostgreSQL](https://www.postgresql.org/) database;
* `puma` (`3.11.0`), an application server;
* `rack` (`2.0.4`), a web-server interfacing library, on top of which `sinatra` has been built;
* `rake`(`12.3.0`), a dependencies management tool for ruby, similar to *make*;
* `sinatra` (`2.0.2`), a web framework for implementing efficient ruby APIs;
* `sinatra-activerecord` (`2.0.13`), 
* `sinatra-contrib` (`2.0.2`), several add-ons to `sinatra`;
* `sinatra-cross_origin` (`0.4.0`), a *middleware* to `sinatra` that helps in managing the [`Cross Origin Resource Sharing (CORS)`](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) problem;
* `sinatra-logger` (`0.3.2`), a *logger* *middleware*;

The following *gems* (libraries) are used just for tests:
* `ci_reporter_rspec` (`1.0.0`), a library for helping in generating continuous integration (CI) test reports;
* `rack-test` (`0.8.2`), a helper testing framework for `rack`-based applications;
* `rspec` (`3.7.0`), a testing framework for ruby;
* `rubocop` (`0.52.0`), a library for white box tests; 
* `rubocop-checkstyle_formatter` (`0.4.0`), a helper library for `rubocop`;
* `webmock` (`3.1.1`), which alows *mocking* (i.e., faking) HTTP calls;

These libraries are installed/updated in the developer's machine when running the command (see above):

```shell
$ bundle install
```

### Prerequisites
We usually use [`rbenv`](https://github.com/rbenv/rbenv) as the ruby version manager, but others like [`rvm`](https://rvm.io/) may work as well.

### Setting up Dev
Developing this library is straightforward with a low amount of necessary steps.



### Submiting changes
Changes to the repository can be requested using [this repository's issues](https://github.com/sonata-nfv/tng-gtk-utils/issues) and [pull requests](https://github.com/sonata-nfv/tng-gtk-utils/pulls) mechanisms.

## Versioning

The most up-to-date version is v4. For the versions available, see the [link to tags on this repository](https://github.com/sonata-nfv/tng-gtk-sp/releases).

## Configuration
The configuration of the micro-service is done through the following environment variables, defined in the [Dockerfile](https://github.com/sonata-nfv/tng-gtk-sp/blob/master/Dockerfile):

* `CATALOGUE_URL`, which defines the Catalogue's URL, where test descriptors are fetched from;
* `REPOSITORY_URL`, which defines the Repository's URL, where test plans and test results are fetched from;
* `DATABASE_URL`,  which defines the database's URL, in the following format: `postgresql://user:password@host:port/database_name` (**Note:** this is an alternative format to the one described in the [Installing from the Docker container](#installing-from-the-Docker-container) section);
* `MQSERVER_URL`,  which defines the message queue server's URL, in the following format: `amqp://user:password@host:port`

## Tests
Unit tests are defined for both `controllers` and `services`, in the `/spec` folder. Since we use `rspec` as the test library, we configure tests in the [`spec_helper.rb`](https://github.com/sonata-nfv/tng-gtk-sp/blob/master/spec/spec_helper.rb) file, also in the `/spec` folder.

These tests are executed by running the following command:
```shel
$ bundle exec rspec spec
```

Wider scope (integration and functional) tests involving this micro-service are defined in [`tng-tests`](https://github.com/sonata-nfv/tng-tests).

## Style guide
Our style guide is really simple:

1. We try to follow a [Clean Code](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) philosophy in as much as possible, i.e., classes and methods should do one thing only, have the least number of parameters possible, etc.;
1. we use two spaces for identation.

## API Reference

We have specified this micro-service's API in a [swagger](https://github.com/sonata-nfv/tng-gtk-sp/blob/master/doc/swagger.json)-formated file. Please check it there.

## Licensing

This 5GTANGO component is published under Apache 2.0 license. Please see the [LICENSE](https://github.com/sonata-nfv/tng-gtk-sp/blob/master/LICENSE) file for more details.
