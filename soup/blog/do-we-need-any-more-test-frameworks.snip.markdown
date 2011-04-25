Do We Need Any More Test Frameworks?
=====

I gave this as a lightning talk at the [February 2011 LRUG][], but after the storm had passed and the air was calm again, I felt like I hadn't really done justice to the points I was trying to make. It's very hard to talk coherently in twenty-second chunks!

Anyway, I felt it was worth taking a more relaxed stroll through the ideas - partially because I think they are interesting, and I hope there is some validity in them, but mostly so that I can externalise them and get on with my life.

Apologies if the narrative is a bit meandering, hopefully it will make sense in the end. It's not really *about* test frameworks, as I think there's a larger point. Hopefully you'll read that far.


The Hubris of the Ruby Developer
---------------

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.001.jpg" width="560">

At some point in all our careers as programmers, we are inevitably compelled to rework one or more of the tools we use to ply our trade. Familiarity breeds contempt, and the daily use of our chosen language and libraries will similarly expose their apparent flaws.

It begins as a niggle - _"oh, I really don't get why Library X makes it hard to do Y"_ - which then festers into a complaint, and finally into the uncontrollable desire to throw away the existing code and write something new, something clean, something better.

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.002.jpg" width="560">

As developers with we are empowered to control basically everything that composes our software, and particularly as Ruby developers I think we are almost encouraged to produce new libraries and APIs to make our work more pleasant to endure. But anyway, I'm digressing.


Why We Chose To Rewrite Test Frameworks
---------

We use many tools as part of our daily grind, but three kinds are present regardless of the specific project. These are the real tools of our trade, the ones we grow to understand inside out: the underlying language we write our software in; the application frameworks we use to avoid the boring, repetitive chore of replicating the plumbing of our software environment; and finally, the test framework we use to express the intent of the software we are building.

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.003.jpg" width="560">

Each of these will irritate after a while. In general I am quite happy with [my programming language of choice][Ruby], but sometimes I wish Ruby had the capacity to pass multiple blocks to methods like [Smalltalk does][]. But I can barely imagine writing my own Ruby-esque language just to support that idle whim. Not many people write their own languages.

As for application frameworks, well there are quite a few more things that niggle me about [Rails][] - too many to list here without being boring - but at the same time, there is much more about it that I like. While it's not quite as crazy to consider addressing my niggles by writing my own web framework - more than a handful of people have - it's still too large an undertaking for me to really convince myself that it's going to pay dividends.

But ah, now - the test framework. As good developers, are using this code almost every minute of every day. I'm sure I spend a significantly larger portion of my time considering tests than I do actually implementing the behaviour to satisfy them. I care about my tests deeply; I am investing time and effort into them to save me problems - regressions - in the future. It's only naturally that the minor incompatibilities between my own ideas about How To Do Things Right would chafe most against this part of my toolset.

And, unlike the language or the application framework, I can actually imagine writing my own. It's not such a sprawling piece of code, and its domain is reasonably compact.

The target of my discontent has practically chosen itself.

And it doesn't matter which actually library you are currently using, either.

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.004.jpg" width="560">

If you're using [test/unit][], you've already given yourself innumerable reasons to want to throw it away and write your own tool. It's clunky to write, overly-laden with scaffolding, and a nightmare to extend. My personal journey (which we'll come to in a bit) started here, when I wanted to output test results in a nicer way, but was almost instantly hobbled by the nature of `test/unit`, regardless of whatever extension library you might layer on top (more about that later too).

Or perhaps you might be using [RSpec][], and have suffered one API-breaking change too many (I don't use RSpec personally, but have heard the wails and moans of colleagues when they, for example, changed the name of the file that must be required).

Or even [Cucumber][], which for all its claims is slow, and whose separation of "steps" and "support" and "features" is hard to manage effectively and consistently, and whose linear test format prevents the use of any of the control structures (can I get a loop please?) which we programmers have become fond of over the last fifty or so years.

Your reasons will almost certainly be different, and doubtless more valid, but my point is this: whatever they are, and whichever library they use, at some point you will feel that the only way to make progress with your life is to abandon it, and to rebuild it yourself.


The King is Dead, Long Live the King
------

But you've invested all your time in your tests already, so chances are you'll want it to be vaguely compatible with the concepts (if not the syntax) of your previous library of choice, and that means writing something like this:

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.005.jpg" width="560">

When getting down to the nuts and bolts of running a test, this common pattern prevails. Do some setup, then run the test and check behaviour, and finally clean up afterwards so the next test operates in a clean environment. You can call the methods whatever you like, but the basic pattern is the same.

And guess what! It's actually trivial to implement:

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.006.jpg" width="560">

This is the general syntax that we've decided we want - no cruft around it, no distractions from the test framework. Ad our instincts we right, because it's actually quite simple to implement. There are only really two tricks involved.

<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.007.jpg" width="560">

The first is to use instance_eval to run the contents of the test as if our current self is the receiver for all method calls within the block. This is in contrast to using yield, which would require us to pass self as an argument for the block. (e.g. Yield self). This means that we can call before and it without receivers (e.g. test.before), keeping the syntax to a minimum.

The second trick is to stash the blocks that describe the setup, test and so on using instance variables, that than evaluating them immediately. We could used the blocks to create methods using define_method, but why bother? This is simple and clear, and we've managed to replace our old, heavy test framework with something cleaner and lighter, right?

Here's an actual working example, rather than the abbreviated version in the slide:

Class Hubris
Def initialise(&block)
Instance_eval(&block)
End
Def before(&block)
@before = block
End
Def it(name, &block)
@tests << [name, block]
end
Def after(&block)
@after = block
End
Def run
@tests.each do |(name, block)|
print name + ": "
Instance_eval(&@before)
Puts Instance_eval(&block)
Instance_eval(&@after)
End
End

We've missed a minor piece of behaviour which people will expect, which is sharing state between these blocks. In our simple example this is fine, since instance_eval is being called from the same instance of Hubris, but what if someone using our framework wanted to store a value in an instance variable called @before? They'd replace our setup block, and everything would break. Not good.

Thankfully there's a simple fix again


<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.008.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.009.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.010.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.011.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.012.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.013.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.014.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.015.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.016.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.017.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.018.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.019.jpg" width="560">
<img src="http://interblah.net/assets/more-test-frameworks/more-test-frameworks.020.jpg" width="560">