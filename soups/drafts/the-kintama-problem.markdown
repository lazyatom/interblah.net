The Kintama Problem
===============

*This is the first in a series of posts where I discuss a piece of software that I am working on which has, I feel, lost its way a bit. I'm hoping that doing so will help me understand how to correct its course, or alternatively, so cease development and free up energy for other things.*

This is a long post, and for that I apologise. You can [skip to the end](#the-end).

Those of you who attend {l LRUG} will know about the "test framework episode" that I had last year.

![Ruby Testing Diaspora](/images/ruby-testing-diaspora.png)

I'll try to remember what originally prompted it; I *think* I had been struggling to refactor a large suite of tests (using [test-unit][] and [shoulda][]), and I was getting frustrated with how many hoops it felt like we had to jump through to test concisely.

The `should_change` straw
-------------------------

I think a good example of this is the `should_change` macro that [shoulda][] used to provide. I'll quote from [their blog post][should-change-deprecation]:

> Consider this example of should_change:
>
>     context "updating a post" do
>       setup do
>         @post = Post.create(:title => "old")
>         put :update, :post => {:title => "new"}, :id => @post.to_param
>       end
>
>       should_change("the post title", :from => "old", :to => "new") { @post.title }
>     end
>
> This reads well and seems to be fairly straightforward. Sadly, this doesn’t work because of how `should_change` works internally (hence the confusing part). It would actually need to be written like this:
>
>     context "given a post" do
>       setup do
>         @post = Post.create(:title => "old")
>       end
>
>       context "updating" do
>         setup do
>           put :update, :post => {:title => "new"}, :id => @post.to_param
>         end
>
>         should_change("the post title", :from => "old", :to => "new") { @post.title }
>       end
>     end
>
> The `@post` instance variable needs to be assigned a context above the context containing `should_change`. I told you it was confusing.

Basically, because `should_change` needs to know the state *before* the setup ran, you need to nest another content. It's not the worst thing in the work, but blurgh.

Anyway, the [shoulda][] authors declared this a smell and deprecated the method, while [I disagreed][should-change-deprecation-my-comment] because while I agreed that the mechanism was crufty, some of the conclusions they drew about the invalidity of testing *change* were a bit tenuous.


Structural flexibility
----------------------

Perhaps, I wondered, there was a better way of structuring the tests that would make it more natural to write tests including things like `should_change`? Surely *nesting* isn't the only bit of sugar we can sprinkle on "setup -> test -> teardown"?

The problem was that the tests above were conflating the "setup" with the "action" that was being tested. Perhaps they are different? The first idea that popped into my head was sketched like this:

    context "updating a post" do
      setup do
        @post = Post.create(:title => "old")
      end

      action do
        put :update, :post => {:title => "new"}, :id => @post.to_param
      end

      should_change("the post title", :from => "old", :to => "new") { @post.title }
    end

That seems to avoid the "ugly" nested context, and is simultaneously clearer about what we're actually interested in testing here.

So, combine this idea with a general frustration at the way that [test-unit][] works[^test-unit-logging] and a continued unwillingness to drink the [rspec][] koolaid[^rspec-koolaid], I did what it turns out a million other people have done, and started exploring my own test framework.


Humble beginnings
------

Initially I was interested in replicating the behaviour of the [test-unit][] + [shoulda][] combination, but with far less code. Here's [the first commit](https://github.com/lazyatom/kintama/commit/3aee44947aaf7c63e52714d783ac3a7c3addb137), so you can see how serious I was about simplicity. Stepping through [each of the commits](https://github.com/lazyatom/kintama/commits/master), you can see that I tried to grow the library only using concrete tests that provided examples of the behaviour I expected.

Here's the file at [around the 10th commit](https://github.com/lazyatom/kintama/blob/ba7c9feaed09cecceb9aeec1e6ff536dccf7e1a7/test/jtest_test.rb) (note that I'm using [test-unit][] to drive this, oh *irony*). It's taking shape, and the implementation is still only 35 lines long; there are blatantly-obvious problems of course, but over time I pretty much solved them all, writing a test each time.

---

Interlude: Re-running tests
----------------

A bit more context regarding my motivation: I'd always felt it was more difficult than it should be to run individually tests with [test-unit][]. The syntax is something like

    $ ruby my_test.rb -n "test_name_of_my_test"

which is simple enough, but once you get [Rails][] and [shoulda][] involved, that balloons to something more like

    $ ruby -Itest test/functional/some_controller_test.rb -n "test: Given some condition and another condition should do something specific. "

Far more of a handful, right? The method name has to start with "test" so that [test-unit][] will actually run it, but look at how long it is[^shoulda-method-length]! Can you imagine typing all that? And don't forget that space - don't you dare.[^shoulda-space].

Now, your editor might be able to help run this, but then you've placed yourselves in the fickle hands of [whoever is maintaining that support][shoulda-tmbundle], and whatever their whims might be. I already had to fork a bundle to fix some bugs, and perhaps something in my environment meant that I was the only person experiencing that, but still, it's a pain, and this is where I spend literally half of my time when working - running and *re*running tests. It should be simple! It should be painless![^whinge-reminder]

