Kintama
=======

An experimental test framework that I've been tinkering with.

[http://github.com/lazyatom/kintama](http://github.com/lazyatom/kintama)

I'm using it to explore a few different aspects or potential approaches to testing:

* {l setup-vs-action-for-ruby-tests}
* {l rerunning-tests-in-ruby}
* Making it easier for developers to create their own application-specific testing constructs to better express the behaviour they are trying to test.

What I have is a reasonably-compact testing framework with some 'modern' features like:

* nesting contexts
* matcher syntax
* flexible runners including running tests on specific lines
* flexible reporting of test output

I have slightly stalled working on it because:

* In it's most simple usage it's not very different from [RSpec][]
* I haven't really pushed into any of the exploration of things like `action` and rerunning tests yet
* While I have a hunch that it has a nice API that others *could* use to build their own testing constructs, I haven't really explored that either, and it's quite possible that [RSpec][] is just as easy to de/re-compose already.


Background
----

Those of you who attend {l LRUG} may have heard about the "test framework episode" that I had last year. Here's a diagram I drew at the time; a [crazy-wall][] of related test framework inventions and re-inventions:

![Ruby Testing Diaspora](/images/ruby-testing-diaspora.png)

I'll try to remember what originally prompted it; I *think* I had been struggling to refactor a large suite of tests (using [test-unit][] and [shoulda][]), and I was getting frustrated with how many hoops it felt like we had to jump through to test concisely.

It's related to thoughts I have had about {l setup-vs-action-for-ruby-tests}.

Humble beginnings
------

Initially I was interested in replicating the behaviour of the [test-unit][] + [shoulda][] combination, but with far less code. Here's [the first commit](https://github.com/lazyatom/kintama/commit/3aee44947aaf7c63e52714d783ac3a7c3addb137), so you can see how serious I was about simplicity.

Stepping through [each of the commits](https://github.com/lazyatom/kintama/commits/master), you can see that I tried to grow the library only using concrete tests that provided examples of the behaviour I expected. I believe that the commits also demonstrate some of the key choices that a DSL implementer has to make; see {l capturing-behaviour-in-ruby-dsls}.



[crazy-wall]: http://crazywalls.tumblr.com/
[test-unit]: http://ruby-doc.org/stdlib/libdoc/test/unit/rdoc/
[shoulda]: https://github.com/thoughtbot/shoulda
[rspec]: http://rspec.info

:created_at: 2013-01-04 09:53:06 -0600
:updated_at: 2013-01-04 09:53:06 -0600
