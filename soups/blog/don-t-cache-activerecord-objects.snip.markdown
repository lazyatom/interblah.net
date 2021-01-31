Don't cache ActiveRecord objects
================================


Hello, new Rails developer! Welcome to **WidgetCorp**. I hope you enjoyed orientation. Those old corporate videos are a hoot, right? Still, you gotta sit through it, we all did. But anyway, let's get stuck in.

So as you know, here at WidgetCorp, we are the manufacturer, distributor and direct seller of the worlds highest quality **Widgets**. None finer!

These widgets are high-value items, it's a great market to be in, but they're also pretty complicated, and need to be assembled from any number of different combinations of _doo-hickeys_, _thingamabobs_ and _whatsits_, and unless we have the right quantities and types of each, then a particular kind of widget may not actually be available for sale.

(If you just came for the advice, you can [skip this nonsense](#whats-going-on).)

But those are manufacturing details, and you're a Rails developer, so all it really means for us is this: **figuring out the set of _available_ widgets involves some necessarily-slow querying and calculations, and there's no way around it**.

In our typical Rails app, here's the code we have relating to showing availble widgets:

~~~ ruby
# db/schema.rb
create_table :widgets do |t|
  t.string :title
  # ...
end

# app/models/widget.rb
class Widget < ActiveRecord::Base
  scope :available, -> { 
    # some logic that takes a while to run
  }
end

# app/helpers/widget_helper.rb
module WidgetHelper
  def available_widgets
    Widget.available
  end
end
~~~
~~~ html
<!-- app/views/widgets/index.html.erb -->
<% available_widgets.each do |widget| %>
  <h2><%= widget.name %></h2>
  <%= link_to 'Buy this widget', widget_purchase_path(widget) %>
<% end %>
~~~

### It's so slow!

The complication of these widgets isn't our customer's concern, and we don't want them to have to wait for even a second before showing them the set of available widgets that might satisfy their widget-buying needs. But the great news is that the widget component factory only runs at midnight, and does all its work instantaneously[^fast], so this set is the same for the whole day.

So what can we do to avoid having to calculate this set of available widgets every time we want to show the listing to the user, or indeed use that set of widgets anywhere else in the app?

You guessed it, you clever Rails developer: **we can cache the set of widgets**!

For the purposes of this example, let's add the caching in the helper:[^view-caching]

~~~ ruby
module WidgetHelper
  def available_widgets
    Rails.cache.fetch("available-widgets", expires_at: Date.tomorrow.beginning_of_day) do
      Widget.available
    end
  end
end
~~~

Bazinga! Our website is now faster than a _ZipWidget_, which -- believe me -- is one of the fastest widgets that we here at WidgetCorp sell, and that's saying something.

Anyway, great work, and I'll see you tomorrow.

### The next day

Welcome back! I hope you enjoyed first night in the company dorm! Sure, it's cosy, but we find that the reduced commute times helps us maximise employee efficiency, and just like they said in those videos, say it with me: "An efficient employee is... a..."

... more impactful component in the overall WidgetCorp P&L, that's right. But listen to me, wasting precious developer seconds. Let's get to work.

So corporate have said they want to store the _colour_ of the widget, because it turns out that some of our customers want to coordinate their widgets, uh, aesthetically I suppose. Anyway, I don't ask questions, but it seems pretty simple, so let's add ourselves the column to the database and show it on the widget listing:

~~~ ruby
# db/schema.rb
create_table :widgets do |t|
  t.string :title
  t.string :colour
  # ...
end
~~~

~~~ html
<!-- app/views/widgets/index.html.erb -->
<% available_widgets.each do |widget| %>
  <h2><%= widget.title %></h2>
  <p>This is a <%= widget.colour %> widget</p>
  <!-- ...  -->
<% end %>
~~~

... aaaaaaaand _deploy_. 

Great! You are a credit to the compa **WHOA** hangon. The site is down. **THE SITE IS DOWN**.

Exceptions. Exceptions are pouring in.

"Undefined method `colour`"? What? We ran the migrations right? I'm sure we did. I saw it happen. Look here, I'm running it in the console, the attribute is there. What's going on? Oh no, the red phone is ringing. You answer it. No, I'm telling you, _you_ answer it.

## What's going on

The reason we see exceptions after the deployment above is that the ActiveRecord objects in our cache are fully-marshalled ruby objects, and due to the way ActiveRecord dynamically defines attribute access, those objects only know about the columns and attributes of the `Widget` class _at the time they entered the cache_.

And so here's the point of this silly story: **_never_ store objects in your cache whose structure may change over time**. And in a nutshell, that's pretty much _any_ non-value object:

* `ActiveRecord` objects can have attributes change via migrations
* other objects can change when gems are updated (including Rails), or even when you update the version of Ruby itself.

### Marshalling data

If you take a look at how Rails caching actually works, [you can see that under the hood][cache-marshal-implementation], the data to be cached is passed to `Marshal.dump`, which turns that data into an encoded string. 

We can see what that looks like here:

~~~ ruby
$ widget = Widget.create(title: 'ZipWidget')
$ data = Marshal.dump(widget)
# \x04\bo:\vWidget\x16:\x10@new_recordF:\x10@attributeso:\x1EActiveModel::AttributeSet\x06;
# \a{\aI\"\aid\x06:\x06ETo:)ActiveModel::Attribute::FromDatabase\n:\n@name@\b:\x1C
# @value_before_type_casti\x06:\n@typeo:\x1FActiveModel::Type::Integer\t:\x0F@precision0
# :\v@scale0:\v@limiti\r:\v@rangeo:\nRange\b:\texclT:\nbeginl-\t\x00\x00\x00\x00\x00\x00\x00\x80:\b
# endl+\t\x00\x00\x00\x00\x00\x00\x00\x80:\x18@original_attribute0:\v@valuei\x06I\"\ntitle\x06;
# \tTo;\n\n;\v@\x0E;\fI\"\x0EZipWidget\x06;\tT;\ro:HActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::MysqlString\b;
# \x0F0;\x100;\x11i\x01\xFF;\x170;\x18I\"\x0EZipWidget\x06;\tT:\x17@association_cache{\x00:\x11
# @primary_keyI\"\aid\x06;\tT:\x0E@readonlyF:\x0F@destroyedF:\x1C@marked_for_destructionF:\x1E
# @destroyed_by_association0:\x1E@_start_transaction_state0:\x17@transaction_state0:\x17
# @inspection_filtero:#ActiveSupport::ParameterFilter\a:\r@filters[\x00:\n@maskU:
# 'ActiveRecord::Core::InspectionMask[\t:\v__v2__[\x00[\x00I\"\x0F[FILTERED]\x06;\tT:$
# @_new_record_before_last_commitT:\x18@validation_context0:\f@errorsU:\x18
# ActiveModel::Errors[\b@\x00{\x00{\x00:\x13@_touch_recordT:\x1D@mutations_from_database0: 
# @mutations_before_last_saveo:*ActiveModel::AttributeMutationTracker\a;\ao;\b\x06;\a{\a
# @\bo:%ActiveModel::Attribute::FromUser\n;\v@\b;\fi\x06;\r@\n;\x17o;\n\n;\v@\b;\f0;\r
# @\n;\x170;\x180;\x18i\x06@\x0Eo;0\n;\v@\x0E;\fI\"\x0EZipWidget\x06;\tT;\r@\x11;\x17o;\n\t;
# \v@\x0E;\f0;\r@\x11;\x170;\x18@\x10:\x14@forced_changeso:\bSet\x06:\n@hash}\x00F
~~~

If you look closely in there, you can see some of the values (e.g. the value `ZipWidget`), but there's plenty of other information about the specific structure and implementation of the ActiveRecord instance -- particularly about the model's understanding of the database -- that's encoded into that dump.

You can revive the object by using `Marshal.load`:

~~~ ruby
$ cached_widget = Marshal.load(data)
# => #<Widget id: 1, title: "ZipWidget">
~~~

And that works great, until you try and use any _new_ attributes that might exist in the database. Let's add the `colour` column, just using the console for convenience:

~~~ ruby
$ ActiveRecord::Migration.add_column :widgets, :colour, :string, default: 'beige'
~~~

We can check this all works and that our widget in the database gets the right value:

~~~ ruby
$ Widget.first.colour
# => 'beige'
~~~

But what if we try and use that same widget, but from the cache:

~~~ ruby
$ cached_widget = Marshal.load(data)
# => #<Widget id: 1, title: "ZipWidget">
$ cached_widget.colour
Traceback (most recent call last):
        1: from (irb):14
NoMethodError (undefined method `colour' for #<Widget id: 1, title: "ZipWidget">)
~~~

Boom. The cached instance thinks it already knows everything about the schema that's relevant, so when we try to invoke a method from a schema change, we get an error.

### Workarounds

The only ways to fix this are

* clearing your cache, losing all the benefits of it until it's populated again
* reloading the object after it's retrieved from the cache, again losing many of the benefits of it being cached
* or by adding behaviour to anything that _calls_ `Widget#colour`, to handle the raised exception if it's missing. 

Not great.

But there's a better solution, which is avoiding this issue in the first place.

## Store IDs, not objects

Sometimes it is useful to take a step back from the code and think about what we are trying to acheive. We want to quickly return the set of available widgets, but calculating that set takes a long time. However, there's a difference between _calculating_ the set, and _loading_ that set from the database. Once we know which objects are a part of the set, actually loading those records is likely to be pretty fast -- databases are pretty good at those kinds of queries.

So we don't actually need to cache the fully loaded objects; we just need to cache something that lets us quickly load the _right_ objects -- their unique `id`s.

Here's my proposed fix for WidgetCorp:

~~~ ruby
module WidgetHelper
  def available_widgets
    ids = Rails.cache.fetch('available-widgets', expires_at: Date.tomorrow.beginning_of_day) do
      Widget.available.pluck(:id)
    end
    Widget.where(ids: ids)
  end
end
~~~

Yes, it's less elegant that neatly wrapping the slow code in a cache block, but the alternative is a world of brittle cache data and deployment fragility and pain. If a new column is added to the `widgets` table, nothing breaks because we're not caching anything but the IDs.

## Bonus code: defend your app from brittle cache objects

It can be easy to forget this when you're building new features. This is the kind of thing that only bites in production, and it can happen years after the unfortunate cache entered use.

So the best way of making sure to avoid it, is to have something in your CI build that automatically checks for these kinds of records entering your cache.

In your `config/environments/test.rb` file, find the line that controls the cache store:

~~~ ruby
# config/environments/test.rb
config.cache_store = :null
~~~

and change it to this:

~~~ ruby
# config/environments/test.rb
config.cache_store = NullStoreVerifyingAcceptableData.new
~~~

And in `lib`, create this class:

~~~ ruby
# lib/null_store_verifying_acceptable_data.rb
class NullStoreVerifyingAcceptableData < ActiveSupport::Cache::NullStore
  class InvalidDataException < Exception; end

  private

  def write_entry(key, entry, **options)
    check_value(entry.value)
    true
  end

  def check_value(value)
    if value.is_a?(ActiveRecord::Base) || value.is_a?(ActiveRecord::Relation)
      raise InvalidDataException, 
        "Tried to store #{value.class} in a cache. We cannot do this because \
        the behaviour/schema may change between this value being stored, and \
        it being retrieved. Please store IDs instead."
    elsif value.is_a?(Array) || value.is_a?(Set)
      value.each { |v| check_value(v) }
    elsif value.is_a?(Hash)
      value.values.flatten.each { |v| check_value(v) }
    end
  end
end
~~~

With this in place, when your build runs any test that exercises behaviour that ends up trying to persist ActiveRecord objects into the cache will raise an exception, causing the test to fail with an explanatory message.

You can extend this to include other classes if you have other objects that may change their interface over time.

### Double bonus: tests for `NullStoreVerifyingAcceptableData`

How can we be confident that the new cache store is actually going to warn us about behaviours in the test? What if it never ever raises the exception?

When I'm introducing non-trivial behaviour into my test suite, I like to test _that_ too. So here's some tests to sit alongside this new cache store, so we can be confident that we can actually rely on it.

~~~ ruby
require 'test_helper'

class NullStoreVerifyingAcceptableDataTest < ActiveSupport::TestCase
  setup do
    @typical_app_class = Widget
  end

  test 'raises exception when we try to cache an ActiveRecord object' do
    assert_raises_when_caching { @typical_app_class.first }
  end

  test 'raises an exception when we try to cache a relation' do
    assert_raises_when_caching { @typical_app_class.first(5) }
  end

  test 'raises an exception when we try to cache an array of ActiveRecord objects' do
    assert_raises_when_caching { [@typical_app_class.first] }
  end

  test 'raises an exception when we try to cache a Set of ActiveRecord objects' do
    assert_raises_when_caching { Set.new([@typical_app_class.first]) }
  end

  test 'raises an exception when we try to cache a Hash that contains ActiveRecord objects' do
    assert_raises_when_caching { {value: @typical_app_class.first} }
  end

  test 'does not raise anything when caching an ID' do
    Rails.cache.fetch(random_key) { @typical_app_class.first.id }
  end

  test 'does not raise anything when caching an array of IDs' do
    Rails.cache.fetch(random_key) { @typical_app_class.first(5).pluck(:id) }
  end

  private

  def assert_raises_when_caching(&block)
    assert_raises NullStoreVerifyingAcceptableData::InvalidDataException do
      Rails.cache.fetch(random_key, &block)
    end
  end

  def random_key
    SecureRandom.hex(8)
  end
end
~~~

If you extend the cache validator to check for other types of objects, you can add tests to make sure those changes work as you expect.

### Triple-bonus code: what if you already have cached objects?

My _real_ fix for WidgetCorp would actually try to mitigate this issue while still respecting the (possibly broken) objects still in the cache:

~~~ ruby
module WidgetHelper
  def available_widgets
    ids_or_objects = Rails.cache.fetch('available-widets', expires_at: Date.tomorrow.beginning_of_day) do
      Widget.available.pluck(:id)
    end
    ids = if ids_or_objects.first.present? && ids_or_objects.first.is_a?(ActiveRecord::Base) 
      ids_or_objects.map(&:id)
    else
      ids_or_objects
    end
    Widget.where(id: ids)
  end 
end
~~~

This allows us to still use the ActiveRecord instances that are cached, while storing any new data in the cache as just IDs. Once this code has been running for a day, all of the existing data in the cache will have expired and the implementation can be changed to [the simpler one](#store-ids-not-objects).

[^fast]: Pocket dimension, closed timelike curves, above your paygrade, don't worry about it!

[^view-caching]: You might imagine we could get around all this by caching the view, and indeed in this case, it wouldn't raise the same problems, but in a typically mature Rails application we end up using cached data in other places outside of view generation, so the overall point is worth making. Still, award yourself 1 gold credit.

[cache-marshal-implementation]: https://github.com/rails/rails/blob/6-1-stable/activesupport/lib/active_support/cache.rb#L587-L593

:kind: blog
:created_at: 2021-01-29 15:52:43 +0000
:updated_at: 2021-01-29 15:52:43 +0000
