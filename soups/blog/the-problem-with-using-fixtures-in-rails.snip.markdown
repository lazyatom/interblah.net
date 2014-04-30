The problem with using fixtures in Rails
========================================

I've been trying to largely ignore the recent [TDD discussion][dhh-tdd] prompted by DHH's [RailsConf 2014 keynote][keynote]. I think I can understand where he's coming from, and my only real concern with not sharing his point of view is that it makes it less likely that Rails will be steered in a direction which makes TDD easier. But that's OK, and my concern grows then I have [opportunities to propose improvements][rails-contributing].

I don't even really mind what he's said in his latest post about [unit testing the Basecamp codebase][dhh-fixtures]. There are a lot of Rails applications -- including ones I've written -- where a four-minute test suite would've been a huge triumph.

I could make some pithy argument like:

![Sorry, I couldn't resist](http://www.livememe.com/2loamu9.jpg)

... but let's be honest, four minutes for a substantial and mature codebase is pretty excellent in the Rails world.

So that *is* actually pretty cool.


## Using fixtures

A lot of that speed is no doubt because Basecamp is using fixtures: test data that is loaded once at the start of the test run, and then reset by wrapping each test in a transaction and rolling back before starting the next test.

This can be a benefit because the alternative -- assuming that you want to get some data into the database before your test runs -- is to insert all the data required for each test, which can potentially involve a large tree of related models. Doing this hundreds or thousands of times will definitely slow your test suite down.

_(Note that for the purposes of my point below, I'm deliberately not considering the option of not hitting the database at all. In reality, that's what I'd do, but let's just imagine that it wasn't an option for a second, yeah? OK, great.)_

So, fixtures will probably make the whole test suite faster. Sounds good, right?


## The problem with fixtures

I feel like this is glossing over the real problem with fixtures: unless you are using independent fixtures for each test, your shared fixtures have coupled your tests together. Since I'm pretty sure that nobody is actually using independent fixtures for every test, I am going to go out on a limb and just state:

**Fixtures have coupled your tests together.**

This isn't a new insight. This is pain that I've felt acutely in the past, and was my primary motivation for leaving fixtures behind.

Say you use the same 'user' fixture between two tests in different parts of your test suite. Modifying that fixture to respond to a change in one test can now potentially cause the other test to fail, if the assumptions either test was making about its test data are no longer true (e.g. the user should not be admin, the user should only have a short bio, or so on).

If you use fixtures and share them between tests, you're putting the burden of managing this coupling on yourself or the rest of your development team.

Going back to DHH's post:

> Why on earth would you run your entire test harness for every single line change in a particular model? If you have so little confidence in the locality of your changes, the tests are indeed telling you that the system has overly high coupling.

What fixtures do is introduce overly high coupling *in the test suite itself*. If you make *any* change to your fixtures, I do not think it's possible to be confident that you haven't broken a single test unless you run the whole suite again.

Fixtures separate _the reason test data is like it is_ from the tests themselves, rather than keeping them close together.

## I might be wrong

Now perhaps I have only been exposed to problematic fixtures, and there are techniques for reliably avoiding this coupling or at least managing it better. If that's the case, then I'd really love to hear more about them.

Or, perhaps the pain of managing fixture coupling is *objectively less* than the pain of changing the way you write software to both avoid fixtures AND avoid slowing down the test suite by inserting data into the database thousands of times?

That's certainly possible. I am skeptical though.


[dhh-tdd]: http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html
[keynote]: http://www.justin.tv/confreaks/b/522089408
[rails-contributing]: https://github.com/rails/rails/blob/master/CONTRIBUTING.md
[dhh-fixtures]: http://david.heinemeierhansson.com/2014/slow-database-test-fallacy.html

:kind: blog
:created_at: 2014-04-30 09:13:31 -0500
:updated_at: 2014-04-30 09:13:31 -0500
