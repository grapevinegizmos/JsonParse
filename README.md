# JsonParse

JsonParse is a gem for use in Rails to discover and navigate json documents with simple dot notation, and to extract subtrees, nodes and values with a minimum of fuss.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'JsonParse'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install JsonParse

## Usage

Load with Json string:

`my_jsonstring= "{\"company_name\":\"Acme Industries\",\"company_id\":1085}"
`
`jp=JsonParse.new(my_jsonstring)`

Load with a hash

`jp=JsonParse.new({company_name: "Acme Industries", company_id: 1085})`

Access an element using dot notation:

`puts "#{jp.company_name} id: #{jp.company_id}`  #Acme Industries id: 1085

Consider Json representation of a more complex object: (thanks to [cuberule.com](http://cuberule.com)!)

`cuberule = "{\"rule\":\"cube\",\"authority\":\"http://cuberule.com\",\"specification\":{\"salad\":{\"sides\":0,\"examples\":[{\"name\":\"steak\",\"type\":\"salad\"},{\"name\":\"mashed potatoes\",\"type\":\"salad\"},{\"name\":\"fried rice\",\"type\":\"salad\"},{\"name\":\"poutine\",\"type\":\"salad\"}],\"name\":\"salad\"},\"toast\":{\"sides\":1,\"examples\":[{\"name\":\"pizza\",\"type\":\"toast\"},{\"name\":\"muffins\",\"type\":\"toast\"},{\"name\":\"salmon sushi\",\"type\":\"toast\"}],\"name\":\"toast\"},\"sandwich\":{\"sides\":2,\"examples\":[{\"name\":\"lasagna\",\"type\":\"sandwich\"},{\"name\":\"quesadilla\",\"type\":\"sandwich\"}],\"name\":\"sandwich\"},\"taco\":{\"sides\":3,\"examples\":[{\"name\":\"hot dog\",\"type\":\"taco\"},{\"name\":\"slice of pie\",\"type\":\"taco\"},{\"name\":\"subway sandwich\",\"type\":\"taco\"}],\"name\":\"taco\"},\"sushi\":{\"sides\":4,\"examples\":[{\"name\":\"pigs in a blanket\",\"type\":\"sushi\"},{\"name\":\"enchilada\",\"type\":\"sushi\"},{\"name\":\"felafel wrap\",\"type\":\"sushi\"}],\"name\":\"sushi\"},\"quiche\":{\"sides\":5,\"examples\":[{\"name\":\"cheesecake\",\"type\":\"quiche\"},{\"name\":\"soup in a breadbowl\",\"type\":\"quiche\"},{\"name\":\"key lime pie\",\"type\":\"quiche\"},{\"name\":\"deep-dish pizza\",\"type\":\"quiche\"}],\"name\":\"quiche\"},\"calzone\":{\"sides\":6,\"examples\":[{\"name\":\"burrito\",\"type\":\"calzone\"},{\"name\":\"corn dog\",\"type\":\"calzone\"},{\"name\":\"pop tart\",\"type\":\"calzone\"}],\"name\":\"calzone\"}}}"`

Pretty printing the hash using jp.hash gives a comprehensible view.  


`jp= JsonParse.new(cuberule)`  
`puts pp jp.hash`
```ruby
{:rule=>"cube",
 :authority=>"http://cuberule.com",
 :specification=>
  {:salad=>
    {:sides=>0,
     :examples=>
      [{"name"=>"steak", "type"=>"salad"},
       {"name"=>"mashed potatoes", "type"=>"salad"},
       {"name"=>"fried rice", "type"=>"salad"},
       {"name"=>"poutine", "type"=>"salad"}],
     :name=>"salad"},
   :toast=>
    {:sides=>1,
     :examples=>
      [{"name"=>"pizza", "type"=>"toast"},
       {"name"=>"muffins", "type"=>"toast"},
       {"name"=>"salmon sushi", "type"=>"toast"}],
     :name=>"toast"},
   [...]
   :calzone=>
    {:sides=>6,
     :examples=>
      [{"name"=>"burrito", "type"=>"calzone"},
       {"name"=>"corn dog", "type"=>"calzone"},
       {"name"=>"pop tart", "type"=>"calzone"}],
     :name=>"calzone"}}}

```

We can retrieve the value of any node by following the tree:
```Ruby
jp.specification.toast.sides
=> 6
jp.specification.calzone.examples[0].name'
=>"burrito"
````

We can find out keys at any level of the document by using the `keys` method.  If the referenced element is a container of other elements, the keys it contains are returned by the keys method.  If the element contains an array, '[]' is returned. Elements which return a scalar value will result in an undefined method error.

```
`puts jp.specification.calzone.keys` 
 => [:sides, :examples, :name]`
   
jp.specification.calzone.examples.keys
=> "[]"
jp.specification.calzone.sides.keys
jp.specification.calzone.sides.keys 
=> undefined method `keys' for 6:Integer
```


If we request a key which is the root of another branch, the branch is returned as a JsonParse:
```Ruby
branch=jp.specification.calzone
branch.sides
=> 6
````
If an element contains the array will be returned as an array of JsonParse, and its elements can be accessed as described above.
``` 
examples = jp.specification.calzone.examples 
puts examples[1].keys
=>[:name, :type]

puts "#{examples[1].name}  type:  #{examples[1].type}"
=> "corn dog  type:  calzone"
```

You can iterate the contents of array within the json document using the each method:
```Ruby 
jp.specification.salad.examples.each do |example| puts example.name end`

steak  
mashed potatoes   
fried rice
poutine
```



 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/JsonParse.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
 