TDD in early-stage startups
===========================

[Obie][] left Hashrocket, the development consultancy he started, to work on [his startup venture][rightbonus]. Hashrocket very successfully established a reputation as the company that you go to if you are serious about your venture, and want the very best development that money can buy (with a price tag that matches -- [check the budget][hashrocket budget]).

Anyway, he recently posted about [some changes in his thinking][dark side] about testing during the software development lifecycle. I think there are some interesting issues that this post raises, and I was going to post a comment but then remembered my own sentiments {l on-commenting}. So here we are.

Once you scrape away the layer of "dark side" / "rebel" / "high ceremony" / "dogma rejecting" nonsense, the gist of the post (and may Obie forgive me if I have mis-interpreted) is:

> It's foolish to invest time writing many tests when you're still exploring if there's actually a market for your product

Instead, Obie suggest some high level loose testing around a "large spike solution" which you use to explore the market (i.e. "pivot"). With his approach, Obie has traded faster exploratory development in the short-term with huge technical debt to be dealt with later, and he apparently realises this, but for some reason it's OK.

I would never pay for code that didn't come with a good suite of tests, so why would I invest in a product that doesn't have a good set of mechanisms for preventing regression and breakage, nor a strategy for adding those mechanisms later? Obie's clearly a smart and successful person, so I want to understand why he's taking this approach.


Spikes
------

[Spiking][] is very useful and incredibly important tool we can use when exploring development, but the most significant caveat of spike development is that you *can not put that code into production*. This is where Obie isn't sure:

>  I think that advice is very dependent on the skills of the people writing the prototype system. If they are experienced developers, they're going to inherently know a lot of the application patterns that should be used and the amount of technical debt introduced will be low enough to feel comfortable with the app in production.

What's being said here is, basically, if you're a good enough developer, then chances are that your spike is actually good code, and it would be a waste to throw that away.


Good enough for clients?
-----------------------

I wonder if Obie regrets using TDD on the client projects worked on at Hashrocket, which presumably fit into the class of "typical web-based applications built with Rails where nobody is going to die if you occasionally get a 500 error on an edge case" he mentions?

With the switch from development provider to product owner, is it true that we aren't willing to pay for what we used to sell?

I don't have any information about the clients that Hashrocket worked with, or what their development practices were or now are, but I would be very surprised if a many of those clients weren't also exploring the viability of their products, and I would be very surprised if Hashrocket didn't strongly advocate those clients should invest in well-tested code.

So what's changed? It's fair to say that, unlike agency situations, Obie is in a position to fix anything that does happy to break in production, but that's obviously a slippery slope to Hacksville.


So, when do we start testing properly then?
-------------------------------------------

If we're to accept Obie's suggestion, then there's one obvious question that must be answered, which Obie raises himself:

> When am I no longer an early-stage startup? The implication being that at some point, you know enough about your market fit and product requirements that you can transition into what I've been calling high-ceremony development practices.
>
> I don't have the answer to that question. I suspect that the size of the development team has a lot to do with how you'll want to answer that question for your own effort, because multiple workstreams on a single codebase has a tendency to skyrocket technical debt.

This hints at the real problem with relying on a "large scale spike" that's running in production.

Let's say that you now understand enough about the market for your application that you're ready to start really building out your product. As soon as you get another developer involved -- someone who doesn't have all of underlying reasoning in their head -- they're going to really struggle to add value to your application in a few significant ways:

- they'll have to infer behaviour purely from the implementation;
- they'll be missing useful demonstrations of *why* the code was written the way it was;
- they have very weak mechanisms providing confidence that any changes they make won't break something elsewhere.

To deal with this, you'll have to invest a huge amount into post-facto communication, which is going to slow down progress enormously.

And what if you now *do* want to start adding some tests? Any developer who has had experience retrofitting tests onto an existing application will know that it's a significant undertaking, with -- again -- very little externally-facing improvements to the software. Edge-cases will be missed, assumptions will be made, and your tests won't provide the same level of confidence that new code isn't introducing regression.

Without actually starting development again (i.e. scrapping the spike), you'll be fighting an uphill battle to get your application into the same state as it would be if you'd been testing from the start. It's {l The Straight Path}.


### A brief tangent about business value

Muddled in with his thoughts about testing, Obie also suggests that developers should get better at evaluating the code they are writing against business-level goals ("increasing conversion" or "higher click-through"), and this is fine, but it's not particularly relevant to the "dogma rejection" that the rest of his post is about.



Spike code is not for production
-------

I'm not suggesting that it's wrong to spike, or that it's wrong to explore the market for your application with actual running software. I totally agree with those things.

The dangerous idea here is that it's OK to consider "spiked" code as production-ready without a strategy to replace that code with "non-spiked" (i.e. tested) code in the future, and I am not aware of *any* strategy to do this that doesn't require *so much more* effort later to counter the technical debt; it will be incredibly tempting to just ignore it and continue building on shaky foundations.

I hope Obie's startup goes well, but I also hope that he doesn't ask any other developers to start __hacking__ on his software before he's had a chance to throw that spike away and build some solid code.


Testing is hard, but so are most valuable things
------------------------------------------------

Tests give you confidence, to have others understand and contribute to your code, and to ensure you don't break anything a few weeks later when you touch one aspect of the system again.

[Chris Parsons][] left a comment on Obie's blog that is reasonably close to what I feel the right approach is. Obie introduces the phrase "high ceremony testing", by which I infer that he means testing which takes time and thus slows down development. The *right* solution is to just get better and faster at testing.

Testing is hard work, mostly because it requires thinking about the code we *want* to write and explaining why we want to write it. It's a lot like teaching -- it can be hard to figure out a way to explain a concept that we understand well to someone who doesn't have our background; harder still to justify one choice over another. But when we do, we often discover subtle errors in our thinking, and aspects that we hadn't considered. These are invaluable.

It's not about test coverage or any kind of "ceremony". It's all about communication, a skill that we developers do not stereotypically excel at. That's why it's hard work, but that doesn't mean we shouldn't strive -- all the time -- to get better at it.



[dark side]: http://blog.obiefernandez.com/content/2011/05/the-dark-side-beckons.html
[rightbonus]: http://blog.obiefernandez.com/content/2011/02/since-i-finally-got-my-launchrock-invite.html
[obie]: http://obiefernandez.com
[hashrocket budget]: http://hashrocket.com/contact/rfp
[spiking]: http://jamesshore.com/Agile-Book/spike_solutions.html
[Chris Parsons]: http://pa.rsons.org/


:updated_at: 2011-07-25 16:44:00 +0100
