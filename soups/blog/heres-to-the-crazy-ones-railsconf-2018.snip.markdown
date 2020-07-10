Here's to the crazy ones (RailsConf 2018)
================================

<iframe width="560" height="315" src="https://www.youtube.com/embed/h3xe-Rf4A6k" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

_This is a transcript of a presentation I gave at [RailsConf 2018](http://raailsconf.org); the actual slides are [here](https://speakerdeck.com/lazyatom/heres-to-the-crazy-ones); the [video is from confreaks](http://confreaks.tv/videos/railsconf2018-here-s-to-the-crazy-ones)._

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).001.png 'In some ways I hate how this opening slide looks, but it is one of the only two references in the presentation that supports the title. The background images are those produced by Apple for their marketing campaign "Thing Different" (the other is similarly cheesy, later one). The font is the one Apple used pervasively at that time.')

My name is James Adam, and I’ve been using [Ruby](http://www.ruby-lang.org), and [Rails](http://www.rubyonrails.org), for a long time now.

I’d like to share with you some of my personal history with Rails.

Hopefully it won’t be too self-indulgent, and hopefully I won’t bore you before I get to the actually “important” bit at the end. I also want to apologise — every time I come to the US, I seem to get a cold, so please excuse me if I need to cough.

Anyway, let’s get started. Sit back, as comfortably as you can.

You can feel your limbs and eyelids getting heavier. All your worries are drifting away. Let me gently regress you all the way back to 2005. 

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).004.png "You are feeeeeeling veeeeerry sleeeeeepy...")

## Welcome to 2005

This is me in 2005. I was just finishing [my PhD](http://assets.lazyatom.com/thesis.pdf).

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).005.png "Fun fact: actually this picture is from 2001, but I hadn't changed that much, and it supported my point better than other pictures I could find.")

I’d actually discovered Ruby a few years earlier, and I’d totally fallen in love with it. I rewrote most of the code I was using for my research in Ruby. I was so excited about Ruby when I discovered it that I sent this in an email to my friends, who’d all got “proper” jobs writing software, most of them using Java at the time.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).006.png "This is genuinely real, although I've editted out some surrounding, more-embarassing hyperbole.")

The nature of PhDs is that when you finish, you’ve become a deep expert in a topic that’s so narrow that it can be hard to explain how it is connected to anything outside it. So when I finished my PhD in early 2005, I was worried that I was going to be in a similar state professionally — having fallen in love with a language which I’d never be able to use for work, and instead having to return to Java or C++ or something like that to get a job.

I was incredibly lucky. Just as I was finishing my thesis, this [excited Danish guy](http://david.heinemeierhansson.com) had been [starting to talk](https://signalvnoise.com/archives/000606.php') about a web framework he was writing with the weird name “Ruby on Rails”. 

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).007.png 'From https://signalvnoise.com/archives/000606.php')

Long story short, a job in London got posted to the [ruby mailing list](http://blade.nagaokaut.ac.jp/ruby/ruby-talk/index.shtml), and so I took the seven hour train journey down from Scotland for an interview, and within a few months I was working, in my first job, being paid to use Ruby, and a very early version of Rails (I think it was 0.9 at the time).

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).008.png)


## Working on multiple applications

Our team was like a mini agency within a much bigger media company, and the company used a tangled mess of Excel spreadsheets in various departments, in all sorts of weird and wonderful ways. It was our job to build nice, clean web applications to replace them. We were a small team, never more than five developers while I was there, but we’d work on a whole range of applications, all at the same time.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).013.png)

These days, and particularly with Rails 5.2 which was released a few days ago, Rails provides us with pretty much everything you need to write a web application, but’s easy to forget a time when Rails had almost none of the features we take for granted now.

A time before Active Storage, before encrypted secrets, before Action Cable, before Turbolinks, the Asset Pipeline, before resources or REST, before even Rack!

