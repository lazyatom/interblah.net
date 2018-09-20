Getting started with Spacemacs
===========

![Spacemacs](/images/spacemacs/spacemacs.png)

Probably every 18 months or so, I seem to get an itch about my current editor, and look around for something different. Often it's because something is behaving slowly, or I can't get a feature to work. My over the last 15 years has been, roughly:

* [TextMate][textmate], because I saw it in the original Rails demo and loved how simple yet powerful it was, particularly the plugins. I have license #12 for TextMate. I used TextMate for a long time.
* [Sublime Text][sublime text], because I saw multiple cursors support. I wasn't thrilled to switch to Python-based plugins, but knew enough to figure most stuff out.
* [Atom][atom], because SublimeText had started to show weird slow-down that I couldn't resolve, even by wiping my configuration.
* Sublime Text again, because Atom started _really_ slowly, and the previous slowdown seemed to have resolved itself.
* [Vim][vim], because a bunch of other people had switched recently and I wanted to see what all the fuss was about. Prior to this I'd only tried Vim a few times and really hated modal editing, but this stint was around 6 months and finally did whatever brain reconfiguration was required to make modal editing make sense to me. Probably I just learned enough of the movement keys to finally feel able to step around files without feeling like I was pecking at the keyboard.
* Atom (again), because they'd focussed a lot on speed recently, and I felt overwhelmed by all the arcane commands and key combinations I needed to learn to use most of the Vim plugins, and because I found *exploring* projects in Vim to require a lot of energy for me. Sometimes I want to just be able to use a mouse to click around a project structure!
* [Spacemacs][spacemacs], because Atom was still relatively slow to launch, and I had hit an annoying edge case in the project search where searching within bundled gems didn't work smoothly.

I'm sure all of the issues I experienced were largely _my_ fault, rather than any problem with any of these editors, and I'm totally certain that any frustrations I experienced with any of them could be resolved with enough time and patience. However, when I'm sitting down to work on a project that already requires a lot of though, I don't want to have to give up a lot of that energy to my editor; I need to be able to get it to do what I would like, with a minimum of energy, headscratching, or waiting for a spinny icon to finish.

Here's what I really like about Spacemacs:

## Modal editing ##

Much as I was initially resistant to it, putting all that work into using Vim for half a year did finally sink in, and I can pretty happily jump around within a line, or up and down blocks of code, without having to think too hard about it. I don't know if I would entirely recant my rant, but the simple fact is that I've made the sacrifice and my brain has already been trained, so I might as well accept it. I don't think I'll ever be zealatous about the benefits of keeping your hands on the keyboard or anything like that, but I can say that once you _do_ get a handle on movement and text manipulation commands, it doesn't feel too bad. What I use all the time:

* `hjkl` for movement, although I will pretty happily use arrow keys to move around a little when I'm in insert mode
* `w` and `b` (and `<num>w` and so on) to skip around words at a time
* `f<char>` to skip to a specific character (and to a far lesser extent, `<num>f<char>`, but the time I spend visually counting occurrences almost always outweighs just doing `f<char>` a few times)
* `{` and `}` to jump up and down blocks of code. Basically, it moves to the next blank line, but if you've formatted your code nicely, more often than not this is the next function
* `cw` and `ct<char>` to change the current work, or change to the given character (e.g. given `some_variable_name`, with my cursor at the start I might type `ct_` to edit just the `some` part)
* `dw` and `dd` to delete words and lines
* `o` to add a new blank line below this one and enter insert mode
* `p` to paste whatever I've recently deleted somewhere else
* `A` to go to the end of the line and enter insert mode ("Append")
* `^` and `$` to skip around between the start and end of lines
* `gg` and `G` to move to the top and bottom of the file respectively
* `ve` and `v$` to select the word or line, ready to do something with it (maybe `y` to copy it...)
* Getting used to hitting escape as often as possible to leave insert mode[^spacemacs-cmd-s].

There's a bunch more that I do know and use, and I am _certain_ that I could be using different commands to do a lot of stuff more efficiently, but I think it was really internalising the commands above that got me through the transition from feeling massively slowed down to reasonably efficient at editing and moving text around.

All of these are Vi/Vim commands, but Spacemacs implements them using a package called "evil", which according to all the reckons on the internet that I've read, is hands down the most complete Vim emulation layer available. What this means is that any advice or tricks my Vim-using friends might have, I can also use too, and that's pretty neat.

### ... but only if you want it ###

Sometimes though, as a beginner, it's just faster to use the mouse, or the arrow keys. And Spacemacs totally supports that. If I'm in a bad mood and don't want to learn the modal way to do something, I can drag and select text, or jump the cursor around, and it just works. I can click on pretty much anything, from files and directories in the file tree, to links in a markdown document, and they do what you'd expect.

It's this graceful support for non-modal mechanisms that makes it easy to stick with a modal editor through the rough times and the smooth.


## Conventionality and discoverability via `which-key` ##

