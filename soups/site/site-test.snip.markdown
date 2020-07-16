Site Test
===

This page exercises all the major types of markup and dynasnips that should work. The main purpose is to act as a single page which contains almost all possible selectors, so that the CSS can be effectively minimised, but it also serves as a decent visual debug of the behaviour of {l vanilla-rb}.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->

## Table of Contents

- [Site Test](#site-test)
    - [Typography](#typography)
        - [Images](#images)
        - [Lists](#lists)
        - [Headings](#headings)
- [Header 1](#header-1)
    - [Header 2](#header-2)
        - [Header 3](#header-3)
            - [Header 4](#header-4)
                - [Header 5](#header-5)
                    - [Header 6](#header-6)
    - [Code](#code)
- [Footnotes](#footnotes)

<!-- markdown-toc end -->

## Typography

This is a simple paragaph. Its contents are uninteresting; boring perhaps, but that's fine & dandy really. Thanks to [Kramdown][], lots of normal markup should work, like _emphasis_ and __bolding__, and "smart quotes" around 'words', that sort of thing. 

> this is a quote

### Images

Images are rendered as block elements, but should have titles too.

![](/images/crazy-ones/Here's to the crazy ones (RailsConf 2018).005.png "Fun fact: actually this picture is from 2001, but I hadn't changed that much, and it supported my point better than other pictures I could find.")

All good so far.

### Lists

* what
* do you
    * think
    * when you think
        * or indeed, dream
        * or muse
* about
* this list?

Or indeed,

1. a numbered
2. list of
    1. salient, and
    2. fascinating
3. things

Great, that all looks wonderful.

### Headings

There are six heading levels, naturally

# Header 1

## Header 2

### Header 3

#### Header 4

##### Header 5

###### Header 6


## Code

First of all, here's some ruby code[^1] via markdown:

    class Hello
      WORLD = /every(.*)/i
      
      def world(name, surname = 'you')
        data = { full_name: [name, surname].join("\n") }
        100.times do |x|
          puts "Hello, #{data[:full_name]}"
        end
      end
    end

Here's some rendered via the `code` dyna:

{code ruby_sample, ruby}

Here's that same sample, but with the syntax auto-detected:

{code ruby_sample}

Here's some kramdown-specific code syntax, which I only just learned about[^kramdown-code]:

~~~ ruby
class Hello
  WORLD = /every(.*)/i

  def world(name, surname = 'you')
    data = { full_name: [name, surname].join("\n") }
    100.times do |x|
      puts "Hello, #{data[:full_name]}"
    end
  end
end
~~~

And another type of code block:

    def why?
      return 42
    end
{:.ruby}

... except it doesn't get any of the server-side HTML enhancements, so there's no syntax highlighting unless it's done via Javascript. 

OK! That's the end of the content test.

[^1]: This is a footnote
[^kramdown-code]: Turns out there's a bunch of handy extensions in Kramdown that I haven't been using, but could've.

[Kramdown]: https://kramdown.gettalong.org/syntax.html

---
:title: Site Test
:ruby_sample: |-
  class Hello
    WORLD = /every(.*)/i

    def world(name, surname = 'you')
      data = { full_name: [name, surname].join("\n") }
      100.times do |x|
        puts "Hello, #{data[:full_name]}"
      end
    end
  end