These are the headline features for Rails in Spring 2005, when [version 0.13](https://github.com/rails/rails/releases/tag/v0.13.0) was released. Migrations were brand new! Can you even imagine Rails without migrations?

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).031.png)

In lots of ways, Rails 0.13 is very similar to modern Rails — it has a the same MVC features, models with associations, and controllers with actions, and ERB templates, and action mailer — but in many other ways it was actually closer to [Sinatra](http://sinatrarb.com) than what we have in Rails today. To illustrate, the whole framework including dependencies and gems it used was around 45,000 lines of code. By comparison, if you today add Sinatra and ActiveRecord to an empty Gemfile today, and run bundle install, with core dependencies it ends up at around 100k of code.

But the core philosophy of Rails was exactly the same then as it is now — [convention over configuration](https://rubyonrails.org/doctrine/#convention-over-configuration), making the most of Ruby’s expressiveness, and providing most things that most people needed to build a web application, all in one coherent package.


## Extracting Engines

So it’s Summer 2005, Rails is at 0.13, and in our team we are building all these applications, and we realise that we’re building the same basic features again and again. 

Specifically, things like code to manage authentication — only allowing the application to be used by certain people — and code to manage authorisation — only allowing a subset of those people to access certain features, like admin sections and so on. At the time, I think we had at least four applications under simultaneous development, which is around one app per developer, and it just seemed counter-productive for each of us to have to build the same feature, each in slightly different ways, making it harder for us to move around between the applications, and increasing the chance that we’d each introduced our own bugs and so on. After all, a big part of the Rails philosophy has always been the concept of DRY — don’t repeat yourself.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).033.png)

And these authentication and authorisation features weren’t particularly complicated; they had the same concerns you would expect (login, logout, forgot password, a user model, some mailer templates and so on). So it occurred to us that what we really needed to do was to write this once, and then share it between all the applications we were building, so they could all benefit from new features and bug fixes, and we’d be able to move between the applications more easily.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).038.png)

