Docker on your Server
=====================

_TL;DR: Register at [http://www.dockeronyourserver.com](http://www.dockeronyourserver.com) if you're interested in an e-book about using Docker to deploy small apps on your existing VPS._

I've been toying around with [Docker](http://docker.com) for a while now, and I really like it.

The reason why I became interested, at first, was because I wanted to move the [Printer](http://printer.exciting.io) server and processes to a different VPS which was already running some other software (including this blog), but I was a bit nervous about installing all of the dependencies.

## Dependency anxiety

What if something needed an upgraded version of LibXML, but upgrading for one application ended up breaking a different one? What if I got myself in a tangle with the different versions of Ruby that different applications expect?

If you're anything like me, servers tend to be supremely magical things; I know enough of the right incantations to generally make the right things appear in the right places at the right time, but it's so easy to utter the wrong spell and completely mess things up[^1].


## Docker isolation

Docker provides an elegant solution for these kinds of worries, because it allows you to *isolate* applications from each other, including as many of their dependencies as you like. Creating images with different versions of LibXML, or Ruby, or even PostgreSQL is almost trivially easy, and you can be confident that running any combination will not cause unexpected crashes and hard-to-trace software version issues.

However, while Docker is simple in principle, it's not trivial to **actually deploy with it**, in the pragmatic sense.


## Orchestration woes

What I mean is getting to a point where deploying a new application to your server is as simple (or close enough to it) as platforms like Heroku make it.

Now, to be clear, I don't specifically mean using `git push` to deploy; what I mean is all the *orchestration* that needs to happen in order to move the right software image into the right place, stop existing containers, start updated containers and make sure that nothing explodes as you do that.

But, you might say, there are packages that already help with this! And you're right. Here are a few:

* [Dokku](https://github.com/progrium/dokku), the originally minimal Heroku clone for Docker
* [Flynn](http://flynn.io), the successor to Dokku
* [Orchard](http://orchardup.com), a managed host for your Docker containers
* ...and many more. I don't know if you've heard, but Docker is, like, _everywhere_ right now.

So why not use one of those?

## That's a good question

Well, a couple of reasons. I think Orchard looks great, but I like using my own servers for software when I can. That's just my personal preference, but there it stands, so tools like Orchard (or Octohost and so on) are not going to help me at the moment.

Dokku is good, but I'd like to have a little more control of how applications are deployed (as I said above, I don't really care about `git push` to deploy, and even in Heroku it can lead to odd issues, particularly with migrations).

Flynn isn't really *for* me, or at least I don't think it is. It's for dev-ops running apps on multiple machines, balancing loads and migrating datacenters; I'm running some fun little apps on my personal VPS. I'm not interested in using Docker to deploy across multiple, dynamically scaling nodes; I just want to take advantage of Docker's isolation _on my own, existing, all-by-its-lonesome VPS_.

But, really more than anything, I wanted to *understand* what was happening when I deploy a new application, and be *confident* that it worked, so that I can more easily use (and debug if required) this new moving piece in my software stack.

## So I've done some exploring

I took a bit of time out from building [Harmonia](https://harmonia.io) to play around more with Docker, and I'd like to write about what I've found out, partly to help me make it concrete, and partly because I'm hoping that there are other people out there like me, who want some of the benefits that Docker can bring without necessarily having to learn so much about using it to it's full potential in an 'enterprise' setting, and without having to abandon running their own VPS.

**There ought to be a simple, easy path to getting up and running productively with Docker while still understanding everything that's going on. I'd like to find and document it, for everyone's benefit.**

[![](/images/dockerbook.png)](http://www.dockeronyourserver.com)

If that sounds like the kind of think you're interested in, and would like reading about, **please let me know**. If I know there are enough people interested in the idea, then I'll get to work.

Sign up here: [http://www.dockeronyourserver.com](http://www.dockeronyourserver.com)



[^1]: You might consider [this](http://youtu.be/mHTnJNGvQcA?t=7m40s) to be an early example of what I mean.


:kind: blog
:created_at: 2014-07-01 16:22:19 -0500
:updated_at: 2014-07-01 16:22:19 -0500
