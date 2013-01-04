Capturing behaviour in Ruby DSLs
================

## A WORK IN STAGNANT PROGRESS

As part of the work I did implementing {l kintama}, I found myself flip-flopping between two different ways of capturing test implementations and running them. I think there's something interesting and perhaps useful in making these approaches more explicit.

I'm trying to elucidate them here, but this is very much a work in progress, and it's nowhere near finished.

Anyway.


The two means of behaviour slinging
-------

It's a likely encounter any Ruby programmer, but a certainty for any programmer writing a test framework: at some point you'll realise there are two fundamental ways of capture and calling "behaviour" in Ruby: Methods, and blocks. The same thing applies to any DSL you might implement, and test frameworks like [shoulda][] and [RSpec][] are indeed DSLs for testing.

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

Next steps
-------

... actually explain what the consequences are. Basically it relates to whether or not your tests end up being actual classes/objects or not. It's pretty hard to show differences in blog form; it might be better to have a simple DSL which I implement using either form and step through the commits.


[shoulda]: https://github.com/thoughtbot/shoulda
[rspec]: http://rspec.info

:created_at: 2013-01-04 09:53:06 -0600
:updated_at: 2013-01-04 09:53:06 -0600