In modern Rails, we typically share code by creating gems, and those gems integrate with Rails using a mechanism called “[Railties](http://guides.rubyonrails.org/initialization.html)”, but that was only introduced at the end of 2009 (on New Years Eve, actually).

Before Railties, we had “plugins”, but they didn’t [appear until Rails 0.14.1](https://github.com/rails/rails/blob/b437eee41d38188f10f11e041b82d7def0a20629/railties/CHANGELOG#L42), so they didn’t exist yet either.

Even using just regular gems was problematic, because this is before bundler, and before we’d figured out how to reliably lock down gem versions for an application. They’d need to be installed system-wide, and so if you had multiple applications running on the same host, upgrading the gems for one application could end up breaking another. [Gem freezing](https://github.com/rails/rails/blob/b437eee41d38188f10f11e041b82d7def0a20629/railties/CHANGELOG#L24) also didn’t appear in Rails until version 0.14.

So without any existing mechanisms, we had to roll up our sleeves and invent something ourselves.

So in the late summer of 2005, we extracted all of the login and authorisation code, including controllers and models and views and so on, into a separate repository and then wrote a little one-file patch library, which was loaded when Rails started. This library added paths to the controllers and models into the load paths for Rails, and made a few monkey-patches to Rails’ internals to get everything else working nicely.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).043.png)

Originally this one-file patch was called “frameworks”, but fairly soon after it got renamed to “engines”. The name “engines” was actually the idea of [Sean O’Halpin](https://github.com/seanohalpin), who was my boss at the time and has been programming with Ruby for even longer than me.

## The dawn of plugins

In October of 2005, a few months later, Jamis Buck added an [experimental “plugins” feature](http://web.archive.org/web/20060603204512/http://dev.rubyonrails.org/ticket/2335) to Rails.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).044.png)

A “plugin” was just a folder of code that contained a “lib” directory and a file called “init.rb”, and the “plugins mechanism” would just iterate through subdirectories of “vendor/plugins”, trying to load files called `init.rb` if it could find them. Very simple.

We spotted this feature being added Rails and so I emailed Jamis and David to say “hey, we’ve been working on something similar — if you were interested, we’d be happy to contribute!”

We got a very nice reply, the gist of which was “that sounds very interesting, but perhaps you can package that up as a plugin itself and we’ll see how people use it”. So that’s [exactly what we did](https://markmail.org/message/hg7hramkgo7jstcd), resulting in the “Engines Plugin”, which let you treat other plugins as these vertical MVC slices which could be shared between applications. This is the first homepage for it, hosted on RubyForge.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).045.png)

I also released the first engine, the “Login Engine”, which wrapped up code from one of the original authentication generators we’d used, along with a few tweaks that we found useful.

That was November 1st, 2005.

## The engines plugin is released; the controversy begins

People got pretty excited. Like, super-excited. Which was really exciting for me too.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).049.png)

There was enthusiasm for the demonstration engine that I released, and it seemed that people understood the idea behind what we were doing. Someone tried to turn Typo, which was the first really popular Rails-based blogging platform, into an engine, so they could add blogs into their application.

A lot of people got pretty enthusiastic specifically about not having to write the same old login stuff again and again. Some people, I think, hoped that they would never have to write another login system again ever, and that the simple one we released with work seamlessly for everyone.

But then somebody got so excited, that they started talking about “engines within engines, depending on other engines” and I think it was this idea that ultimately pushed DHH over the edge, and about 10 days later he wrote the [first post about engines on the official Rails blog](http://web.archive.org/web/20060408004005/http://weblog.rubyonrails.org:80/articles/2005/11/11/why-engines-and-components-are-not-evil-but-distracting).

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).053.png)

In the post, David talked about his distrust of the dream of component-based development, and that it’s better to build your own business logic than try to adapt something that someone else wrote, and that we shouldn’t expect to be able to plug in or swap out these high-level components like forums and galleries and whatever, and never have to build them ourselves.

And I agreed with him, but tried to clarified that what engines were great for was extracting code that you’ve written, and sharing it around a bunch of apps that you’re working on at the same time, as long as those features were relatively isolated from the rest of the application. And I think David agreed with that too.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).055.png)

I could see his perspective: when you just have a single application to work on, like, say … Basecamp, then chances are that you can and should develop as much of the business logic yourself as you can. But if you’re working on 3 or 5 or 10 applications, at the same time, then chances are that the balance of value vs cost of sharing starts to tip the other way.

I was pretty happy with that conversation — it seemed like we generally understood and agreed about the potential benefits and dangers of what I was proposing. I’d shared an idea, and David had merely expressed a bit of caution, but a bunch of people had become super excited by it, maybe a little _too_ excited, and on the other side a LOT of other people took David’s post as a declaration that the idea was fundamentally bad and to be avoided at all costs.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).060.png)

And so that’s basically how things played out for the next three years. Every now and then someone would write a blog post saying “Rails needs something like engines” or “engines are actually pretty useful” and they’d be met with the reaction “Didn’t you know that engines are ‘too much software’ (whatever that means), and like, really bad?”

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).064.png "Source: https://web.archive.org/web/20090925222810/http://glu.ttono.us:80/articles/2006/08/30/guide-things-you-shouldnt-be-doing-in-rails")

And so I’d write a comment or another blog post trying to be reasonable and say “well, it’s more complicated than that” and occasionally the author might add a little clarification to their post but by that point it’s too late and you’ve got people commenting that rails engines are actual evil.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).067.png)

I call this time the wilderness years.

## The Wilderness Years

During this time I tried to respond to the criticisms of the engines concept, with varying degrees of success. It was occasionally… quite frustrating.
 
![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).069.png)
 
I spoke at a bunch of conferences about plugins, and sometimes engines, and also tried to gently steer the development of the plugin architecture in Rails to reduce the amount of patching that the engines plugin needed to do, by adding things like controlling plugin loading order, exposing Rails configuration and initialisation hooks to plugins, and stuff like that.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).070.png)

