What happens when MiniTest runs, or, what I think about testing using classes
========

I think I can see the end of my {l kintama,Ruby Testing Quest} in sight.

As one part of the final leg of this journey, I want to take a not-too-deep dive into how some principal testing frameworks actually work, so that I can better clarify in my own mind what distinguishes them, and perhaps, if we are lucky, draw out some attributes that may help me. Somehow.

We're going to start with [MiniTest][]. We'll also look at [RSpec][] and {l kintama}, but not right now. This is already crazy-long.

(*Update*: you can now read about {l how-rspec-works, how RSpec works} if you wish...)

A simple MiniTest example
--------

Let's say you have the following test case:

{code minitest_example}

This test is obviously *extremely* dull and pointless, but it contains just enough to exercise the major parts of MiniTest that I care about.

The two hallmark attributes here are:

* creating an explicit subclass of a framework class (`SomethingTest < MiniTest::Unit::TestCase`)
* defining test behaviour within explicit methods (`def setup`, `def test_something` and `def teardown`).


Running the test
--------

The simplest way of running this test would be to save it in some file (`something_test.rb`) and run it from the command-line.

    $ ruby something_test.rb
    Run options: --seed 24486

    # Running tests:

    .

    Finished tests in 0.000866s, 1154.7344 tests/s, 1154.7344 assertions/s.

    1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

So -- what's actually happening here?

Autorun
-------

The first line in the file (`require "minitest/autorun"`), when evaluated, loads the MiniTest library and then calls `MiniTest::Unit.autorun`, which installs an `at_exit` hook -- a block of code that will be run when this Ruby interpreter process starts to exit.

Our command in the shell (`ruby something_test.rb`) tells Ruby to load the contents of `something_test.rb`, which after loading MiniTest simply defines a class with some methods, and nothing else, so after the definition of `SomethingTest` is finished Ruby starts to exit, and the `at_exit` code is invoked.

