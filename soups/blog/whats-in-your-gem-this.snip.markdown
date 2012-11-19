What's in your `~/.gem-this`?
=============================

As of the version I just deployed (0.3.5), [gem-this][] now lets you include any common rake tasks you might reuse in any `Rakefile`s it generates. Just drop your code in `~/.gem-this`. Here's mine, based on some code we use in [Free Range][]:

{code ruby,mygemthis}

One of my pain points with other tools like [Jeweler][], [hoe][] and so on is that they worked so very hard at defining a workflow for development. They are ["too opinionated" for my taste][ruby-manor-talk]. The [gem-this][] ethos is that you should craft your own, and now it's that little bit easier.

[gem-this]: http://github.com/lazyatom/gem-this
[Free Range]: http://gofreerange.com
[Jeweler]: http://rubygems.org/gems/jeweler
[hoe]: http://rubygems.org/gems/hoe
[ruby-manor-talk]: http://rubymanor.org/harder/videos/gem_that/

:created_at: 2011-02-18 21:11:47 +00:00
:updated_at: 2011-02-18 21:11:47 +00:00
:kind: blog
:mygemthis: |
  desc 'Tag the repository in git with gem version number'
  task :tag => [:gemspec, :package] do
    if `git diff --cached`.empty?
      if `git tag`.split("\n").include?("v#{spec.version}")
        raise "Version #{spec.version} has already been released"
      end
      `git add #{File.expand_path("../#{spec.name}.gemspec", __FILE__)}`
      `git commit -m "Released version #{spec.version}"`
      `git tag v#{spec.version}`
      `git push --tags`
      `git push`
    else
      raise "Unstaged changes still waiting to be committed"
    end
  end

  desc "Tag and publish the gem to rubygems.org"
  task :publish => :tag do
    `gem push pkg/#{spec.name}-#{spec.version}.gem`
  end