Plugins became very popular, and went from being shared as links on a wiki page to having their own directory you could search and comment on.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).071.png)

Here’s an example of a fun plugin that I wrote for one of those presentations. See, I’m having fun!

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).072.png "The 'acts_as_hasselhoff' plugin did things like replace all images with pictures of David Hasselhoff, and played the Knightrider theme when running tests")

And when, if I did mention engines in those presentations, I tried to explain that there were valid use cases, and sure, you could use them in a terrible way, but that doesn’t mean people should _never_ use them. I hoped that those presentations, if not actually changing anyone’s mind, might’ve at least softened people a little to the idea that engines might not be 100% terrible.

But then on the official plugin directory you’d get someone tagging the engines plugin as “shit”, and the cycle would start again. (I never did find out who that was.)

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).074.png)

Some people would go to lengths to explain why “Rails Engines” were bad, but I’d try to write a short comment to respond to each of their points and hopefully clear up any misconceptions about what the engines plugin did and what engines were good for.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).077.png "Source: http://web.archive.org/web/20080105021818/http://www.pluginaweek.org:80/2006/11/01/rails-engines-too-much-of-a-good-thing/")

In this particular case, though, what was super confusing is that the same people then released their own plugins trying to basically do the same thing!

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).078.png)

The wilderness period lasted so long that some companies even wrote engines-like plugins without realising that engines even existed! (Brian and I actually had a conversation afterwards, and talked about merging the projects).

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).079.png "Source: https://content.pivotal.io/blog/build-your-own-rails-plugin-platform-with-desert")


## Rails 3: an evolution

So this is all happening between 2006 and 2008, during which a new Ruby web framework appeared, called [Merb](http://web.archive.org/web/20080118054508/http://merbivore.com:80/").

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).080.png "Source: http://web.archive.org/web/20080118054508/http://merbivore.com:80/")

It was designed to be extremely fast — largely because it didn’t do very much — and be particularly good at handling many simultaneous requests and things like file uploads. Unlike Rails, which was at the time a relatively tightly-coupled set of frameworks, Merb was designed to be extremely modular, so it could (for example) support multiple ORM frameworks. It was also designed to have clear and stable internal APIs, since much of the merb framework was written as optional plugins.

One of the developers most involved in Merb was [Yehuda Katz](http://yehudakatz.com/), who eagle-eyed people will have spotted was generally sympathetic to the concept of “engines”, and so it’s probably not surprising that in 2008, Merb introduced their implementation of the idea, called “[Merb slices](http://web.archive.org/web/20100102021855/http://brainspl.at:80/articles/2008/05/21/merb-slices)”, to a generally positive response from the Ruby community.

But it’s not a huge surprise that this is how the most popular Rails podcast at the time chose to frame that.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).082.png)

And I don’t blame the presenters for thinking or saying that, it was just a representation of the opinion in the community as a whole, at that a time.

This is a painting of “[Sysiphus](https://en.wikipedia.org/wiki/Sisyphus)”, who in Greek mythology was cursed by the Gods by being forced to roll an immense boulder up a hill only for it to roll down when it nears the top, repeating this action for eternity. These days it’s a common image invoked to describe tasks that are both laborious and futile.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).084.png)


## A surprising development 

So we come to the end of 2008. Rails is about to reach version 2.3. The controversy had largely died down — people who got some value out of working with engines were pretty happy, I hope! and the people who thought they were evil seemed to have forgotten about they existed.

So you can imagine my surprise when I received this email from DHH with the subject line, “I repent”.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).086.png)

I think I actually became giddy at the time. Rails core had decided that engines weren’t _evil_, and that they were going to be integrated into the framework. My work… was done.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).088.png)

