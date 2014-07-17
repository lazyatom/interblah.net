Notes on 'Notes on "Counting Tree Nodes"'
=========================================

Having now finished watching [Tom's episode][] of [Peer to Peer][], I finally got around to reading his [Notes on "Counting Tree Nodes"][] supplementary blog post. There are a couple of ideas he presents that are so interesting that I wanted to highlight them again here.

If you *haven't* seen the video, then I'd still strongly encourage you to read the blog post. While I can now see the inspiration for wanting to discuss these ideas[^1], the post really does stand on it's own.

## Notes on 'Enumerators'

[Here's the relevant section of the blog post][enumerator-section]. Go read it now!

I'm not going to re-explain it here, so yes, really, go read it now.

What I found really interesting here was the idea of building new enumerators by re-combining existing enumerators. I'll use a different example, one that is perhaps a bit *too* simplistic (there are more concise ways of doing this in Ruby), but hopefully it will illustrate the point.

Let's imagine you have an `Enumerator` which enumerates the numbers from 1 up to 10:

    > numbers = 1.upto(10).to_enum
    => #<Enumerator: 1:upto(10)>
    > numbers.next
    => 1
    > numbers.next
    => 2
    > numbers.next
    => 3
    ...
    > numbers.next
    => 9
    > numbers.next
    => 10
    > numbers.next
    StopIteration: iteration reached an end

You can now use that to do all sorts of enumerable things like mapping, selecting, injecting and so on. But you can also build *new* enumerables using it. Say, for example, we now only want to iterate over the odd numbers between 1 and 10.

We can build a *new* Enumerator that re-uses our existing one:

    > odd_numbers = Enumerator.new do |yielder|
        numbers.each do |number|
          yielder.yield number if number.odd?
        end
      end
    => #<Enumerator: #<Enumerator::Generator:0x007fc0b38de6b0>:each>

Let's see it in action:

    > odd_numbers.next
    => 1
    > odd_numbers.next
    => 3
    > odd_numbers.next
    => 5
    > odd_numbers.next
    => 7
    > odd_numbers.next
    => 9
    > odd_numbers.next
    StopIteration: iteration reached an end

So, that's quite neat (albeit somewhat convoluted compared to `1.upto(10).select(&:odd)`, with or without `to_enum` on the end). To extend this further, let's imagine that I _hate_ the lucky number 7, so I also don't want that be included. In fact, somewhat perversely, I want to stick it right in the face of superstition by replacing 7 with the unluckiest number, 13.

Yes, I know this is weird, but bear with me. If you have read Tom's post (go read it), you'll already know that this can also be achieved with a new enumerator:

    > odd_numbers_that_arent_lucky = Enumerator.new do |yielder|
        odd_numbers.each do |odd_number|
          if number == 7
            yielder.yield 13
          else
            yielder.yield number
          end
        end
      end
    => #<Enumerator: #<Enumerator::Generator:0x007fc0b38de6b0>:each>
    > odd_numbers.next
    => 1
    > odd_numbers.next
    => 3
    > odd_numbers.next
    => 5
    > odd_numbers.next
    => 13
    > odd_numbers.next
    => 9
    > odd_numbers.next
    StopIteration: iteration reached an end

In [Tom's post][enumerator-section] he shows how this works, and how you can further compose enumerators to to produce new enumerations with specific elements inserted at specific points, or elements removed, or even transformed, and so on.

So.

## A hidden history of enumerable transformations

What I find really interesting here is that somewhere in our `odd_numbers` enumerator, all the numbers still exist. We haven't actually thrown anything away permanently; the numbers we don't want just don't appear while we are enumerating.

The enumerator `odd_numbers_that_arent_lucky` still contains (in a sense) all of the numbers between 1 and 10, and so in the tree composition example in Tom's post, all the trees he creates with new nodes, or with nodes removed, still contain (in a sense) all those nodes.

It's almost as if the history of the tree's structure is encoded within the nesting of `Enumerator` instances, or as if those blocks passed to `Enumerator.new` act as a runnable description of the transformations to get from the original tree to the tree we have now, invoked each time any new tree's children are enumerated over.

I think that's pretty interesting.


# Notes on 'Catamorphisms'

In [the section on Catamorphisms][catamorphism-section] (go read it now!), Tom goes on to show that recognising similarities in some methods points at a further abstraction that can be made -- the *fold* -- which opens up new possibilities when working with different kinds of structures.

What's interesting to me here isn't anything about the code, but about the ability to recognise patterns and then exploit them. I am very jealous of Tom, because he's not only very good at doing this, but also very good at explaining the ideas to others.

## Academic vs pragmatic programming

This touches on the tension between the 'academic' and 'pragmatic' nature of working with software. This is something that comes up time and time again in our little sphere:

* [Programming is not Math](http://www.sarahmei.com/blog/2014/07/15/programming-is-not-math/)
* [Let's not call it Computer Science](http://codemanship.co.uk/parlezuml/blog/?postid=1109)
* [Tech programmers don't need college diplomas](http://magazine.good.is/articles/turn-on-code-in-drop-out)

Now I'm not going to argue that anyone working in software development *should* have a degree in Computer Science. I'm pretty sympathetic with the idea that many "Computer Science" degrees don't actually bear much of _direct_ resemblance to the kinds of work that most software developers do[^2].

## Ways to think

What I think university study provides, more than anything else, is exposure and training in _ways to think_ that aren't obvious or immediately accessible via our direct experience of the world. Many areas of study provide this, including those outside of what you might consider "science". Learning a language can be learning a new way to think. Learning to interpret art, or poems, or history is learning a new way to think too.

Learning and internalising those _ways to think_ give perspectives on problems that can yield insights and new approaches, and I propose that that, more than any other thing, is the hallmark of a good software developer.

Going back to the blog post which, as far I know, sparked the tweet storm about "programming and maths", I'd like to highlight this section:

> At most academic CS schools, the explicit intent is that students learn programming as a byproduct of learning CS. Programming itself is seen as rather pedestrian, a sort of exercise left to the reader.
>
> For actual developer jobs, by contrast, the two main skills you need these days are programming and communication. So while CS still does have strong ties to math, the ties between CS and programming are more tenuous. You might be able to say that math skills are required for computer science success, but you can’t necessarily say that they’re required for developer success.

What a good computer science (or maths or any other logic-focussed) education should teach you are _ways to think_ that are specific to computation, algorithms and data manipulation, which then

* provide the perspective to recognise patterns in problems and programs that are _not_ obvious, or even easily intuited, and might otherwise be missed.
* provide experience applying techniques to formulate solutions to those problems, and refactorings of those programs.

Plus, it's _fun_ to achieve that kind of insight into a problem. It's the "a-ha!" moment that flips confusion and doubt into satisfaction and certainty. And these insights are also [interesting in and of themselves][computation-book], in the very same way that, say, study of art history or Shakespeare can be.

So, to be crystal clear, I'm not saying that you *need* this perspective to be a great programmer. I'm really not. You can build great software that both delights users and works elegantly underneath without any formal training. That is definitely true.

Back to that quote:

> the ties between CS and programming are more tenuous ... you can’t necessarily say that they’re required for developer success.

All I'm saying is this: __the insights and perspectives gained by studying computer science are both useful and interesting__. They can help you recognise existing, well-understood problems, and apply robust, well-understood and powerful solutions.

That's the relevance of computer science to the work we do every day, and it would be a shame to forget that.

[Tom's episode]: http://peertopeer.io/videos/1-tom-stuart
[Notes on "Counting Tree Nodes"]: http://codon.com/notes-on-counting-tree-nodes
[Peer to Peer]: http://peertopeer.io
[enumerator-section]: http://codon.com/notes-on-counting-tree-nodes#enumerators
[catamorphism-section]: http://codon.com/notes-on-counting-tree-nodes#catamorphisms
[computation-book]: http://computationbook.com


[^1]: In the last 15 minutes or so of the video, the approach Tom uses to add a "child node" to a tree is interesting but there's not a huge amount of time to explore some of the subtle benefits of that approach
[^2]: Which is, and let's be honest, a lot of "Get a record out of a database with an ORM, turn it into some strings, save it back into the database".

:kind: draft
:created_at: 2014-07-17 11:11:27 -0500
:updated_at: 2014-07-17 11:11:27 -0500

