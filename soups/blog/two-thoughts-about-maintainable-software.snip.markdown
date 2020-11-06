Two thoughts about maintainable software
======

I really enjoyed [the most recent episode][maintainable-glv] of {l robby-russell}'s podcast "[Maintainable][maintainable]", in which [Glenn Vanderburg][glv][^glenn] talks about capturing explanations about code and systems, along with managing technical debt. It's a great episode, and I highly recommend pouring it into your ears using whatever software you use to gather pods.

The whole thing is good, but there were two specific points brought up fairly early in their conversation that got me thinking. What a great excuse to write a post here, and make me feel less guilty about potentially _never_ publishing the Squirrel Simulator 2000 post I had promised.

I know; I'm sorry. Anyway, here's some tangible words instead of that _tease_. Enjoy!

## Documenting the why

At the start of the conversation, Robby asks Glenn what he thinks makes "maintainable" software, and part of Glenn's response is that there should be comments or documents that explain _why_ the system is designed the way it is.

> Sometimes things will be surprisingly complex to a newcomer, and it's because you tried something simple and you learned that that wasn't enough. Or sometimes, things will be surprisingly simple, and it's good to document that "oh, well we thought we needed it to be more complicated, but it works fine for [various] reasons."

Robby goes on to ask how developers might get better at communicating the "why" -- should it be by pointing developers at tickets, or user stories somewhere, or it should be using comments in the code, or maybe some other area where things get documented? And without wanting to directly criticise Glenn's answer, it brought to mind something that I have come to strongly believe during my career writing software so far: the right place to explain the _why_ is the **commit message**.

### But why not comments?

I've lost count of the number of times that I've found a comment in code and realised it was wrong. We just aren't great at remembering to keep them updated, and sometimes it's not clear when a change in the implementation will reduce the accuracy of the comment.

### But it's already fully explained in the user story/Basecamp thread/Trello card...

I've also lost count of the number of times that a commit message contains little more than a link, be it to a defunct Basecamp project, or a since-deleted Trello card, or am irretrievable Lighthouse ticket, or whatever system happened to be in use ten years ago, but is almost certainly archived or gone now, even if the service is still running.

And even if we are lucky and that external service _is_ still running, often these artefacts are discussions where a feature or change or bug is explored and understood and evolved. The initial description of a feature or a bug might not reflect the version we are building right now, so do we really want to ask other developers and our future selves to have to go back to that thread/card/ticket and re-synthesise all those comments and questions, every time they have a question about this code?

### Put it in the commit message

Comments rot. External systems, over the timescales of a significant software product, are essentially ephemeral. For software to be truly maintainable, it needs to carry as much of the explanation of the why _along with it_, and where the code itself cannot communicate that, the only place were an explanation doesn't rot is where it's completely bound to the implementation at that momment in time. And that's exactly what the commit message is.

So whenever I'm writing a commit, I try and capture as much of the "why" as I can. Yes, I write [multi-paragraph][example-commit-1] [commit][example-commit-2] [messages][example-commit-3]. The first commit for a new feature typically includes an explanation of why we're building it at all, what we hope it will do and so on. Where locally I've tried out a few approaches before settling on the one I prefer, I try and capture those other options (and why they weren't selected) inside the commit message for the approach I _did_ pick.

Conversely, if I am looking at a line of code or a method and I'm not sure about the _why_ of it, I reach for `git blame`, which immediately shows me the last time it was touched, and (using [magit][] or any good IDE) I can easily step forward and back and understand the origin and evolution of that code -- as long as we've taken the time to capture the _why_ for each of those changes. And this applies just as much to the code that I wrote as it does to other developers. _Future-me_ often has no idea why I made certain choices -- sometimes I can barely remember writing the code at all!

So anyway, in a nutshell, when you're committing code, try to imagine someone sitting beside you and asking "why?" a few times, and capture what your explanation would be in your commit message.