OK, not really. Without going into a huge amount of detail, in Rails 2.3, plugins absorbed some of the core engines behaviour. They could provide controllers, views and most other types of code. This was released in Rails 2.3, in March 2009.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).092.png)

At the same time, [Merb and Rails decided to merge](http://web.archive.org/web/20170630220119/http://weblog.rubyonrails.org/2008/12/23/merb-gets-merged-into-rails-3/), and Rails 3 would be the end result. The goal of doing this was, in part, to establish some clear, stable APIs within Rails, that other libraries and plugins could rely on, so they they didn’t break when Rails was upgraded. This was a fairly significant rewrite of a lot of the core parts of Rails in order to create those APIs.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).093.png)

Yehuda and [Carl Lerche](http://carllerche.com) did much the work, and as part of it, they decided that rather than having a Rails application, and these “engine” things inside it that looked like a Rails Application and got access to the same hooks and config and so on, that instead, the outer application itself should just be a Rails Engine with a few other bells and whistles. So I guess the “engines inside of engines” person actually got their wish!

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).094.png)

This was released as Rails 3.0, in 2010.

Finally, with Rails 3.1, released in August 2011, the last two bits of work that the engines plugin did — managing migrations from engines, and assets became part of Rails, and the plugin that I had written was officially deprecated.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).096.png)


## The Hype/Hate Cycle

You have probably heard of the [Gartner Hype Cycle](https://www.gartner.com/technology/research/methodologies/hype-cycle.jsp), which is a way of understanding how technology trends evolve.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).102.png)

We have the initial creation or discovery of the technology, then the peak of inflated expectations, where everyone is excited about having jetpacks or living on the moon, but then the trough of disillusionment, when it turns out it’s actually much harder to build a jetpack than we thought, and there are a lot of things we need to built one that aren’t ready yet. But eventually technology starts to climb the slope of enlightenment, as we figure all those little things out and iron out the problems so we don’t set our legs on fire and so on, and we finally get to the plateau of productivity, when zipping around on our jetpacks seems pretty ordinary and we look back at old movies of people moving around using their _legs_ and laugh about how quaint they seem.

And I think we can use a similar cycle to understand how the Rails community reacted to the “engines” concept too. For engines, it took just under six years from idea to acceptance.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).107.png)

We have the same starting point, and the same peak of inflated expectations (“I’ll never need to write login code again!!”), but then we enter what I like to call the TROUGH OF RECEIVED OPINIONS, where some big names in the community have been like “woah woah woah”, and we’ve personally haven’t actually tried using the technology but we’ve heard it sucks and so basically it’s the worst thing ever. And then for about three years, we scrabble up the SLOPE OF FEAR, UNCERTAINTY and DOUBT, where people find themselves thinking “hey, wouldn’t it be great if I could share this slice of functionality between all my apps?”, but when they try, they get bogged down in all the blog posts, often from years ago saying “no! It sucks!” and so they give up. And then, finally we reach the plateau of “oh — are those still a thing?”

And as you can see, at the end of the cycle, we are just about neutral. We’re basically back where we started, but at the very least I can finally put the boulder down and stop pushing it up the hill :-)

If you’d like a nice summary, I found this quote in the book “[Rails 3 in Action](https://www.manning.com/books/rails-3-in-action)”, which was published around the same time.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).108.png)


## Engines: there when you need them

So, what changed in 2008? Well, I think think it’s quite simple in retrospect. Rails was originally extracted from Basecamp, the software that DHH built and still works on today. At the start of Rails life, Basecamp was the only Rails application that David worked on, but between 2005 and 2008, 37signals added another three flagship applications, along with a few other smaller ones like Writeboard and Ta-da list.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).110.png)

Their small team — I think it was four developers at that point — had to build and support all those applications… at the same time… that… sounds… familiar, doesn’t it? :)	

In the “[Rails Doctrine](https://rubyonrails.org/doctrine/)”, which is a somewhat-intentionally-provocative essay that David wrote about two years ago, there’s a section called “[Provide sharp knives](https://rubyonrails.org/doctrine/#provide-sharp-knives)”. 

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).113.png)

