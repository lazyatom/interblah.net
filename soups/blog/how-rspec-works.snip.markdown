What happens when RSpec runs, or, what I think about testing with blocks
===============

Welcome to part two of the the post series which will hopefully cauterize the bleeding stump that is my {l kintama,Ruby Testing Quest}.

This time, we will take a not-too-deep dive into how [RSpec][] works. Last time {l how-minitest-works,we looked at MiniTest}; if you haven't already read that, it might be a better place to start than this.

Let's get going.


A simple RSpec example
--------

Here's a simple RSpec example.

{code ruby,rspec_example}

This is obviously *extremely* dull and pointless -- just like the {l how-minitest-works,minitest one} -- but it contains just enough to exercise the major parts of RSpec that I care about. It's actually slightly more sophisticated than the example that I used for MiniTest, because RSpec provides a couple of notable features that MiniTest doesn't provide. Specifically, these are `before :all` setup blocks, and nested groups of tests[^minitest-nesting][^other-rspec-features].

[^minitest-nesting]: There's no built-in way to 'nest' test groups with MiniTest, or test-unit; the closest simulation would be to create subclasses, and explicitly ensure that `super` is called within every `setup` method.

[^other-rspec-features]: There are other RSpec features like shared examples and global before/after hooks that are definitely interesting, but I need to keep the scope of this article down...

I'm not particularly interested in looking at the other obvious distinguishing features of RSpec, like matchers and the BDD-style "should" language, as these aren't actually a part of the core RSpec implementation[^rspec-expectations].

[^rspec-expectations]: They are actually within a separate gem ([rspec-expectations][]), and it's quite possible to use [rspec-core][] with [test-unit][]'s assertions (for the curious, hunt for `config.expect_with :stdlib`).

The two hallmark attributes here that I *am* interested in are:

* grouping test definitions within blocks (as opposed to classes)
* defining test behaviour using blocks (as opposed to methods)


Running the <strike>test</strike> spec
--------

The simplest way of running this spec would be to save as `something_spec.rb` and run it from the command-line.


    $ ruby something_spec.rb
    ..

    Finished in 0.00198 seconds
    2 examples, 0 failures
    [Finished in 0.5s]

So -- what's actually happening here?


Autorun
------

As with the {l how-minitest-works,minitest example}, the first line loads a special file within the test library that not only loads the library, but also installs an `at_exit` hook for Ruby to run when the interpreter exists.

In RSpec's case, this is defined in `RSpec::Core::Runner.autorun`. This calls `RSpec::Core::Runner.run` with `ARGV` and the `stderr` and `stdout` streams.

In contrast with [MiniTest][], RSpec parses the options at this point, and will try to determine whether or not to launch using DRb. In most cases it will create an instance of `RSpec::Core::CommandLine` with the parsed `options`, and then calls `run` on that instance.

Within the `run` method, some setup happens (mostly preamble to be output by the `reporter`, which is set via the configuration). Then we iterate through all of the "example groups", returned by `RSpec::world.example_groups`[^hmm].

[^hmm]: I'm not sure why some people prefer the syntax `Module::method` rather than `Module.method`; as I understand it they are exactly the same, but the former seems more confusing to me, since if you don't notice the lower-case *w* in `world` then you'd assume it was refering to a constant.

Let's take a diversion to see how things actually get *into* `RSpec::world.example_groups`.


Your example groups
----------------

Consider our example spec again. At the top we have a call to `describe`:

{code ruby,rspec_example,2,2}

The `describe` method is actually defined within the module `RSpec::Code::DSL`, but this module is extended into `self` at the top level of the running Ruby interpreter (which is `main`, a singleton instance of `Object`), making the methods in that module available to call in your spec files. You can actually see all of the modules that have been extended into this instance:

{code ruby,main}

From this we can tell that the ancestors of `Object` are still just `Kernel` and `BasicObject`, but the ancestors of the specific *instance* `main` includes a few extra modules from RSpec. Anyway, moving on...

### `describe` and `RSpec::Core::ExampleGroup`

The `describe` method in `RSpec::Core::DSL` passes its arguments straight through to `RSpec::Core::ExampleGroup.describe`. This is where things get a little *interesting*. Within this inner `describe` method, a *subclass* of `RSpec::Code::ExampleGroup` is created, and given a generated name.

