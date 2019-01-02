
require 'spec_helper'
RSpec.describe JsonParse do

  it "initializes a jsonparse object" do
    my_jsonstring= "{\"company_name\":\"Acme Industries\",\"company_id\":1085}"
    jp=JsonParse.new(my_jsonstring)
    expect(jp).to_not be_nil


  end
  it "examines a jsonparse" do
    rule = "{\"rule\":\"cube\",\"authority\":\"http://cuberule.com\",\"specification\":{\"salad\":{\"sides\":0,\"examples\":[{\"name\":\"steak\",\"type\":\"salad\"},{\"name\":\"mashed potatoes\",\"type\":\"salad\"},{\"name\":\"fried rice\",\"type\":\"salad\"},{\"name\":\"poutine\",\"type\":\"salad\"}],\"name\":\"salad\"},\"toast\":{\"sides\":1,\"examples\":[{\"name\":\"pizza\",\"type\":\"toast\"},{\"name\":\"muffins\",\"type\":\"toast\"},{\"name\":\"salmon sushi\",\"type\":\"toast\"}],\"name\":\"toast\"},\"sandwich\":{\"sides\":2,\"examples\":[{\"name\":\"lasagna\",\"type\":\"sandwich\"},{\"name\":\"quesadilla\",\"type\":\"sandwich\"}],\"name\":\"sandwich\"},\"taco\":{\"sides\":3,\"examples\":[{\"name\":\"hot dog\",\"type\":\"taco\"},{\"name\":\"slice of pie\",\"type\":\"taco\"},{\"name\":\"subway sandwich\",\"type\":\"taco\"}],\"name\":\"taco\"},\"sushi\":{\"sides\":4,\"examples\":[{\"name\":\"pigs in a blanket\",\"type\":\"sushi\"},{\"name\":\"enchilada\",\"type\":\"sushi\"},{\"name\":\"felafel wrap\",\"type\":\"sushi\"}],\"name\":\"sushi\"},\"quiche\":{\"sides\":5,\"examples\":[{\"name\":\"cheesecake\",\"type\":\"quiche\"},{\"name\":\"soup in a breadbowl\",\"type\":\"quiche\"},{\"name\":\"key lime pie\",\"type\":\"quiche\"},{\"name\":\"deep-dish pizza\",\"type\":\"quiche\"}],\"name\":\"quiche\"},\"calzone\":{\"sides\":6,\"examples\":[{\"name\":\"burrito\",\"type\":\"calzone\"},{\"name\":\"corn dog\",\"type\":\"calzone\"},{\"name\":\"pop tart\",\"type\":\"calzone\"}],\"name\":\"calzone\"}}}"
    jp = JsonParse.new(rule)
    puts pp jp.hash
    j=1
  end

end