What it basically says is that with some of the tools that Rails gives you, it’s definitely possible to get in a mess. But instead of protecting you from misusing them by keeping them from you altogether, we should trust ourselves to use those tools and approaches sensibly. Concerns is one example of a “sharp knife” — some people think they encourage sweeping complexity under the rug, while others think that used appropriately, it’s not a problem and the benefits outweigh the risks.

And that’s exactly what the engines concept is: a sharp knife. For around 6 years, it was a little too sharp to be included in Rails’ silverware drawer, but it seems like perhaps now we can be trusted with it. And these days, lots of popular libraries are engines.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).118.png)

[Devise](https://github.com/plataformatec/devise), which is an extremely popular authentication library, is an engine. The [Spree e-commerce platform](https://github.com/spree/spree) is an engine, and you can get content management systems like [Refinery CMS](https://github.com/refinery/refinerycms), which is an engine too. Even the new [Active Storage](https://github.com/rails/rails/tree/master/activestorage) feature in Rails, is implemented as an engine inside.


## Welcome back to 2018

OK, that’s the end of our trip back to 2005, and we’re now back in the present. This is a good moment to take a stretch.

But before we start the third act, I wanted to mention one little thing that has nothing to do with Rails, or engines. Most of what I’ve talked about happened at least ten years ago, and when I was writing this talk, I wanted to make sure that I hadn’t inadvertently distorted how things played out in my memory.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).119.png)

All of the comments and posts I’ve used are real, but when I tried to find all these original newsgroup posts and articles and blogs so on that were written at the time, what I found was that almost all of sites I have referenced are either totally gone, or only partially available (e.g. all the discussion comments on the rubyonrails blog have disappeared, loud thinking is gone, even Ruby Forge is gone…)

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).120.png)

I think that history is interesting and important, and it’s kind of mind-boggling that without [archive.org](http://web.archive.org/web/20080118054508/http://merbivore.com:80/"), information that’s only ten years old might otherwise be basically gone forever. So if you can, [please support archive.org](https://archive.org/donate/). They accept donations at their website, and I genuinely believe they are providing one of the most valuable services on the web today.


## The History of Rails

OK, back to Rails. So at the start of this talk, I did say that I didn’t want this to be too self-indulgent, or to paint myself as some misunderstood genius or hero, finally proven right.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).121.png)

I am sure there are many other stories like this, in many other Open Source projects. But what I think is interesting about this journey is that it shows that the history of Rails can be viewed as __a history of opinions__.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).122.png)

Rails is “opinionated software”, which is great because it saves us a lot of time by allowing us to offload lots of decisions about building software, in exchange for accepting some implicit constraints. Following those constraints is what we sometimes call the “Rails Way”.

Some of those opinions are about how we use Ruby as a programming language — about how you should be able to express behaviour at the level of a line of code. An example of this are the methods that Rails adds to objects like String and Array.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).123.png)

Objects in a Rails application tend to have a lot of methods. Some people believe that it’s better to try to minimise the number of methods on an object, but it’s Rails’ opinion that the tradeoff is worth it, in order to be more expressive. Neither is wrong or evil. They are just two different opinions.

Other opinions are at a more architectural level, and are ultimately about how we ought to structure the applications we build when using Rails.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).124.png)

If you build your URLs and controllers in terms of REST and resources, you’ll be able to use a lot more of the abstractions and high-level mechanisms that Rails provides. But if you like to add lots of custom actions into your controllers, Rails can’t stop you, and it won’t stop you, but you’ll have to do a lot more work yourself to wire things up.

But that’s not the same as saying “if you don’t use resources, your code is bad” — it’s just the guiding opinion that Rails has.

What might not be obvious, though, is that over the 14 years of Rails’ life so far, those opinions haven’t always existed, and haven’t always stayed the same.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).125.png)