{code ruby,example_group_constants}

The class that was created is there -- `Nested_1`. For each `describe` at the top level, you'll have a new generated class:

{code ruby,example_group_constants_2}

After each subclass is created, it is "set up" via the `set_it_up` method, which roughly speaking adds a set of *metadata* about the group (such as which file and line it was defined upon, and perhaps some information about the class if it was called in the form `describe SomeClass do ...`), and stashes that within the created subclass.

### `module_eval`

More importantly, however, the block which was passed to `describe` is evaluated against this new subclass using `module_eval`.

The effect of using `module_eval` against a class is that the contents of the passed block are evaluated essentially *as if they were within the definition of that class itself*:

{code ruby,module_eval}

You can see above that the behaviour is effectively the same as if we'd defined the `hello?` method within the `Lionel` class without any "metaprogramming magic"[^magic].

[^magic]: It's not really magic, and it's not really "metaprogramming", because it's all just programming. It just so happens that it's quite sophisticated programming.

In terms of how RSpec is implemented, it's because of `module_eval` that you can define methods within example groups:

{code ruby,method_in_example_group}

These methods are then effectively defined as part of the `Nested_1` class that we are implicitly creating. This means that methods defined in this way can be called from within your specs:

{code ruby,method_in_example_group_called_in_spec}

We'll see how this actually works a bit later. Knowing that the contents of the `describe` block are effectively evaluated within a class definition also explains what's happening when the `before` methods are called:

{code ruby,rspec_example,3,9}

Because this is evaluated as if it was written in a class definition, then `before` must be a method available on the `ExampleGroup` class. And indeed it is -- `RSpec::Code::ExampleGroup.before`.

Well, almost.

### Hooks

The `before` method actually comes from the module `RSpec::Core::Hooks`, which is extended into `ExampleGroup`. RSpec has a very complicated behind-the-scenes hook registry, which for the purposes of brevity I'm not going to inspect here..

The `before` method registers its block within that registry, to be retrieved later when the specs actually run.

Because I'm not going to really look too deeply at hooks, the call to the `after` method works in pretty much the same way. Here it is though, just because:

{code ruby,rspec_example,25,27}


### The spec itself

The next method that's `module_eval`'d within our `ExampleGroup` subclass is the `it`:

{code ruby,rspec_example,11,14}

Users of RSpec will know that you can call a number of methods to define a single spec: `it`, `specify` `example`, and others with additional meaning like `pending` or `focus`. These methods are actually all generated while RSpec is being loaded, by calls to `define_example_method` within the class definition of `ExampleGroup`. For simplicity's sake (pending and focussed specs are somewhat outwith the remit of this exploration), we'll only look at the simplest case.

When `it` is called, more metadata is assembled about the spec (again, including the line and file), and then both this metadata and the block are passed to `RSpec::Core::Example.new`, which stashes them for later.


### Nesting

Within our outer example group, we've nested another group:

{code ruby,rspec_example,14,23}

Just as the top-level call to `describe` invokes a class method on `RSpec::Core::ExampleGroup`, this call will be invoked against the *subclass* of `ExampleGroup` (i.e. `Nested_1`) that our outer group defined. Accordingly, each call to `describe` defines a new subclass[^nesting-subclass], stored as a constant within the top-level class: `Nested_1::Nested_1`. This subclass is stored within an array of `children` in the outer `Nested_1` class.

