Day One
-------

My god, this thing is portable. It's a lovely size, somehow managing to be ridiculously compact without ever seeming *too* small. The main rows of keys on the keyboard are the same size as any other laptop keyboard, but what sometimes throws my hands off are the fact that the edges of the machine are that much closer; my palms need to adjust to sitting a bit closer to the keyboard.

The screen resolution is also surprisingly forgiving. I have used a [Dell Mini 9][] in anger, [hackintoshed][], and eventually found it's relatively-low resolution (800x600) a pain. The 11" has a resolution of 1366x768, which is perfectly serviceable. I can bump up the font size in both Terminal.app (Menlo, 18pt) and TextMate (Menlo, 14pt) without sacrificing any context.

Getting the machine set up for development wasn't too hard; I already store quite a bit of stuff on [Dropbox][], including working copies of most of my projects. I bootstrapped its sync by copying my Dropbox folder via a USB stick, along with some other documents, after which it did a bit of indexing and was happy to be left to establish quiet dominion over its folder and contents.

Here's a rough outline of what it took to get the machine development-ready:

1. Download [homebrew][]
2. Download [XCode][] - this takes literally ages now that Apple have decided that everyone who wants XCode should also get the iOS development libraries. I can remember when XCode was around 500MB; now it's 2.5GB
3. Once XCode is ready, use homebrew to install a bunch of core development software:
  1. git
  2. MySQL
  3. MongoDB
  4. ack
  5. redis
4. Once git is installed you can let the other stuff install in the background while you install [RVM][], and then
  1. Ruby Enterprise Edition 1.8.7
  2. Ruby 1.9.2
5. Install a few key ruby libraries
  1. bundler
  2. passenger
6. Once all of the above have finished, for each application do something along the lines of:
  1. `bundle install`
  2. `rake db:reset`
  3. `rake`

Working in Terminal.app and TextMate doesn't seem to be hindered by the lower processor speed at all; the editor is snappy, and running tests is just as fast as my old machine. Some tests naturally run slower (as we'll see later), but I certainly never feel like I'm waiting for the machine to catch up. Perhaps this is the joy of SSD that people keep talking about.

After the first few hours of setup, I remain utterly charmed by how capable the MacBook Air is despite its diminutive form factor.

[Dell Mini 9]: http://www.mydellmini.com/
[hackintoshed]: http://www.mydellmini.com/forum/mac-os-x/
[Dropbox]: http://db.tt/zi8greV
[homebrew]: https://github.com/mxcl/homebrew
[XCode]: http://developer.apple.com/tools/xcode/

:kind: macbookair-review
:updated_at: 2011-05-03 16:02:22 +0100