The REST verbs and resource-based architecture weren’t a part of Rails for almost two years. Inline Javascript was fine until 2011 when Rails switched to unobtrusive javascript. If you wanted to send an email when a user signed up, before Rails 4.0 you might’ve written an observer to reduce the coupling between creating a user record and dealing with emails, but they were removed, and in the modern Rails Way, you’d probably create a concern which mixed in callbacks to your User model.

I think a particularly interesting is example is Active Resource. 

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).126.png)

It used to be a part of the Rails framework, an evolution of the “actionwebservice” framework, which used to support SOAP, Dynamic WSDL generation, XML-RPC, and all the acronyms that David mentioned as “WS-deathstar” in [his keynote yesterday](https://youtu.be/zKyv-IGvgGE?t=48m39s).

ActiveResource let you save and load remote data using JSON over HTTP, using the same ruby methods as you’d use on a regular Active Record model. It made it easy build things like micro services and so, I think, acted as a signal that you could and should do that. It was removed in Rails 4.0, which might be one of the first indications of the current opinion that a Majestic Monolith is a more productive way to work overall.


## The only constant is change

The purpose of highlighting these changes of opinion is not to say that DHH, or anyone who is or was in Rails Core is frequently wrong; it’s to show that even in the world of opinionated software, _opinions can change_.

Fundamentally, what is and isn’t in Rails is driven by the needs of the people who write it, and to a greater or lesser extent, that means people building applications like Basecamp. But not everybody is building an application like that. I think more and more of us are working on Rails applications that have been around for a long time, in some cases ten years or more, and those kinds of applications have different needs and experience different pressures than one where the developer controls all the requirements and is free to rewrite it if they choose to, at almost any time.	

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).129.png)

According to builtwith.com [there are almost 1.1 million sites running on Rails at the moment](https://trends.builtwith.com/framework/Ruby-on-Rails), so it’s statistically extremely unlikely that Basecamp, as a piece of software or as a company, sits at the exact centre of all the different needs and pressures and tradeoffs those other applications and companies have.


## _We_ are the stewards of the future of Rails

Right now there are differing opinions in the community about what the future of Rails might include.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).131.png)

The majestic monolith vs. micro services; concerns and callbacks vs smaller object composition; system tests vs. unit testing & stubs... these tensions are good. We need people to be pushing at the boundaries of the Rails Way, to figure out what’s next.

If we just sit back and wait for a relatively small group of people to tell us what the future of Rails looks like, then it will only be a future that suits their particular, unavoidably-limited contexts.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).132.png)

In 2014, [37signals changed their name to Basecamp](http://37signals.com) and returned to maintaining a single application, so some of the motivation from within Rails Core for things like engines is naturally going to diminish. And that’s understandable: it’s an itch they may no longer have. But I wonder how many other software itches there are, which Basecamp doesn’t experience, but hundreds or thousands of other applications and developers do.

We need more voices sharing their experiences, good and bad, with the current Rails Way and we need people to build things like [Trailblazer](http://trailblazer.to), [ROM](http://rom-rb.org), and [Hanami](http://hanamirb.org), and [dry-rb](http://dry-rb.org), and then others to try using them and learning from them.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).133.png)

Probably none of these projects will ever usurp Rails, but they might contain ideas about how to build software, or how to structure web frameworks, which are new and useful. And like Merb, they might end up influencing the direction Rails takes towards something better for many of us. They might already have found some _[conceptual compression](https://youtu.be/zKyv-IGvgGE?t=17m26s)_, to use the phrase from David’s Keynote, that we can adopt or adapt. 	

And there’s no reason why the people doing that exploration can’t be you, because who else is going to do it? You are the Rails community. You work with Rails all the time. Who better than you to spot situations where a new technique or approach might help. Who better than you to try and distill that experience into beautiful, expressive code that captures a common need.

You can be [one of the crazy ones](https://en.wikipedia.org/wiki/Think_different "Here's the second of two references that explain the title of this talk. It was pretty cheesy to say it out loud, but otherwise I don't think the title would've made any sense at all!"). The misfits. The rebels. The troublemakers. The round pegs in square holes. The ones who see things differently.

As it says at the bottom of the “Rails Doctrine”:

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).134.png)

“We need disagreement. We need dialects. We need diversity of thought and people. It’s in this melting pot of ideas we’ll get the best commons for all to share. Lots of people chipping in their two cents, in code or considered argument.”

## Life in the Big Tent

OK, wonderful. Rails now embraces all manner of opinions under its [big tent](https://rubyonrails.org/doctrine/#big-tent). But what happens when you have your idea, but people don’t quite understand it immediately, and things get a little out of control and suddenly people are decrying it as evil?

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).137.png)

I feel for you, genuinely, because when I released engines, the main way people expressed these kinds of opinions was in the comment form of a blog. But we are now living in the age of the tweet, where many people don’t think twice about unleashing a salvo of 280 character hot takes out into the world. I’m not sure that we live in an age of “considered opinion” at the moment.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).139.png)