[^nesting-subclass]: The nested class is a subclass of the outer subclass of `ExampleGroup` (sorry, I realise that's confusing), precisely such that any methods defined in the outer class are also available in nested subclasses via the regular mechanisms of inheritance.

Within the definition, our `before` and `it` calls evaluate as before.


### Your spec, as objects

So, for every `describe`, a new subclass of `ExampleGroup` is created, with calls to `before` and `after` registering hooks within that subclass, and then each `it` call defines a new instance of `RSpec::Core::Example`, and these are stored in an array called `examples` within that subclass.

We can even take a look at these now, for a simplified example:

{code ruby,example_group_object}

Where example groups are nested, further subclasses are created, and stored in an array of `children` within their respective parent groups.


### Almost there!

Phew. The detour we took when {l how-minitest-works,looking at this aspect of minitest} was much shorter, but now that we understand what happened when our actual spec definition was evaluated, we can return to RSpec running and see how it's actually exercised.

As we saw above, the `describe` method returns the created subclass of `RSpec::Core::ExampleGroup`, and when that is returned back in `RSpec::Code::DSL#describe`, the `register` method is called on it. This calls `world.register` with that class as an argument, where `world` is returned by `RSpec.world` and is an instance of `RSpec::Core::World`, which acts as a kind of global object to contain example groups, configuration and that sort of thing.

Calling `register` on the `World` instance stashes our `Nested_1` class in an `example_groups` array within that world.

Our diversion is complete! You deserve a break. Go fetch a cup of your preferred delicious beverage, you have earned it!


Back in RSpec
-------

OK, pop your brain-stack back until we're in `RSpec::Core::Commandline#run` again. Our reporter did its preamble stuff, and we were iterating through `@world.example_groups`, whose origin we now understand.

For each example group, the `run` method is called on that class, with the reporter instance passed as an argument.

This gets a bit intricate, so I'm going to step through the method definition itself (for version `2.12.2`) to help anchor things.

{code ruby,rspec_example_group_run_definition,0,4}

RSpec has a "fail fast" mode, where any single example failure will cause the execution of specs to finish as quickly as possible. Here, RSpec is checking whether anything has triggered this.

{code ruby,rspec_example_group_run_definition,5,6}

Next, the `reporter` is notified that an example group is about to start. The reporter can use this information to print out the name of the group, for example.

{code ruby,rspec_example_group_run_definition,7,8}

The run of the examples is wrapped in a block so it can catch any exceptions and handle them gracefully as you might expect.


### The `before :all` hooks

The call to `run_before_all_hooks` is very interesting though, and worth exploring. A new *instance* of the example group is created. It is then passed into this method, where any "before all" blocks are evaluated against that instance, and then the values of any instance variables are stashed.

Consider our original example:

{code ruby,rspec_example,3,6}

Given this, we'll stash the value of `@shared_thing` (and the fact that it was called `@shared_thing`) for later use.

It's actually quite easy to inspect the instance variables of an object in Ruby; try calling [`instance_variables`][], [`instance_variable_get`][] and [`instance_variable_set`][] on some objects in an IRB session:

{code ruby,instance_variable_set_example}

As you can see above, we can poke around with the innards of objects to our heart's content. Who needs [encapsulation][], eh?

Why did RSpec have to create an instance of the example group class, only to throw it away after the `before :all` blocks have been evaluated? Because RSpec needs to evaluate the block against an instance of the example group so that it has access to the same scope (e.g. can call the same methods) as any of the specs themselves.


### Running the example

Now we're finally ready to run the examples:

{code ruby,rspec_example_group_run_definition,9,9}

To understand this, we need to look at the definition of `run_examples`:

{code ruby,rspec_example_group_run_examples_definition}

This method iterates over each `Example` that was stored in the `examples` array earlier, filtering them according to any command-line parameters (though we are ignoring that here). The most relevant part for us lies in the middle:

{code ruby,rspec_example_group_run_examples_definition,3,5}

### A striking parallel with MiniTest

Another *new* instance of the `ExampleGroup` subclass is created. Remember, RSpec created one instance of the class for the `before :all` blocks, but now it's creating a fresh instance for this specific spec to be evaluated against.

Thinking back to {l how-minitest-works,how MiniTest works}, there's a striking parallel: **where MiniTest would instantiate a new instance of the `MiniTest::Unit::TestCase` for each test method, RSpec is creating a new instance of the `ExampleGroup` subclass to evaluate each `Example` block against.**

Instances of this class are used so that any methods defined as part of the spec definition are implicitly available as methods to be called in the "setup" and "test" bodies (see the [`module_eval`](#moduleeval) section above). Not so different after all, eh?

Next, the instance variables that we stashed after evaluating the `before :all` blocks are *injected* (effectively using `instance_variable_set` as we saw above) into this new instance, which will allow the spec to interact with any objects those blocks created. It also means that these values are shared between every spec, and so interactions within one spec that changed the state of one of these instance variables will be present when the next spec runs.

Finally, the `#run` method on the `Example` subclass is called, passing the `ExampleGroup` instance and the reporter. Down one level we go, into `Example#run`...

### The spec finally runs

Here's the full definition of `RSpec::Core::Example#run`:

{code ruby,rspec_example_run_definition}

For our purposes, we only need to consider a small part. Once all the reporter and "around" block housekeeping has taken place, the essential core of the example is run:

{code ruby,rspec_example_run_definition,10,17}

The call to `run_before_each` introspects the hook registry and evaluates every relevant `before` hook against the `ExampleGroup` instance. In effect, this will find any `before` blocks registered in this example group, and then any blocks registered in any parent groups, and evaluate them all in order, so that each nested `before` block runs.

Then, the spec block (stored in `@example_block`) is evaluated against the `ExampleGroup` instance. This is where your assertions, or matchers, are finally -- *finally!* -- evaluated.

If there was a problem, such as a matcher failing or an exception being raised, then the exception is stored against this `Example` for later reporting.

As in MiniTest, whether or not the spec failed or an exception occured, an `ensure` section is used to guarantee that `run_after_hooks` is called, and any teardown is performed.

### After the specs have run

Once all the specs in this example group have run, all the examples in any subclasses are run (recall that the inner `describe` stashed the nested `ExampleGroup` subclass in an array called `children`). We map each `ExampleGroup` subclass to the result of calling `run` on it, which starts this whole process again, for every nested example group. Whether or not this group passed or failed overall is then determined using simple boolean logic:

{code ruby,rspec_example_group_run_definition,10,11}

As we leave the call to `ExampleGroup#run`, we run any corresponding `after :all` blocks, and also clear out our stash of `before :all` instance variables, because they are no longer necessary.

{code ruby,rspec_example_group_run_definition,15}


### Finishing up

You can once again pop your brain-stack back until we're in `RSpec::Core::Commandline#run`.

Having run all of the example groups, RSpec will do a little bit of tidy up, and finally return back up through the stack. Along the way printing the results of the run to the console is performed, before interpreter finally, properly quits.

*Phew*. You deserve another rest.


Testing with blocks
--------------

In contrast to {l how-minitest-works,the class-based implementation with MiniTest}, we've now seen how a *block*-based test framework can work. In a nutshell, it can be characterised in a couple of key ways:

* the stashing of behaviour blocks, later evaluated using `instance_eval` against clean *test-environment* instances (see [this section of the MiniTest article](/how-minitest-works#a-tests-environment) for what I mean by "test environment");
* using `module_eval` and subclassing to ensure method definition matches programmer expectation.

I would say these two aspects are the hallmark attributes of an *RSpec-style* test framework. The other notable aspect is the ability to nest example groups, and the subsequent necessity to be able to gather the implicit chain of *setup* blocks and evaluate them against the test environment instance, but this could be considered another example of using `instance_eval`.

### Supporting method definition in example groups

One thing I've found particularly interesting is that RSpec ends up generating classes and subclasses behind the scenes. I believe this is almost entirely a consequence of wanting to support the kind of "natural" method definition within group bodies (see the [`module_eval`](#moduleeval) section again).

If any test framework chose to not support this, there's almost certainly no reason to create classes that map to example groups at all, and the setup and test blocks could be evaluated against a bare instance of `Object`.


### Supporting nesting and dynamic composition

It's clear that RSpec has more "features" (e.g. nesting, `before :all` and so on) than MiniTest (ignoring the many extensions available for MiniTest, the most sophisticated of which end up significantly modifying or replacing the `MiniTest::Unit.run` behaviour). I'm deliberately ignoring features like *matchers*, or a built-in mocking framework, because what I'm most interested in here are the features that affect the *structure* of the tests.

It's certainly possible to implement features like nesting using subclasses and explicit calls to `super`, but this is the kind of *plumbing* work that Ruby programmers are not accustomed to accepting. By separating creation of tests from Ruby's class implementation, the implicit relationships between groups of tests can take this burden instead, and behaviours like `before :all`, which have no natural analogue in class-based testing, are possible.

Now, you may believe that nesting is fundamentally undesirable, and it is not my present intention to disabuse you of that opinion. It's useful (I think) to understand the constraints we accept by our choice of framework, and I've certainly found my explorations of MiniTest and RSpec have helped clarify my own opinions about which approach is ultimately more aligned with my own preferences. While I wouldn't say that I'm ready to jump wholesale into the RSpec ecosystem, I think it's fair to say that my advocacy of class-style testing frameworks is at an end.


RSpec and Kintama
------

I started this exploration because I wanted to understand the relationship between {l kintama,the software I have accidentally produced} and what's already available. I already had strong suspicions that any block-based testing implementation would converge on a few common implementation decisions, and while I have now identified a few interesting (to me) ways in which RSpec and Kintama diverge, the essential approach is the same.

In the final article in this triptych (coming soon, I hope), I'll walk through Kintama and point those out.


[MiniTest]: http://github.com/seattlerb/minitest
[RSpec]: http://rspec.info
[rspec-expectations]: https://github.com/rspec/rspec-expectations
[rspec-core]: https://github.com/rspec/rspec-core
[test-unit]: http://test-unit.rubyforge.org/
[encapsulation]: http://en.wikipedia.org/wiki/Encapsulation_(object-oriented_programming)
[`instance_variables`]: http://ruby-doc.org/core-1.9.3/Object.html#method-i-instance_variables
[`instance_variable_get`]: http://ruby-doc.org/core-1.9.3/Object.html#method-i-instance_variable_get
[`instance_variable_set`]: http://ruby-doc.org/core-1.9.3/Object.html#method-i-instance_variable_set

:kind: draft
:created_at: 2013-02-18 21:41:24 +0000
:updated_at: 2013-02-18 21:41:24 +0000
:rspec_example: |
  require "rspec/autorun"

  describe "an object" do
    before :all do
      @shared_thing = Object.new
    end

    before :each do
      @something = Object.new
    end

    it "should be an Object" do
      @something.should be_an(Object)
    end

    describe "compared to another object" do
      before :each do
        @other = Object.new
      end

      it "should not be equal" do
        @something.should_not == @other
      end
    end

    after do
      @something = nil
    end
  end
:main: |
  require "rspec/core"

  self.class.ancestors
  # => [Object, Kernel, BasicObject]

  class << self
    ancestors
    # => [RSpec::Core::SharedExampleGroup, RSpec::Core::DSL, Object, Kernel, BasicObject]
  end
:example_group_constants: |
  describe "a thing" do
    # your tests, um, I mean specs
  end
  RSpec::Core::ExampleGroup.constants
  # => [:Nested_1, :Extensions, :Pretty, :BuiltIn, :DSL, :OperatorMatcher, :Configuration]
:example_group_constants_2: |
  describe "a thing" do
    # your specs
  end
  describe "another thing" do
    # more specs
  end
  RSpec::Core::ExampleGroup.constants
  # => [:Nested_1, :Nested_2, :Extensions, :Pretty, :BuiltIn, :DSL, :OperatorMatcher, :Configuration]
:module_eval: |
  class Lionel; end

  Lionel.module_eval do
    def hello?
      "is it me you're looking for?"
    end
  end

  Lionel.new.hello?
  # => "is it me you're looking for?"
:example_group_object: |
  group = describe "a thing" do
    it "should work" do
      (1 + 1).should_not equal(2)
    end
  end

  group
  # => RSpec::Core::ExampleGroup::Nested_1

  group.examples
  # => [#<RSpec::Core::Example:0x007ff2523db048
  #      @example_block=#<Proc:0x007ff2523db110@example_spec.rb:7>,
  #      @options={},
  #      @example_group_class=RSpec::Core::ExampleGroup::Nested_1,
  #      @metadata={
  #        :example_group=>{
  #          :description_args=>["a thing"],
  #          :caller=>["/Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-212.#   2/lib/rspec/core/example_group.rb:291:in `set_it_up'", "/Users/james/Code/experiments/rspec-ivestigation/.#   bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.2/lib/rspec/core/example_group.rb:243:in `ubclass'", #   "/Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.#  2/lib/rspec/core/example_group.rb:230:in `describe'", "/Users/james/Code/experiments/rspec-investigation/.#  bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.2/lib/rspec/core/dsl.rb:18:in `describe'", "example_spec.#   r:6:in `<main>'"]
  #        },
  #        :example_group_block=>#<Proc:0x007ff255c11430@example_spec.rb:6>,
  #        :description_args=>["should work"],
  #        :caller=>["/Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-2.1.#   2/lib/rspec/core/metadata.rb:181:in `for_example'", "/Users/james/Code/experiments/rspec-investigation/.#  bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.2/lib/rspec/core/example.rb:81:in `initialize'", #   "Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.#   2lib/rspec/core/example_group.rb:67:in `new'", "/Users/james/Code/experiments/rspec-investigation/.#   bndle/gems/ruby/1.9.1/gems/rspec-core-2.12.2/lib/rspec/core/example_group.rb:67:in `it'", "example_spec.#   r:7:in `block in <main>'", "/Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.#   1gems/rspec-core-2.12.2/lib/rspec/core/example_group.rb:244:in `module_eval'", #   "Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.#   2lib/rspec/core/example_group.rb:244:in `subclass'", "/Users/james/Code/experiments/rspec-investigation/.#   bndle/gems/ruby/1.9.1/gems/rspec-core-2.12.2/lib/rspec/core/example_group.rb:230:in `describe'", #   "Users/james/Code/experiments/rspec-investigation/.bundle/gems/ruby/1.9.1/gems/rspec-core-2.12.#   2lib/rspec/core/dsl.rb:18:in `describe'", "example_spec.rb:6:in `<main>'"]
  #      },
  #      @exception=nil,
  #      @pending_declared_in_example=false>
  #    ]
:method_in_example_group: |
  describe "a thing" do
    def invert_phase_polarity
      # waggle the flux capacitor or something
    end
  end

  RSpec::Core::ExampleGroup::Nested_1.instance_methods(false) # false means don't include methods from ancestors
  # => [:invert_phase_polarity]
:method_in_example_group_called_in_spec: |
  describe "a method in an example group" do
    def the_method_in_question
      :result
    end

    it "can be called from within a spec" do
      the_method_in_question.should eq(:result)
    end
  end
:rspec_example_group_run_definition: |
  def self.run(reporter)
    if RSpec.wants_to_quit
      RSpec.clear_remaining_example_groups if top_level?
      return
    end
    reporter.example_group_started(self)

    begin
      run_before_all_hooks(new)
      result_for_this_group = run_examples(reporter)
      results_for_descendants = children.ordered.map {|child| child.run(reporter)}.all?
      result_for_this_group && results_for_descendants
    rescue Exception => ex
      RSpec.wants_to_quit = true if fail_fast?
      fail_filtered_examples(ex, reporter)
    ensure
      run_after_all_hooks(new)
      before_all_ivars.clear
      reporter.example_group_finished(self)
    end
  end
:rspec_example_group_run_examples_definition: |
  def self.run_examples(reporter)
    filtered_examples.ordered.map do |example|
      next if RSpec.wants_to_quit
      instance = new
      set_ivars(instance, before_all_ivars)
      succeeded = example.run(instance, reporter)
      RSpec.wants_to_quit = true if fail_fast? && !succeeded
      succeeded
    end.all?
  end
:instance_variable_set_example: |
  class Thing
    def initialize
      @value = Object.new
    end
  end

  class OtherThing
  end

  thing = Thing.new
  thing.instance_variables # => [:@value]
  ivar = thing.instance_variable_get(:@value) # => #<Object:0x007fe43a050e30>

  other_thing = OtherThing.new
  other_thing.instance_variables # => []

  other_thing.instance_variable_set(:@transplanted_value, ivar)
  other_thing.instance_variables # => [:@transplanted_value]
  other_thing.instance_variable_get(:@transplanted_value) # => #<Object:0x007fe43a050e30>
:rspec_example_run_definition: |
  def run(example_group_instance, reporter)
    @example_group_instance = example_group_instance
    @example_group_instance.example = self

    start(reporter)

    begin
      unless pending
        with_around_each_hooks do
          begin
            run_before_each
            @example_group_instance.instance_eval(&@example_block)
          rescue Pending::PendingDeclaredInExample => e
            @pending_declared_in_example = e.message
          rescue Exception => e
            set_exception(e)
          ensure
            run_after_each
          end
        end
      end
    rescue Exception => e
      set_exception(e)
    ensure
      @example_group_instance.instance_variables.each do |ivar|
        @example_group_instance.instance_variable_set(ivar, nil)
      end
      @example_group_instance = nil

      begin
        assign_generated_description
      rescue Exception => e
        set_exception(e, "while assigning the example description")
      end
    end

    finish(reporter)
  end