The biggest barrier to me sticking with Vim was feeling like "I know there's a way to do this better" but having to enter the depths of the Google mines to figure out how. Vim is super-extensible and customisable, but the flip-side of that is that everyone has their own setup and key-bindings and so until you are an expert, you end up with a cobbled together configuration of stuff you've found on the internet. As I said above, I'm _sure_ that eventually you would get a handle on this and be able to smooth any rough edges, but I think it's a significant barrier for people who are already trying to internalise a whole new way of editing.

With Spacemacs, the _main_ way you invoke commands is by hitting the spacebar. Press that nice big giant button and after about half a second, a menu appears with a whole bunch of options about what you might press next, with descriptions of what those are.

![The menu, invoked via the spacebar](/images/spacemacs/menu.png "Hit space to access the power!")

The commands are organised into sections, all based roughly on mnemonic groupings of what those functions do. So, if you want to do something with a file, chances are that it's somewhere under the `f` section. If you want to change the project you're working on, maybe try `p`. Want to search for something? Chances are it'll be under `s`. Now these mnemonics aren't perfect ("text" stuff is under `x` because `t` was used for "toggles"), but the descriptions are all _right there_, so the more you look at the menu, the more you internalise which section is which.

Once you get more comfortable, you often don't need to look at the menu at all, because the combinations become internalised. I don't need to look at the menu when I want to rename a file, because seeing the menu again and again has helped me learn that it's `SPC f R`. Checking the git status of the project is `SPC g s`. What Spacemacs and `which-key` do really well is support the learning process, and get you to a point where you can invoke all these commands quickly.

#### Discovering new functions and key bindings

![Exploring the functions in Spacemacs](/images/spacemacs/upper.gif)

But it gets even better than that, because you don't even need to dig around all the the menus until you find the command you were hoping for. If you have an inkling that there should be a more efficient way of, say, making some text uppercase without having to delete and re-type it, you can easily search _all of the commands_ in the editor by hitting `SPC SPC` and then making a few guesses about what the command name might be. I hit `SPC SPC` and type "upper", but none of those look right, so let's try "upcase", and bingo, a handful of functions that I might want to use. I can invoke one by hitting enter, but the menu also tells me what (if any) key conbination would run that function automatically, so if I end up doing this enough times, I'll probably start trying that combo, and eventually not need to look it up ever again. Every instance of this helps teach me. 

Showing the keybindings also shows me where in the menu I would've found that key, which over time also gives me clues about where to search for something the next time ("upcase region" is `SPC x U`, so perhaps there are other text case changing functions under `SPC x`...). It also shows me when there are even faster ways of invoking the function using the "evil" bindings, in this case `g U`. Perhaps I'll try that out, and if I try it enough times, it gets into my muscle memory, and I get faster.

### Layers and conventionality ###

Learning how the menus are organised also leads to what I mean by "convenionality". But before I explain this, I need to touch on how Spacemacs is organised. Rather than having you install lots of small Emacs packages (what you might consider plugins), Spacemacs gathers collections of related packages into what it calls "layers". Every Spacemacs layer comes with a set of key bindings, which the community as a whole has developed together, gathering all of the features and functions of the packages within that layer together. So when you install the ["ruby" layer][ruby-spacemacs-layer-docs], you get keybindings to run tests, to invoke bundler, to do simple refactorings, to use your preferred version manager, and so on, all ready for you to use and explorable via the menu and function search.

This is not to say that you can't change things -- you totally can! -- but you don't need to. There are similar distributions for other editors that enable similar "sensible" configurations, so this is not to say that Spacemacs is any better than, say, [Janus][janus] for vim. but for any of these powerful editors, having _something_ that provides this kind of support is really great.

## Magit ##

From what I can tell, a lot of the love for Emacs comes from people talking about how `org-mode` is amazing and can do anything and it's the greatest thing in the world, and that it's worth switching to Emacs just to be able to harness the awesome power of `org`[^borg]. That might be true. I have not used it. I might discover how to use it tomorrow and achieve a similar text-based nirvana.

As a programmer though, there's a different tool which has me _totally_ sold on Emacs, and that's [Magit][], a package for working with the Git version control system.

I used to be a command-line Git jockey. I'd use `git add .` and `git commit -m "Blah blah"`, and even run interactive rebasing and patch-based adding from the command line. I am pretty comfortable there.

[atom]: https://atom.io
[textmate]: https://macromates.com
[sublime text]: https://www.sublimetext.com
[spacemacs]: https://github.com/syl20bnr/spacemacs
[janus]: https://github.com/carlhuda/janus
[vim]: https://www.vim.org
[ruby-spacemacs-layer-docs]: http://spacemacs.org/layers/+lang/ruby/README.html "Documentation for the Ruby layer in Spacemacs"
[magit]: https://magit.vc "Magit, the git package for Emacs"

[^spacemacs-cmd-s]: With Spacemacs I actually have it set up so I can hit `cmd-s` to both save the file _and_ enter normal mode, though I recently also learned about `fd` and am trying to practice that.
[^borg]: Perhaps, you might say... joining the b`org`? *Groan*.

:kind: draft
:created_at: 2018-09-20 15:17:14 +0000
:updated_at: 2018-09-20 15:17:14 +0000