So I had the notion that it should be possible to run tests interactively, and this got me thinking. How many times have you run a test, had it fail, then had to run it again peppered with debugging to look at the state in order to fix it? Wouldn't it be great to be able to just dive back in to the environment of any failed test and start poking around? See what the instance variables were? Call some methods?

----

The two means of behaviour slinging
-------

It's a likely encounter any Ruby programmer, but a certainty for any programmer writing a test framework: at some point you'll realise there are two fundamental ways of capture and calling "behaviour" in Ruby: Methods, and blocks. The same thing applies to any DSL you might implement, and test frameworks like [shoulda][] and [rspec][] are indeed DSLs for testing.

Allow me to illustrate.

Let's say we want to write a couple of tests using the following DSL:

    test "something" do
      assert 1 == 1
    end

    test "another thing" do
      assert false == true
    end

When it comes to "running" that test, you basically have two choices -- capture the behaviour as a method body and call that method, or use one of the various block/proc calling mechanisms to evaluate the block within a sensible context.

Here's a trivial implementation of the 'method' approach:

    def assert(expression)
      raise "Test failed" unless expression
    end

    $tests = []

    def test(name, &block)
      test_name = "test #{name}"
      self.class.send(:define_method, test_name, &block)
      $tests << test_name
    end

    def run(tests)
      failures = []
      tests.each do |test|
        begin
          send(test)
          print "."
        rescue => e
          failures << test
          print "F"
        end
      end
      puts "\n\n#{tests.count} tests; #{failures.count} failures"
      puts "\n#{failures.map { |f| "Failed: #{f}" }.join("\n")}\n\n"
    end

    test "something" do
      assert 1 == 1
    end

    test "another thing" do
      assert false == true
    end

    run($tests)

For each "test", we are defining a method using the name of the test, and then storing those names. When we want to run all the tests, we use `send` to invoke each of the methods we created.

Here's the corresponding implementation for a block-based approach:

    def assert(expression)
      raise "Test failed" unless expression
    end

    $tests = {}

    def test(name, &block)
      test_name = "test #{name}"
      $tests[test_name] = block
    end

    def run(tests)
      failures = []
      tests.each do |test_name, test_block|
        begin
          test_block.call
          print "."
        rescue => e
          failures << test_name
          print "F"
        end
      end
      puts "\n\n#{tests.count} tests; #{failures.count} failures"
      puts "\n#{failures.map { |f| "Failed: #{f}" }.join("\n")}\n\n"
    end

    test "something" do
      assert 1 == 1
    end

    test "another thing" do
      assert false == true
    end

    run($tests)

As you can tell, the implementations are very, very similar. The key difference is that in the second, we are stashing the blocks in a hash, and then using `call` to run them as procs.

This is interesting for a test-framework implementer because once your tests include some form of state, the choice you make above will have a fairly large impact on the resulting architecture of your framework.

We can illustrate this by extending our simple implementations to also have a `setup` mechanism. First, the method approach:


The End
------------------

So. Here we are. What I have is a reasonably-compact testing framework with some 'modern' features like:

* nesting contexts
* matcher syntax
* flexible runners including running tests on specific lines
* flexible reporting of test output




[^test-unit-logging]: I'd wanted more verbose logging of test runs for a long time, with nested printing of context and test names, to more quickly see which tests were failing while they were still running. Unfortunately, the way that [test-unit][] works behind the scenes makes this basically impossible. See [MonkeySpecDoc](http://jgre.org/2008/09/03/monkeyspecdoc/) for an example of an attempt which hits this limitation. Yes, [rspec][] does this.

[^rspec-koolaid]: Basically I didn't want to invest time learning the pseudo-english matcher language that was heralded as being the main benefit at [rspec][]'s inception (the marketing may have changed, I don't know). The term [BDD][] may have served a purpose once, but I'm not sure now. I don't care if I'm writing "tests" or "specs", I just care about being able to quickly express some behaviour. Oh, and everyone was complaining about new versions of rspec breaking APIs. Anyway, this is just context, it's not objective fact.

[^shoulda-method-length]: It occurs to me in retrospect that the method name length is a direct consequence of nesting contexts. I don't know if this is a sign that lots of nesting is a bad idea, or if that might simply be independently true.

[^shoulda-space]: The space at the end there is significant. Shoulda adds it to the end of every test. WHY!!!

[^whinge-reminder]: Let me take this opportunity to again remind you that this isn't a statement of objective fact; I'm just explaining my state of mind before I started work on kintama. It's also worth noting that at this point I hadn't heard of [tconsole][], which does go some way to making it easier to run tests in an interactive way.

[test-unit]: http://ruby-doc.org/stdlib/libdoc/test/unit/rdoc/
[shoulda]: https://github.com/thoughtbot/shoulda
[shoulda-tmbundle]: https://github.com/drnic/ruby-shoulda-tmbundle
[rspec]: http://rspec.info
[Rails]: http://rubyonrails.org
[should-change-deprecation]: http://robots.thoughtbot.com/post/731871832/this-should-change-your-mind
[should-change-deprecation-my-comment]: http://robots.thoughtbot.com/post/731871832/this-should-change-your-mind#comment-58679148
[tconsole]: https://github.com/commondream/tconsole

:created_at: 2013-01-03 15:48:00 -06:00
:updated_at: 2013-01-03 15:48:00 -06:00
