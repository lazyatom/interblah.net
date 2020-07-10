Back on the wagon
=================

Hey, it's been a while. Sorry about that.

For the past few months I've increasingly felt the tug to express thoughts and such, but while most of the world now does that on Twitter, as with Facebook I don't feel like I can participate on there without condoning some of the awful aspects of social media.

So I'm resurrecting this site, in the hopes that I can write  a bit more here to scratch that itch.

Obviously there was no way I could possibly resume writing here without a total overhaul of the design and backend. And then having spent days on it, learning [Tachyons][] in the process, I flicked back to the previous design and, y'know what, it actually wasn't that bad. But anyway, we're here now.

Speaking of Tachyons, I did read an interesting article about [CSS utility classes and "separation of concerns"](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/) that has finally helped me understand the motivations that have driven front-end developers away from "semantic" CSS. As primarily a backend developer, I struggle to shake the dream of writing simple markup for a "thing" and then having different CSS render it appropriately in whatever contexts it might appear, but this helped me understand the journey. I want to re-read that article, because I have a hunch that the destination it describes isn't actually that far away from the "semantic" one I hope for, just that the CSS might end up being dynamically composed from utility classes by a pre-processor. Maybe.

Some random thoughts I've had on return to this site and the codebase behind it:

* At the start of this resurrection process, I wondered why I ever bothered writing my own software to run it, but as I got stuck in, once again I enjoyed the simpicity and flexibility that {l vanilla} affords. Building little components like the sidebar on the front page is easy.
* During the redesign, I wanted to avoid as much hand-written CSS as possible; I just want something that automatically provides a consistent and clean typographic layout with decent line heights and readability. I'm not sure I would call what I've achieved "beautiful", but it's not awful.
* There is a _lot_ of outdated content here. The pages about how this site runs are way out of date (it's now in a Docker container under {l dokku} on a VPS, and has been for years). I have now switched to {l doom-emacs}, which is similar to {l spacemacs}. Beyond that, the last real writing is six years old, or more, and I don't entirely recognise many of those opinions as mine anymore. :shrug:!
* _Note to self: figure out some way of getting emojis to render like GitHub and Slack._
* A bunch of snips refer to commenting, which I turned off a long time ago. I should really remove references to that, and potentially embrace _webmentions_ like [James](https://jamesmead.org/blog/2020-06-27-indieweb-ifying-my-personal-website) did recently. Or I could allow commenting via Twitter? Or even from/to Mastodon via ActivityPub?

Anyway, I'm back. Or am I? I think I am. I hope I am.

I'm back.


[Tachyons]: http://tachyons.io



:kind: blog
:created_at: 2020-07-10 11:38:08 +0100
:updated_at: 2020-07-10 11:38:08 +0100
:summary: Hey, it's been a while