_BONUS TIP_: finding that your "why" explanation is a bit too long? That's probably a signal that you need to make smaller commits, and take smaller steps implementing your feature. I've never regretted taking smaller steps, even though I recognise sometimes the desire to "just get it done" can be strong.


## Using tests as TODOs

A little later, the conversation turns to the merits of "TODO" comments in the code, and how to handle time-based issues where code needs to exist but perhaps only for a certain amount of time in its current form, before it need to be revisited. It's not unusual for startups to need to get something into production quickly, even if they _know_ that they are spending technical debt in doing so. Glenn correctly points out that it can be hard to make sure that comments like that get attention in the future when they should.

> The problem is that when you put them in there, there's no good way to make sure you pay attention when the time comes [to address the debt]

I spend a fair bit of my professional time working with a startup that has a very mature (13 years old) Rails codebase, and more often than not, moving quickly involves _disabling_ certain features temporarily, as well as adding new ones. For example, on occasion we might need to disable the regular newsletter mechanism and background workers while the company runs a one-off marketing campaign. To achieve this, we need to disable or modify some parts of the system temporarily, but ensure that we put them back in place once the one-off campaign is completed.

In situations like this, I have found that we can use the tests themselves to remind us to re-enable the regular code. Here's a very simple test helper method:

~~~ ruby
def skip_until(date_as_string, justification)
  skip(justification) unless Date.parse(date_as_string).past?
end
~~~

Becase we have tests that check the behaviour of our newsletter system under normal conditions, when we disable the implementation temporarily, these tests will naturally fail, but we can use this helper to avoid the false-negative test failures in our continuous-integration builds, _without_ having to delete the tests entirely and then remember to re-add them later:

~~~ ruby
class NewsletterWorkerTest < ActiveSupport::TestCase
  should "deliver newsletter to users" do
    skip_until('2020-12-01', 'newsletters are disabled while Campaign X runs')
    
    # original test body follows
  end
  
  # other tests 
end
~~~

This way, we get a clear signal from the build when we need to re-enable something, without the use of any easy-to-ignore comments at all.


## Not all comments?

I'm not completely opposed to all comments, but it's become very clear to me that they aren't the best way to explain either what some code does, or why it exists. If we can use code itself to describe _why_ something exists, or is disabled -- and then remind us about it, if appropriate -- then why not take advantage of that? 

And if there's only one thing you take away from all the above, let it be this: **take the time to write good commit messages**, as if you are trying to answer the questions you could imagine another developer asking if they were sat beside you. You'll save time in code reviews, and you'll save time in the future, since you'll be able to understand the context of that code, the choices and tradeoffs that were made while writing it -- whe _why_ of it -- much faster than otherwise.

Here's a great talk that further illustrates the value of good commit messages, and good commit hygiene in general: [A Branch in Time](https://tekin.co.uk/2019/02/a-talk-about-revision-histories) by [Tekin Süleyman](https://tekin.co.uk).

[^glenn]: I met Glenn once, at a dinner during the {l rubyfools-redux, "Ruby Fools"} conference (such a long time ago now). He said some very nice things to me over that dinner, which I've never forgotten. So thanks for that, Glenn!
[glv]: https://twitter.com/glv
[maintainable-glv]: https://www.maintainable.fm/episodes/glenn-vanderburg-dont-ask-for-small-things
[maintainable]: https://www.maintainable.fm
[example-commit-1]: https://github.com/norman/friendly_id/commit/4bd4300035b5c250aeb2e5feec4c2feb9bcf2a19
[example-commit-2]: https://github.com/gtd/validation_scopes/commit/2c9139af94239444575e1f413b9303badd149eb6
[example-commit-3]: https://github.com/rails/rails/commit/d44b628ad0be4791180eb70863cfe5392ec0f177
[magit]: https://magit.vc


:kind: blog
:created_at: 2020-11-06 14:00:00
:updated_at: 2020-11-06 14:00:00
