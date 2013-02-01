Rerunning tests in Ruby
=========

## A WORK IN STAGNANT PROGRESS

A bit more context regarding my motivation for {l kintama}: I'd always felt it was more difficult than it should be to run individually tests with [test-unit][]. The syntax is something like

    $ ruby my_test.rb -n "test_name_of_my_test"

which is simple enough, but once you get [Rails][] and [shoulda][] involved, that balloons to something more like

    $ ruby -Itest test/functional/some_controller_test.rb -n "test: Given some condition and another condition should do something specific. "

Far more of a handful, right? The method name has to start with "test" so that [test-unit][] will actually run it, but look at how long it is[^shoulda-method-length]! Can you imagine typing all that? And don't forget that space - don't you dare.[^shoulda-space].

Now, your editor might be able to help run this, but then you've placed yourselves in the fickle hands of [whoever is maintaining that support][shoulda-tmbundle], and whatever their whims might be. I already had to fork a bundle to fix some bugs, and perhaps something in my environment meant that I was the only person experiencing that, but still, it's a pain, and this is where I spend literally half of my time when working - running and *re*running tests. It should be simple! It should be painless![^whinge-reminder]


Editors shouldn't care how test frameworks work
---------

I know that [RSpec][] and other test frameworks let you target specific tests by indicating their line number. That seems like a much better way of managing the boundary between editor and tests, rather than the editor trying to figure out what the actual name of the test should be.


Interactive running and debugging of tests
----------

But I wondered if it was possible to go even further, and actually have a 'live' system where tests could be poked and prodded, run and re-run, and failures inspected interactively. How many times have you run a test, had it fail, then had to run it again peppered with debugging to look at the state in order to fix it?

Wouldn't it be great to be able to just dive back in to the environment of any failed test and start poking around? See what the instance variables were? Call some methods?


Inspecting the environment in MiniTest
-----

I've done a small amount of exploratory work towards doing this in MiniTest, which you can read about in {l how-minitest-works}.

Next steps
----------

Actually explore this to see if there's any merit.


[^shoulda-method-length]: It occurs to me in retrospect that the method name length is a direct consequence of nesting contexts. I don't know if this is a sign that lots of nesting is a bad idea, or if that might simply be independently true.

[^shoulda-space]: The space at the end there is significant. Shoulda adds it to the end of every test. WHY!!!

[^whinge-reminder]: Let me take this opportunity to again remind you that this isn't a statement of objective fact; I'm just explaining my state of mind before I started work on kintama. It's also worth noting that at this point I hadn't heard of [tconsole][], which does go some way to making it easier to run tests in an interactive way.

[tconsole]: https://github.com/commondream/tconsole
[shoulda-tmbundle]: https://github.com/drnic/ruby-shoulda-tmbundle
[Rails]: http://rubyonrails.org
[test-unit]: http://ruby-doc.org/stdlib/libdoc/test/unit/rdoc/
[rspec]: http://rspec.info
[shoulda]: https://github.com/thoughtbot/shoulda

:created_at: 2013-01-04 09:53:06 -0600
:updated_at: 2013-01-04 09:53:06 -0600