So what can we do? Well, two things.

### Be considerate

Firstly, as consumers of open source technology, I think we could all try our best to avoid sharing opinions like that. If you’ve had a bad experience with a technology or a technique, then that’s totally valid and you can and absolutely should share that experience. But don’t do it in a tweet, or if you MUST do it in a tweet, try to at least be balanced.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).141.png)

Even better, start a blog, or post on Medium, and write as much as you can about your experience and your context, and share a link to THAT on twitter.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).142.png)

### Be patient

Secondly, if you are lucky and generous enough to actually try to contribute a new idea to this, or any other community, try not to become demotivated if people don’t understand the point at first. This is that [first blog post about Rails on the 37signals blog](https://signalvnoise.com/archives/000606.php'), in early 2004. Look at the first comment.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).144.png)

What this shows is that the value of why you’re doing something differently, is often not immediately obvious to people. You will have to patiently explain it. Sometimes again and again, maybe for years and years. And you won’t be able to convince everyone, but you might reach _someone_ who finds it interesting or useful, who might then reach someone else, and before you know it, lots of people are getting value from your little idea, and it could end up making a big difference after all.

## The subjective value of ideas, and how to stay sane

There’s one last thing I’d like to say. When you make something, and it receives criticism, especially on the internet, from strangers, it can be very hard to deal with, sometimes so much so that we might stop creating things altogether, or never even try.

When I was a researching this talk, I stumbled across [an old blog post](http://web.archive.org/web/20061028151146/http://www.loudthinking.com/arc/000600.html), from 2006 — actually by DHH, would you believe it — that captured a good way of dealing with situations like this. I’m going to paraphrase it.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).146.png)

View your idea, or the thing you’ve made, as a pearl, not a diamond. When someone responds to your idea and points out all the flaws, the situations where it might not work for them, that’s OK, because what they’re asking for is a diamond. They want you to give them something _they consider flawless_. They want something _perfect_. But you need to try to remember that however that want is expressed, constructively or vitriolically, or wherever in between, that it’s not your job to make a diamond for them.

Instead, all you can offer them is the pearl you’ve made, and if that’s not good enough, then:

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).147.png "I thought hard about whether or not to include this in the presentation; in some ways it a cheap ending, but I liked being able to make a sly reference to DHH's own infamous 'Fuck You' slide as both a postfacto defiant response to his original thoughts on engines, and a gesture of agreement. Plus, it's a bit of fun and a cheap laugh! Hopefully you'll forgive me.")

Thank you.


:kind: blog
:created_at: 2018-04-15 22:00:00 +0000
:updated_at: 2018-04-15 22:00:00 +0000
:page_title: Here's to the crazy ones (RailsConf 2018)
:summary: A talk about Rails history and not giving up
