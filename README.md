# Pinocchio

Pinocchio will answer your request as your current of future API. Even if he needs to lie.

## What is it?

Pinocchio is a library to stubs an API when you can't, or want, to replace the network api you are using.

It's first appearence was on a SPA that works as ATM for school canteens. It stubs our API, so I my test are more close to what happens at The Real World.

My first need was to test a Single Page Application. That communicates with an API.
The SPA is served by a Rack app, responsible to concatenate every JS and CSS to one file of each kind. And, all html template to one single page HTML with env vars on it.

So, to test this rack application using capybara which leads to good descriptions on how it behaves.

## What is it NOT?

[FakeWeb](https://github.com/chrisk/fakeweb) - I'm not try to change browser requests API.

[Webmock](https://github.com/bblimke/webmock) -  I'm not try to change browser requests API.

[VCR](https://github.com/vcr/vcr) - It's kind of hard to parse VCR cassettes. So, I try to keep as simple as I needed.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pinocchio', :git => 'git@github.com:/acdesouza/pinocchio.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem specific_install https://github.com/acdesouza/pinocchio.git

## Usage

My first need was to test a Single Page Application. That communicates with an API.

The use case is simple: you write a bunch of ymls matching HTTP requests your client will do.
You teach then to Pinocchio and he'll behavior as it is your API.

But to get to Pinocchio you gotta to do:

1. Wake up Geppeto, passing a pinewood log with stuffs he can work.
1. Ask Geppeto to carve a wooden boy

That's all! From your order to Geppeto's delivery the Blue Fairy will animate the wooden boy, leaving you with Pinocchio.

Now, you teach him the lies you would like he knows.


### "Dude! Could explain again, using Ruby code?"

Put it on a test/test_helper.rb

```ruby
require 'pinocchio'

Pinocchio::Geppetto.wake_up do |pinewood|
  pinewood.logger = test_logger
  pinewood.server_host = 'localhost'
  pinewood.server_port = 3042
end
```

To make sure Pinocchio will not remember lies from test to test, put on your main test class:

```ruby
class IntegrationTest < Minitest::Test

  # Order a wooden boy to Geppeto
  def setup
    @pinocchio = Pinocchio::Geppetto.carve
  end

  # Make sure you erase Pinocchio memory
  def teardown
    @pinocchio = nil
  end

  # Adds a way to access it from your tests
  def pinocchio
    @pinocchio
  end
end
```

Create your lie, I like the path - test/fixtures/requests/api:
```yml

method: "get"
url: "/hello_world"
response:
  code: 200
  Content-Type: "text/plain"
  body: "Hello World!"
```


On your test:

```ruby
class HelloTest < IntegrationTest

  def test_should_return_a_hello
    pinocchio.learn("test/fixtures/requests/api/hello.yml")

    # Requests to http://localhost:3042/hello_world should get Hello World! as response
  end
end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acdesouza/pinocchio.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
