LGTM
=======

There are a number of techniques that remote teams can use to collaborate, but the main one _the client_[^client] relies on is code review via pull requests.

Code review on pull requests can help catch potential issues, but it's not as good as actual TDD (or any other conscientous testing practice) because once implementation is written, it's hard to evaluate what aspects of it are intended behaviour and which are side effects, or even bugs.

Code review on pull requests can be good for getting a second opinion on a specific implementation, but they're not as good as pairing, where ideas and approaches can be discussed and evaluated before any investment is made, and hard-to-spot edge cases can be identified before they are committed into code.

Code review on pull requests is good for communicating between developers about what everyone is working on, but they're not as good as actual discussion, ideally documented, because without conscious effort to capture context -- the _why_ this is being built, and _why_ in this particular way -- in either the tests, the commit messages, the pull request description, or ideally **all three**, it's often up to the reviewer to try and reverse-engineer the intent and original goals of the piece of work. It's easy to underestimate how much effort that reverse-engineering can be.

Code review on pull requests is good for avoiding unending, ambigious conversations about what _might_ work to solve a problem, because it's always easier to measure the value of something concrete than something hypothetical, but by the time the review happens there's already investment in that particular solution and that particular implementation of that solution. I see the same thing with MVPs, which should be built quickly without particular care, then learned from and finally discarded, but instead are built quickly and without particular care, but then put into production to become the foundation for future work... but I'm digressing; the point is that we developers tend to believe that extant code has more value than it really does, and the momentum of that particular approach can override any fundamental questions[^approach] that a code review might raise.


_But_... getting good at testing requires effort, and pairing requires a lot more energy than hacking solo, and thoughtfully documenting takes time, and development zen-like detachment from the fruits of our labour doesn't come naturally either. And all these things require practice, and who has time to practice when there are features to ship!

So we do code reviews on pull requests. LGTM[^lgtm] :(


[^client]: At the moment, I spend most of my active development time working remotely for a single client. It's a Rails project that's been running for approximately 13 years, with around 5 developers of varying skill levels actively contributing to the backend, where I spend most of my time.
[^approach]: "Did you consider, maybe, not implementing this at all?"
[^lgtm]: "Looks Good To Me", the hallmark sign that a reviewer has not even checked out and run the code, let along read it carefully and thought about more than syntax.

:kind: blog
:render_as: Markdown
:created_at: 2020-07-28 22:52:00 +01:00
:updated_at: 2020-07-28 22:52:00 +01:00
:author: james
