Shooting errors with Raygun.io
==============================

I've been playing with [Raygun.io](http://raygun.io) over the last day or so. It's a tool, like Honeybadger, Airbrake or Errbit, for managing exceptions from other web or mobile applications. It will email you when exceptions occur, collapse duplicate errors together, and allows a team to comment and resolve exceptions from their nicely designed web interface.

I've come to the conclusion that integrating with something like this is basically a minimum requirement for software these days. Previously we might've suggested an 'iterative' approach of emailing exceptions directly from the application before later using one of these services, but I no longer see the benefit in postponing a better solution when it's far simpler to work with one of these services than it is to set up email reliably.

It seems pretty trivial to integrate with a Rails application -- just run a generator to create the initializer complete with API key. However, I had to do a bit more work to hook it into a Rack application (which is what {l vanilla} is). In my `config.ru`:

{code raygun-rack}

The documentation for this is available on the [Raygun.io site](http://raygun.io), but at the moment the actual documentation link on their site points to [a gem](https://github.com/j-mcnally/RaygunRuby), which more-confusingly isn't actually [the gem](https://github.com/MindscapeHQ/raygun4ruby) that you will have installed. Reading the documentation in the gem README also reveals how to integrate with Resque, to catch exceptions in background jobs.

One thing that's always worth checking when integrating with exception reporting services is whether or not they support SSL, and thankfully it looks like that's the default (and indeed only option) here.

The Raygun server also sports a few plugins (slightly hidden under 'Application Settings') for logging exception data to HipChat, Campfire and the like. I'd like to see a generic webhook plugin supported, so that I could integrate exception notification into other tools that I write; thankfully that's the [number one feature request](http://raygun.io/thinktank/suggestion/392) at the moment.

My other request would be that the gem should try not to depend on activesupport if possible. I realise for usage within Rails, this is a non-issue, but for non-Rails applications, loading ActiveSupport can introduce a number of other gems that bloat the running Ruby process. As far as I can tell, the only methods from ActiveSupport that are used are `Hash#blank?` (which is effectively the same as `Hash#empty?`) and `String#starts_with?` (which is just an alias for the Ruby-default `String#start_with?`). Pull request submitted.


:kind: blog
:created_at: 2013-08-28 22:05:54 -0500
:updated_at: 2013-08-28 22:05:54 -0500
:raygun-rack: |
  # Setup Raygun and add it to the middleware
  require 'raygun'
  Raygun.setup do |config|
    config.api_key = ENV["RAYGUN_API_KEY"]
  end
  use Raygun::RackExceptionInterceptor

  # Raygun will re-raise the exception, so catch it with something else
  use Rack::ShowExceptions
