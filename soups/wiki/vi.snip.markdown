vi
===

The `vi` editor is a mode-based editor present on must UNIX-like systems, including Linux and Mac OS X.


Me and `vi` editor
----

Lots of people like me, who spend much of their time programming computers, are getting into using an editor called `vi` to write their software.

This is what `vi` looks like:

![The joy of vi](/images/vi.png "vi")

Some people really love using this tool. The tell me that it is "faster", and "more efficient", and that I should stop trying to use the mouse when I'm editing text. "Look!", they will say as they deftly enter an incantation along the lines of `:Sxf! boo`[^notreal] and quicker than the eye can see, some block of text has moved, re-indented itself and now lives happily somewhere else in the source code.

There are times when I'm swayed, and I try to use `vi` exclusively so that I can learn be *just productive enough*  that I might then be able to to use it regularly and so glimpse the "speed" and "efficiency" it affords. But it's a struggle, and every time thus far I've become frustrated far too quickly for the realisation of any dividends on the investment of forcing myself to use `h`, `j`, `k` and `l`.

"Screw this", I think, and I start getting stuff done in [Textmate][] -- or indeed, any text editor into which I can *just type*.[^vi-troll]

I always had an intuition that behind my resistance to `vi` there was a deeper, more subtle reason than mere impatience, but until I watched Bret's talk I hadn't really been able to articulate it. I think I now have a fingertip purchase on it, and I'm going to try to tease it towards consciousness.


### Thinking like a computer

In case you didn't watch the talk (or at least didn't get to the relevant part at around 17min), Bret talks a bit about the need to get instant feedback when "creating" something. To give a pithy example, a painter sees the cumulative effect of each brushstroke as it plays out on the canvas; they don't have a list of strokes prepared which are then rapidly and sequentially actioned to -- hopefully -- produce the right image at the end.

In programmer land, [waiting for feedback][compiling] is the norm. Even with [dynamic languages][ruby], it's not until the code is "run" that we get any confirmation that it does what we hope (or even just what we expect) it will do.

In {l inventing-on-principle}, {l bret-victor} talks about how programmers go about understanding code -- for example, a simple binary search:

{code ruby, binarysearch}

> Binary search looks like this&hellip; and from my perspective you can't see anything here. I see the word 'array', but I don't **actually see** an array. And so, in order to write code like this, you have to **imagine** an array in your head.
>
> You essentially have to **play computer** -- you have to simulate in your head what each line of code would do on a computer.
>
> And to a large extent the people that we consider to be skilled software engineers are just those people that are really good at playing computer.

This resonates completely with my experience. If I have any skill as a software developer, I think it's because I have some aptitude at forming a mental model of a complex system in my head, and "simulating" it in various kinds of circumstance to explore what might be wrong, or how any particular change might best be incorporated.[^crystal]

But anyway, keep that last sentence from the quote in your mind:

> And to a large extent the people that we consider to be skilled software engineers are just those people that are really good at playing computer.

### Modes

The `vi` editor has *modes*, which you must switch between to add text ("insert" mode) or move it around efficiently ("command" mode)[^tesler].

This is what often trips up those new to `vi`, as they struggle to understand why the keys they are pressing have not appeared on the screen, but it is also the reason why some software developers love `vi` so much.

In "command" mode, they can compose short commands which operate on the text. The command `d5d` will remove five lines from a file and place it in some part of `vi`'s memory where it can be pasted elsewhere. `5G` will move the cursor to the fifth line of text. `2dw` will delete the character immediately under the cursor, the remaining characters to the right of it in same word and all of the next word.

There's a clear and definite logic behind the structure of these commands, and successful `vi` usage basically hinges one being able to internalise these commands and the logic of their composition, and then to *think in terms of them* when you want to make changes to a file. Each of these commands is basically a little computer program that `vi` plays out over the file in its current state, before presenting you with the file's state at the end.

So there it is: being efficient with `vi` is predicated on being able to *play computer* as part of the process of editing text.

The personal insight is that deep down, I don't really want to be simulating a computer all the time. That's the computer's job.

I'm trying to create a system. That's my goal. The mental model of my system is one level removed from my goal. The contents of the text files which codify that system is another level removed; they represent an abstraction that I can translate to and from my mental model since, y'know, I've been progg'ing for a long time.

What `vi` is asking me to do is think about the raw contents of those files as yet another thing to be modelled (*twelve words forward, insert marker, extend selection 5 lines, yank*) in my mind.


[^notreal]: This is not a real command, and the fact that I cannot summon a real `vi` power-user command off the top of my head should demonstrate that my attempts to really _learn_ `vi` haven't paid off at all.
[^vi-troll]: I want to be really clear that I'm not suggesting that those people who love `vi` are in any way wrong -- just that I personally struggle with it.
[^crystal]: On occasion I have gone so far as to say that we are building the "[crystal cities of the future][crystal cities]", in a quite uncharacteristic fit of hyperbole.
[^tesler]: Later in the talk Bret mentions [Larry Tesler][], who in the 1970s, amongst other things, went on a quest against "modeless software" because he feared that the confusion which software modes can produce would threaten the adoption (and therefore the potential) of the personal computer.

[compiling]: http://xkcd.com
[ruby]: http://www.ruby-lang.org
[TextMate]: http://www.macromates.com
[crystal cities]: https://github.com/freerange/site/blob/master/soups/dynasnips/tagline.rb#L12
[Larry Tesler]: http://www.nomodes.com

:created_at: 2012-03-01 21:06:45 +00:00
:updated_at: 2013-01-04 09:53:06 -0600
:binarysearch: |
  def binarySearch(key, array)
    low = 0
    high = array.length - 1

    while low <= high do
      mid = (low + high) / 2
      value = array[mid]

      if value < key
        low = mid + 1
      elsif value > key
        high = mid - 1
      else
        return mid
      end
    end

    return nil
  end"
