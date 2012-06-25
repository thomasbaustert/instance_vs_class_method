require 'rubygems'
require 'rspec'
require 'instance_vs_class_method'

describe "InstanceVsClassMethod" do

  context "class Foo" do

    describe "singleton methods" do

      it "defines the following singleton methods" do
        # singleton methods are instance methods of the (anonymous) singleton class of class Foo
        Foo.singleton_methods(:false).sort.should(
            eq(["class_method_singleton_var", "class_method_singleton_var=", "singleton_method_class_self",
                "class_method", "class_method=",
                "yaml_tag_subclasses?", "const_missing"].sort))
      end
    end

    describe "::class_instance_var=" do
      before(:each) { Foo.class_method_singleton_var = 17 }

      it "defines an instance variable" do
        Foo.instance_variables.should include("@singleton_instance_var")
      end

      it "is creates a singleton class including the method" do
        Foo.singleton_methods(:false).should include("class_method_singleton_var=")
      end

      it "let getter return given value" do
        Foo.class_method_singleton_var.should eq 17
      end
    end

    describe "class << self" do

      it "is creates a singleton class including the method" do
        Foo.singleton_methods(:false).should include("singleton_method_class_self")
      end
    end

  end

  context "instance of Foo" do
    let(:foo) { Foo.new }

    describe "#instance_method=" do
      before(:each) { foo.instance_method = 42 }

      it "defines an instance variable" do
        foo.instance_variables.should include("@instance_var")
      end

      it "sets instance variable to given value" do
        foo.instance_variable_get(:@instance_var).should eq 42
      end

      it "let getter return given value" do
        foo.instance_method.should eq 42
      end
    end

    describe "#instance_method" do

      it "returns nil if instance variable not set" do
        foo.instance_method.should be_nil
      end
    end

    describe "access to class method" do

      it "has access to class method" do
        Foo.class_method = 9876
        foo.instance_method_has_access_to_class_variables.should eq 9876
      end
    end

    describe "access to class variables" do

      it "has access to class variable" do
        Foo.class_method_singleton_var = 1234
        foo.instance_method_call_class_method.should eq 1234
      end
    end
  end

  describe "Inheritance" do

    class Bar < Foo
    end

    describe "class variable" do

      it "exists only one class variable that is shared for class and subclass" do
        Foo.class_method = 111
        Bar.class_method = 444

        Foo.class_method.should eq 444
        Bar.class_method.should eq 444
      end
    end

    describe "singleton instance variable" do

      it "exists one singleton instance variable for class and for subclass" do
        Foo.class_method_singleton_var = 222
        Bar.class_method_singleton_var = 333

        Foo.class_method_singleton_var.should eq 222
        Bar.class_method_singleton_var.should eq 333
      end
    end
  end

end
