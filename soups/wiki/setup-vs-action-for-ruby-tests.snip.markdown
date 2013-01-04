Setup vs. Action for Ruby tests
=========

I've been thinking about how to express behaviour in tests in a natural and fluid way. One problem I've noticed is that with the classes xUnit *setup -> test -> teardown* structure is that the `setup` often ends up doing more work than it perhaps should.

This forms some of the background behind my work on {l kintama}.

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

So, combine this idea with a general frustration at the way that [test-unit][] works[^test-unit-logging] and a continued unwillingness to drink the [rspec][] koolaid[^rspec-koolaid], I did what it turns out a million other people have done, and started exploring my own test framework, {l kintama}.

Next steps
----------

I want to explore using `action` in tests more; this almost certainly means using it in anger on an actual software project.


[^test-unit-logging]: I'd wanted more verbose logging of test runs for a long time, with nested printing of context and test names, to more quickly see which tests were failing while they were still running. Unfortunately, the way that [test-unit][] works behind the scenes makes this basically impossible. See [MonkeySpecDoc](http://jgre.org/2008/09/03/monkeyspecdoc/) for an example of an attempt which hits this limitation. Yes, [rspec][] does this.

[^rspec-koolaid]: Basically I didn't want to invest time learning the pseudo-english matcher language that was heralded as being the main benefit at [rspec][]'s inception (the marketing may have changed, I don't know). The term [BDD][] may have served a purpose once, but I'm not sure now. I don't care if I'm writing "tests" or "specs", I just care about being able to quickly express some behaviour. Oh, and everyone was complaining about new versions of rspec breaking APIs. Anyway, this is just context, it's not objective fact.


[test-unit]: http://ruby-doc.org/stdlib/libdoc/test/unit/rdoc/
[shoulda]: https://github.com/thoughtbot/shoulda
[rspec]: http://rspec.info
[BDD]: http://en.wikipedia.org/wiki/Behavior-driven_development
[should-change-deprecation]: http://robots.thoughtbot.com/post/731871832/this-should-change-your-mind
[should-change-deprecation-my-comment]: http://robots.thoughtbot.com/post/731871832/this-should-change-your-mind#comment-58679148

:created_at: 2013-01-04 09:53:06 -0600
:updated_at: 2013-01-04 09:53:06 -0600
