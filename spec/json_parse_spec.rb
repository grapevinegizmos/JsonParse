RSpec.describe JsonParse do
  rule = "{\"rule\":\"cube\",\"authority\":\"http://cuberule.com\",\"specification\":{\"salad\":{\"sides\":0,\"examples\":[{\"name\":\"steak\",\"type\":\"salad\"},{\"name\":\"mashed potatoes\",\"type\":\"salad\"},{\"name\":\"fried rice\",\"type\":\"salad\"},{\"name\":\"poutine\",\"type\":\"salad\"}],\"name\":\"salad\"},\"toast\":{\"sides\":1,\"examples\":[{\"name\":\"pizza\",\"type\":\"toast\"},{\"name\":\"muffins\",\"type\":\"toast\"},{\"name\":\"salmon sushi\",\"type\":\"toast\"}],\"name\":\"toast\"},\"sandwich\":{\"sides\":2,\"examples\":[{\"name\":\"lasagna\",\"type\":\"sandwich\"},{\"name\":\"quesadilla\",\"type\":\"sandwich\"}],\"name\":\"sandwich\"},\"taco\":{\"sides\":3,\"examples\":[{\"name\":\"hot dog\",\"type\":\"taco\"},{\"name\":\"slice of pie\",\"type\":\"taco\"},{\"name\":\"subway sandwich\",\"type\":\"taco\"}],\"name\":\"taco\"},\"sushi\":{\"sides\":4,\"examples\":[{\"name\":\"pigs in a blanket\",\"type\":\"sushi\"},{\"name\":\"enchilada\",\"type\":\"sushi\"},{\"name\":\"felafel wrap\",\"type\":\"sushi\"}],\"name\":\"sushi\"},\"quiche\":{\"sides\":5,\"examples\":[{\"name\":\"cheesecake\",\"type\":\"quiche\"},{\"name\":\"soup in a breadbowl\",\"type\":\"quiche\"},{\"name\":\"key lime pie\",\"type\":\"quiche\"},{\"name\":\"deep-dish pizza\",\"type\":\"quiche\"}],\"name\":\"quiche\"},\"calzone\":{\"sides\":6,\"examples\":[{\"name\":\"burrito\",\"type\":\"calzone\"},{\"name\":\"corn dog\",\"type\":\"calzone\"},{\"name\":\"pop tart\",\"type\":\"calzone\"}],\"name\":\"calzone\"}}}"
  it "has a version number" do
    expect(JsonParse::VERSION).not_to be nil
  end

  it "can parse a simple hash" do
    jp = JsonParse.new({foo: "bar"})
    expect(jp.foo).to eq("bar")
  end

  it "can parse a simple json string" do
     jp=JsonParse.new("{\"foo\":\"bar\",\"bif\":\"baz\"}")
    expect(jp.foo).to eq("bar")
    expect(jp.bif).to eq("baz")
    expect(jp.keys).to eq([:foo, :bif])
  end


  it "can parse a multi level json string" do
    jp = JsonParse.new(rule)
    expect(jp.specification.keys).to eq([:salad, :toast, :sandwich, :taco, :sushi, :quiche, :calzone])
    expect(jp.specification.calzone.sides).to eq(6)
    expect(jp.specification.salad.examples.keys).to eq("[]")
    expect(jp.specification.salad.examples[0].name).to eq("steak")
    expect(jp.specification.sandwich.examples.count).to eq(2)
    expect(jp.authority).to eq("http://cuberule.com")

  end

  it "can iterate an array" do
    jp=JsonParse.new(rule)
    results=[]
    jp.specification.calzone.examples.each do |example|
      results.push(example.name)
    end
    puts results
    expect(results).to eq(["burrito", "corn dog", "pop tart"])
  end

  it "checks for presence of a json key of the same name as a method" do
    h={rootnode: {name: "Arthur", keys:"FruityPebbles8", length: "5'10", count: 1051, json_string: "This is my string", rootkey: "Rootbeer",
                  salads:["Soup", "Steak", "Mashed Potatoes"]}}
    jp = JsonParse.new(h)
    expect(jp.keys).to eq("FruityPebbles8")
    expect(jp.keys!).to eq([:name, :keys, :length, :count, :json_string, :rootkey, :salads])
    expect(jp.length).to eq("5'10")
    expect(jp.length!).to eq(7)
    expect(jp.salads.keys).to eq("[]")
    expect(jp.salads.count!).to eq(3)
    expect(jp.rootkey).to eq("Rootbeer")
    expect(jp.rootkey!).to eq("rootnode")
    expect(jp.json_string).to eq("This is my string")
    expect(jp.json_string!).to eq(jp.hash.to_json)


  end

  end

