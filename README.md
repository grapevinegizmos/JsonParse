# JsonParse

JsonParse is a gem for use in Rails to discover and navigate json documents with simple dot notation, and to extract subtrees, nodes and values with a minimum of fuss.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_parse'
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

Obtain the keys to any branch of the json document using the `keys` method.  If the referenced element is a container of other elements, the keys it contains are returned by the keys method.  If the element contains an array, '[]' is returned. If the keys method is called on an element whose value is a scalar, an undefined method error will result.

```
`puts jp.specification.calzone.keys` 
 => [:sides, :examples, :name]`
   
jp.specification.calzone.examples.keys
=> "[]"
jp.specification.calzone.sides.keys
jp.specification.calzone.sides.keys 
=> undefined method `keys' for 6:Integer
```


Dot notation is used to access the value of an element in the json docuemnt.  if the element is a key to another set of json elements, a new JsonParse is created and returned to the caller.
  
```Ruby
branch=jp.specification.calzone #brach contains a new JsonParse object
branch.keys  #[:sides, :examples, :names]
branch.sides
=> 6
````
If the referenced element contains an array, it will be retrieved as an array of JsonParse.  Its elements can be accessed by index.  The keys method can be used on the indexed element to reveal the available symbols.
``` 
examples = jp.specification.calzone.examples 
puts examples[1].keys
=>[:name, :type]

puts "#{examples[1].name}  type:  #{examples[1].type}"
=> "corn dog  type:  calzone"
```

JsonParse arrays can be interated with the `each` method.  
```Ruby 
jp.specification.salad.examples.each do |example| puts example.name end`

steak  
mashed potatoes   
fried rice
poutine
```

In additions to `keys`, JsonParse wraps the convenience methods `length` & `count` to return the number of keys in a document element, or the number of items in an array element. The `rootkey` method returns the name of the singular document root element (if present). 
 
The `hash` and `json_string` methods return a hash and json representation of the object respectively.
These methods can be useful to extract the relevant portion of a subbracnch and generate new json representation of just that branch.  The `source` method returns the string or hash supplied when the object was initialized.   

Because some of these methods may also represent keys in a json string (viz. `count`, `keys`, `source`), if a matching key exists as an attribute name, the attribute value will be returned instead of the method's value. 
Appending a '!' to the method name (viz `count!`, `keys!`, `hash!`) will return the intended method result irrespective of the presence of an identical key in the json document.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/JsonParse.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
 