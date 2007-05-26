require 'lib/remarkably'

describe Remarkably do
  include Remarkably

  it "Accepts a string as a paramater" do
    testing( "Hello World" ).to_s.should ==
      "<testing>Hello World</testing>"
  end

  it "Accepts a block as a paramater" do
    testing do
      text "Hello World"
    end.to_s.should ==
      "<testing>Hello World</testing>"
  end

  it "Accepts multiple strings as paramaters" do
    testing( "Hello", "World" ).to_s.should ==
      "<testing>HelloWorld</testing>"
  end

  it "Closes empty tags neatly" do
    testing.to_s.should ==
      "<testing/>"
  end

  it "Accepts only attributes" do
    testing( :id => "attributes" ).to_s.should ==
      '<testing id="attributes"/>'
  end

  it "Accepts strings and attributes" do
    testing( "Hello ", "World",
             :id => "attributes", :class => "test" ).to_s.should ==
      '<testing class="test" id="attributes">Hello World</testing>'
  end

  it "Allows yielding for internal content" do
    def page
      html do
        body do
          yield
        end
      end
    end
      
    page do
      P "Internal Content"
    end.to_s.should == "<html><body><p>Internal Content</p></body></html>"
  end

  it "Understands style sheets" do
    html do
      head do
        style do
          body do
            background_color "white"
            border "1px solid black"
          end
          div do
            color "blue"
          end
        end
      end
    end.to_s.should == "<html><head><style>\nbody {background-color:white;border:1px solid black;}\ndiv {color:blue;}\n</style></head></html>"
  end

  it "Understands deep style sheets" do
    style do
      div do
        table do
          td do
            background_color "red"
          end
        end
      end
    end.to_s.should == "<style>\ndiv table td {background-color:red;}\n</style>"
  end

  it "Accepts multiple inner blocks for stylesheets" do
    style do
      div do
        P do
          color "blue"
        end
        div do
          color "red"
        end
      end
    end.to_s.should == "<style>\ndiv p {color:blue;}\ndiv div {color:red;}\n</style>"
  end

  it "Understands style sheet classes" do
    style do
      div :class => "report" do
        table :class => "pretty" do
          td do
            background_color "red"
          end
        end
      end
    end.to_s.should == "<style>\ndiv.report table.pretty td {background-color:red;}\n</style>"
  end

  it "Understands style sheet ids" do
    style do
      div :id => "main_content" do
        table :class => "pretty" do
          td do
            background_color "red"
          end
        end
      end
    end.to_s.should == "<style>\ndiv#main_content table.pretty td {background-color:red;}\n</style>"
  end

  it "Understands classes, ids and pseudo classes" do
    style do
      div :id => "main_content" do
        table :class => "pretty", :pseudo => "hover" do
          td do
            background_color "red"
          end
        end
      end
    end.to_s.should == "<style>\ndiv#main_content table.pretty:hover td {background-color:red;}\n</style>"
  end

  it "Understands classes, ids and pseudo classes through inline" do
    style do
      div "#main_content" do
        table ".pretty", ":hover" do
          td ".foo:bar" do
            background_color "red"
          end
        end
      end
    end.to_s.should == "<style>\ndiv#main_content table.pretty:hover td.foo:bar {background-color:red;}\n</style>"
  end

  it "Processes inline styles" do
    div do
      P( "Hello World", :style => inline_style { background_color "yellow"; color "red" } )
      div( :style => inline_style { background_color "red"; color "yellow" } ) do
        P "Goodbye World"
      end
    end.to_s.should == '<div><p style="background-color:yellow;color:red;">Hello World</p><div style="background-color:red;color:yellow;"><p>Goodbye World</p></div></div>'
  end

end
