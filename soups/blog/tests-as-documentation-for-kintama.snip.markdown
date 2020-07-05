Tests as documentation for Kintama
==================================

One of my goals when working on {l kintama} has been to drive the implementation using examples of actual behaviour as seen from someone using the framework.

In other words, I've been writing a lot of acceptance tests to ensure that as I wildly refactor the internals (from class-based to block-based and back), I can be confident that the outward behaviour of the testing DSL still works.

There *are* some unit tests, and I'd like to add more because it's also one of my goals to make it clear how developers can use and manipulate Kintama building blocks (contexts, tests) to the best effect when testing their own applications. In my experience, customising a testing DSL to your specific application can really help improve the clarity and robustness of tests, and I'd like to make it as easy as possible to do that.

That said, the acceptance tests are still extremely important to me, and all new features are driven by expressing the behaviour as I'd like to use it.

## Acceptance tests as usage documentation

Anyway, I've been doing some refactoring of the tests themselves recently, with the new aim of also using them as a sort-of living documentation. My hope is that any developer could quickly look at these "usage" tests and see how the assertions, or the nesting, or even the "action" behaviour that I mentioned in {l setup-vs-action-for-ruby-tests} behaves and how it should be used.

I had thought about using [Cucumber](http://cukes.info) to do this and the publish the features on [Relish](http://relishapp.com), but it seemed like doing so was going to introduce a large roundtrip, where the cucumber tests would end up writing test files, then running them and then slurping in and parsing the input.

One of the main reasons why I've been able to get away with such a reliance on acceptance tests is because I can run them very, very quickly (the whole suite is just over 2 seconds), so I am not very keen on slowing that down. I'm also not keen to lose things like syntax highlighting of the Kintama tests themselves, which would also happen if they were written as strings within Cucumber.

## Writing Kintama acceptance tests in Test/Unit

Thankfully, we can make some big improvements without having to lose any of the speed or editor-friendliness of the tests. Here's an example of one of the new Kintama "usage" tests, which are a suite of acceptance tests written to demonstrate the behaviour of various features:

{code basic_usage, ruby}

This test covers the basic behaviour of a Kintama test (which you can see follows squarely in the footsteps of shoulda or RSpec style tests). It shows
how to define a context, how to write tests in one, what the output you'll
get will be, and that the test should ultimately pass.

You can [peruse all of the usage tests on Github](https://github.com/lazyatom/kintama/tree/master/test/usage).

They work up from [basic usage](https://github.com/lazyatom/kintama/blob/master/test/usage/01_basic_usage_test.rb) through [setup](https://github.com/lazyatom/kintama/blob/master/test/usage/02_setup_test.rb) and [teardown](https://github.com/lazyatom/kintama/blob/master/test/usage/03_teardown_test.rb) to [exceptions](https://github.com/lazyatom/kintama/blob/master/test/usage/07_exceptions_test.rb), [expectations and mocking](https://github.com/lazyatom/kintama/blob/master/test/usage/09_expectations_and_mocking_test.rb) all the way to the experimental [action behaviour](https://github.com/lazyatom/kintama/blob/master/test/usage/12_action_test.rb) that {l setup-vs-action-for-ruby-tests, "inspired Kintama in the first place"}.

## Running Kintama within existing Ruby processes

This is a [Test::Unit](http://test-unit.rubyforge.org/) test, but it's actually generating and running the Kintama test it describes, but without resorting to writing a file and then shelling out to a new Ruby process. Being able to write tests like this also makes it easier for them to communicate how each feature should be used, because every test contains the actual Kintama expression of how to use that feature.

This is possible in no small part because Kintama is designed to produce independent, executable chunks of code. The `context` method in Kintama, which defines a collection of tests, also returns an object which has methods that can be used to run and introspect against those tests, and their failures[^lower]. Only a tiny piece of scaffolding is used, and that is only responsible for adding the syntactically nice methods for asserting output and how many tests passed.

Anyway, more examples. Here's a test describing the behaviour of nested contexts with setups and tests at different levels:

{code nested_contexts, ruby}

The test verifies that two tests ran (`should_run_tests(2)`), and that the context passed (`and pass`).

Because I already have some unit tests, and other basic usage tests, I can be confident that simple testing behaviour already works and so lots of the higher-level tests can verify their behaviour *using the Kintama tests themselves*. If any of the assertions within the Kintama test fail, such as the `assert_equal "jazz", @name` above, then the test will not pass.

Here's another test that checks exceptions raised in the teardown (which always runs) don't mask any exceptions within the test itself:

{code teardown_failures, ruby}

Here we can actually make assertions about which test failed, and what the
failure message was.

I am very pleased with how this is turning out.

[^lower]: Lower-level unit tests, as mentioned above, will help demonstrate exactly how to poke these test objects for maximum effect, so that it's clearer how to compose Kintama objects dynamically.

:kind: blog
:created_at: 2013-01-15 16:30:48 -0600
:updated_at: 2013-01-15 16:30:48 -0600
:basic_usage: |
  def test_should_pass_when_all_tests_pass
    context "Given a test that passes" do
      should "pass this test" do
        assert true
      end

      should "pass this test too" do
        assert true
      end
    end.
    should_output(%{
      Given a test that passes
        should pass this test: .
        should pass this test too: .
    }).
    and_pass
  end
:nested_contexts: |
  def test_should_only_run_necessary_setups_where_tests_at_different_nestings_exist
    context "Given a setup in the outer context" do
      setup do
        @name = "jazz"
      end

      context "and another setup in the inner context" do
        setup do
          @name += " is amazing"
        end

        should "run both setups for tests in the inner context" do
          assert_equal "jazz is amazing", @name
        end
      end

      should "only run the outer setup for tests in the outer context" do
        assert_equal "jazz", @name
      end
    end.
    should_run_tests(2).
    and_pass
  end
:teardown_failures: |
  def test_should_not_mask_exceptions_in_tests_with_ones_in_teardown
    context "Given a test and teardown that fails" do
      should "report the error in the test" do
        raise "exception from test"
      end

      teardown do
        raise "exception from teardown"
      end
    end.
    should_fail.
    with_failure("exception from test")
  end