Within this block, a few things happen, but only a small part is particularly relevant to us at the moment: the method `MiniTest::Unit.new.run` is run, with the contents of `ARGV` from the command line (in this case an empty Array, so we'll ignore them as we continue).


MiniTest::Unit, a.a. the "runner"
--------

The call to `MiniTest::Unit.new.run` simply calls `MiniTest::Unit.runner._run`, passing the command-line arguments through. `runner` is a class method on `MiniTest::Unit`, which returns an instance of `MiniTest::Unit` by default, although it can be configured to return anything else by setting `MiniTest::Unit.runner =  <something else>`.

So, an instance of `MiniTest::Unit` was created in the unit test, which then calls run on another newly-created instance of it. It's mildly confusing, but I believe the purpose is to allow *you* to completely customise how the tests run by being able to use any object with a `_run` method. From here on, we'll assume that the default runner (an instance of `MiniTest::Unit`) was used.

The default `_run` method parses the `ARGV` into arguments (which we'll ignore right now since in our example they are empty) and then loops through the `plugins` (another modifiable property of `MiniTest::Unit` class), which is really just an array of strings which correspond to methods on the `MiniTest::Unit` "runner" instance. By default, this is all methods which match `run_*`, and unless you've loaded extensions to MiniTest, it is just `run_tests`:

{code plugins}

The `run_tests` method calls the `_run_anything` method with the argument `:tests`. Within `_run_anything`, the argument is used to select the set of "suites" by kind ("test" suites or "bench" suites, but basically the classes that contain your actual tests).

The actual set of "suites" is returned by calling `TestCase.test_suites` in this instance. So what does it return? Let's take a diversion to see what's going on there.


The test suites, a.k.a `TestCase` subclasses, a.k.a. your actual tests
------

Take another look at the content of our test file:

{code minitest_example,2}


When we subclassed `MiniTest::Unit::TestCase` as `SomethingTest`, the `inherited` hook on the superclass is called by Ruby with `SomethingTest` as an argument.

This stashes a reference to the class `SomethingTest` in an class variable[^why-a-hash]. The `TestCase.test_suites` method that we were looking at above returns all those subclasses, sorted by name:

{code test_suites}


Running a "suite"[^suite]
-------

Back in the `_run_anything` method, those suites are passed to the `_run_suites` method, which maps them into their results by passing each to the `_run_suite` method.

The `_run_suite` method is responsible for selecting those tests within a suite (returned by the `test_methods` method on your `TestCase` subclass) which match any filters (i.e. `-n /test_something/`).

{code test_methods}

The default filter is `/./`, which will match everything that `test_methods` returns. For each matching method name, it instantiates a new instance of your suite class, with the method name as an argument to the intialiser, i.e. `SomethingTest.new("test_something")`.

The `run` method is then called on that instance, with the runner (the instance of `MiniTest::Unit` that was returned by `MiniTest::Unit.runner`) as an argument. If you wanted to do the same in the console, it basically amounts to this:

{code running_single_test}


An actual test running
-----

We're now at the point where the code from your test is significantly involved. Within the `run` method, the following methods are called[^plugin-hooks]:

* `setup` -- this is the method defined in *your* `TestCase` subclass. In our example, this results in the instance variable `@something` being set: {codeminitest_example,3,6}
* `run_test`, with the test name that passed to the initializer as an argument. This method is simply an alias for `__send__`, so the effect is that the method corresponding to your test name is invoked. In our case, the body of `test_something` runs: {codeminitest_example,7,10}
* `runner.record` -- this passes information about the name of the test, how long it took and how many assertions were called back to the runner instance

If we reach this point in the method, it means that the test method returned without raising any exceptions, and so the test is recorded as a pass.

However, if an exception was raised -- either by the test, or by a failing assertion -- then the test is marked as a failure, and the exception is passed as an argument in a corresponding call to `runner.record`.

* `teardown` -- This method is run via an `ensure` block, so that it will be invoked whether or not an exception occured. In our example, the `@something` instance variable is set to nil: {code minitest_example,11,13}

Various other things happen, but this is the essential core of how MiniTest works: an instance of your `TestCase` subclass is created, and then the setup, test and teardown methods are invoked on it.


After the test has run
-----


The `run` method returns a "result", which is normally a character like `.` or `F` or `E`. This ultimately gets spat out to whatever is going to be doing the output (normally `STDOUT`). We saw this output above when we manually instantiated `SomethingTest` and then called `run` on it.

Actually, the `puke` method is called for anything other than a pass, which writes a more detailed string into a `@report` instance variable, and then returns the first character of that string (`Skipped ...` &rarr; `S`, `Failed ...` &rarr; `F` and so on).


Back up into MiniTest
-----

Once the `run` method finishes, the result is printed out, and the number of assertions stored on the instance is collected. The test method names that we were iterating over -- the result of `SomethingTest.test_methods` above -- are sequentially *mapped* into this number of assertions, and the final returned value of the `_run_suite` method is a two element array, the first being the number of tests and the second being the total number of assertions, for each test that ran. In our example, this would be `[1,1]` -- one test and one assertion in total:

{code _run_suite}

Back up in the `_run_suites` method, each `TestCase` is being mapped via into this pair of numbers:

{code _run_suites}

Back up one level further in the `_run_anything` method, those numbers are summed to return the total number of tests and the total number of assertions, across the whole run of test suites. Finally, these numbers are printed out, and then any failures that were gathered by the calls to `runner.record` when each test was running.

When the `_run` method itself finally finishes, taking us back into the `at_exit` block we started in, it returns the number of errors plus failures that were counted. This value doesn't seem to be used, and disappears into the quantum foam of energy and information to which we all, ultimately, return.


-----



Running tests within the console
-----

We've actually seen already how we could start to poke around with tests without running them all. We can run a single test relatively easily, and determine whether or not it passed:

{code running_single_test}

Unfortunately, there's no simple way to run a group of tests (a "suite" or a "testcase" or what have you) aside from using the runner to specify a filter based on names. In other words, there's no behaviour inherent within the `TestCase` class that lets you examine the result of the tests it contains. The information about which test failed, and why, leaves the instance when `runner.report` is called, and it's only the `runner` that "knows" (in a very, very weak sense) about the state of more than just the test that is running now.

Instead the `TestCase` subclass is really just a collection of `test_` methods along with the underlying behaviour to execute them (the `run` method that we examined above, and all of the supporting methods it invokes).


A test's *environment*
----

One of the aspects of test frameworks that interests me most is what provides the *environment* for each test. What I mean by *environment* here are things like

* the implicit value of `self`
* how instance variables declared outside of the test relate to the code within the test
* how methods defined outside the test relate to the code within the test

When a `TestCase` subclass is instantiated, that instance provides the *environment* for the test to execute. MiniTest, like [test-unit][] before it, is using the familiar conceptual relationship between classes, objects and methods in Ruby to implicitly communicate that instance variables created or modified in one method, like `setup`, will be available within our tests, just like normal Ruby code.

This is, I believe, the main reason behind *some* of the preference towards MiniTest or test-unit style frameworks -- they use "*less magic*", they are "*closer to the metal*" -- because they use the same conceptual relationships between methods, variables and `self` as we use when doing all other programming.

This may be so familiar as to seem obvious; methods can *of course* call methods within the same class, and instance variables set in one method (e.g. `setup`) can *of course* be accessed by other methods (e.g. `test_something`) within the same class. Therefore implementing test suites like this is surely only natural!

Yes, indeed. But doing so is not without consequence.

For example, it's *not* typical behaviour to create a new instance of a class just to invoke a single method on it, but that happens for every `test_` method. I hope you'll agree that that seems far less natural. But this *has* to happen so that each test runs within a *clean environment*, without any of the changes the previous test might have made to the instance variables they both use, and without any trace of the instance variables previous tests may have created.

If your test framework has those hallmark attributes I mentioned above -- a class definition to contain tests, and tests defined as methods -- then creating a new instance of that class to run each individual test is an inevitable consequence, unless you want to do some incredible gymnastics behind the scenes.

### Examining test environments

Before I climb the ivory tower at the end of this post, let's have one final code interlude, using these test *objects* we are creating in the console.

I've often imagined that it would be very useful if, when a test fails, you got a dump of all of the values of every instance value in that test. I don't know about you, but I am very bored of peppering tests with `puts` statements, or trying to use logs to decipher what happened, when I know that if I could just see the instance variables then I could tell what was failing, and why.

How about this:

{code test_environment,0,26}

We can see that the test failed, but now we can also look at the instance variables within that test:

{code test_environment,27,29}

In this test it's pretty trivial, but maybe you can imagine that being useful when you have a ton of ActiveRecord objects flying around? Particularly if you also patch whatever is outputting your test results to print the contents of `environment` for all failing tests.

If you're curious, you can also take a look at the other instance variables that MiniTest has created behind the scenes, mostly prefixed with `_` to indicate an informal 'privacy':

{code test_environment,30,32}

Perhaps this might be worth developing into something useful? Maybe. It's very much related to the other ideas that I've had about {l rerunning-tests-in-ruby}.


Using classes for test cases?
----

So, here we are at the foot of my ivory tower.

There's nothing *wrong* with implementing test suites like MiniTest does, but it's interesting to understand the consequences, both in terms of the impact to the test implementer and the design choices that it forces on the framework implementer. This is particularly obvious if you're {l kintama,trying to understand the different ways that one could compose test suites}.

Using classes and methods is one way, but it's *not the only way* to produce blocks of code (indeed, *blocks* are another) to be run in some specific way.

If we choose Ruby's existing class system as the mechanism for collecting test behaviour together, we are bound by the rules and limitations of that class system when trying to do anything slightly more out of the ordinary, like dynamically composing abstract behaviour specifications.

Of all languages I've used, Ruby is by far the most forgiving regarding this; you can get an amazing amount of mileage out of subclassing, and including modules, and using "class methods" to modify the definition of classes at run-time.

![Ruby Testing Diaspora](/images/ruby-testing-diaspora.png)

It's really a credit to Ruby that, even within the niche of the ecosystem that testing libraries represent, and even within that, the libraries that build on [MiniTest][] or [test-unit][], *so much richness* exists. Things like [shoulda][] or [coulda][] or [contest][] could not possibly exist without this flexibility.

But that doesn't mean that there aren't occasions where you hit a problem using things like inclusion or inheritance. This has been on my mind for a while.

Hmm
---

It's my intuition that these test suites that we're writing... well, they shouldn't be classes. They don't describe things that you can instantiate sensibly and that then have behaviour. They certainly don't [send messages to one another, like "proper objects" do](http://www.inf.ufsc.br/poo/smalltalk/ibm/tutorial/oop.html). Classes are just convenient containers for these loosely-related essentially-procedural test bodies.

I believe that this intuition is what lies behind my interest in other test frameworks. From it springs all the ideas about composing or describing the systems under test in more dynamic or more natural ways.

In the next article, we'll look at how [RSpec][] works under the hood, and finally how {l kintama} does. Without having done the comparison yet, my guess is that they are very similar, but even within the alternate approach of *block*-defined tests there are many different paths you can take...


[^why-a-hash]: For some reason this collection of classes is stored in a Hash, but it seems like the keys of the hash are the only aspect used, so I don't understand why it isn't an Array...
[^plugin-hooks]: There are actually quite a few more methods called, but I'm ignoring hooks principally used by plugin authors.
[^suite]: ...a.k.a. `TestCase` subclass, a.k.a. your actual tests. I'm not sure why the MiniTest code is riddled with references to 'suites', when the classes that it's actually running are called `TestCases`. Perhaps it's a compromise involving historic names of classes in [test-unit][]?

[shoulda]: https://github.com/thoughtbot/shoulda
[coulda]: https://github.com/elight/coulda
[contest]: https://github.com/citrusbyte/contest
[test-unit]: http://test-unit.rubyforge.org/
[MiniTest]: http://github.com/seattlerb/minitest
[RSpec]: http://rspec.info


:kind: blog
:created_at: 2013-02-01 18:44:07 +0000
:updated_at: 2013-02-06 09:12:07 +0000
:minitest_example: |
  require "minitest/autorun"

  class SomethingTest < MiniTest::Unit::TestCase
    def setup
      @something = Object.new
    end

    def test_something
      refute_nil @something
    end

    def teardown
      @something = nil
    end
  end
:plugins: |
  $ MiniTest::Unit.plugins
  # => ["run_tests"]
:test_methods: |
  SomethingTest.test_methods
  # => ["test_something"]
:test_suites: |
  MiniTest::Unit::TestCase.test_suites
  # => [SomethingTest]
:running_single_test: |
  runner = MiniTest::Unit.new
  suite = SomethingTest.new("test_something")
  suite.run(runner)
  # => "."
:_run_suite: |
  runner = MiniTest::Unit.new
  runner._run_suite(SomethingTest, :test)
  # => [1, 1]
:_run_suites: |
  runner._run_suites([SomethingTest], :test)
  # => [[1, 1]]
:test_environment: |
  require "minitest/unit"

  class AnotherTest < MiniTest::Unit::TestCase
    def setup
      @value = 123
    end

    def test_something
      assert_nil @value
    end
  end

  class MiniTest::Unit::TestCase
    def environment(hide_framework_variables = true)
      variables = instance_variables
      variables.reject! { |v| v.to_s =~ /^@(_|passed)/ } if hide_framework_variables
      variables.inject({}) do |h, v|
        h[v] = instance_variable_get(v)
        h
      end
    end
  end

  runner = MiniTest::Unit.new
  test = AnotherTest.new("test_something")
  test.run(runner)
  # => "F"

  test.environment
  # => {:@value=>123}

  test.environment(false)
  # => {:@__name__=>"test_something", :@__io__=>nil, :@passed=>false, :@value=>123, :@_assertions=>1}
