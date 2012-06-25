##
# - Foo is an instance of class "Class"
# - Foo super is Object
# - Foo class is Class
# - Foo is a constant that points to an object instantiated from Class
# - Foo holds instance methods for objects instantiated from Foo (e.g. foo = Foo.new)
# - Foo's class methods are hold in a (anonymous) singleton class
#
class Foo
  # self => Foo, self.class => Class

  # ---
  # class variables
  # - A class variable (and its value) is hold in Foo itself
  # - A class variable exists only once for Foo and subclasses of Foo and for all instances of Foo
  #   and for all subclasses of Foo. It holds the same value for Foo and subclasses of Foo and for
  #   all instance of Foo and for all subclasses of Foo. A change in one place changes all places
  # - A class variable must be initialized before first usage

  @@class_variable = "Class-Var-#{self.name}"

  # ---
  # class methods
  # - There a are in fact no class methods in Ruby, only instance methods.
  # - A class method of Foo is in fact an instance method of the (anonymous) singleton class of Foo
  #   Foo(super) -> Singleton(class) -> Class
  # - def self.xxx ... always creates a singleton class
  # - def self.xxx is the same as
  #   def Foo.xxx
  # - The method class_method=() is added an *instance* method the the singleton class
  #   Pseudo code: self.class_method=() =>
  #     class Singleton
  #       def class_method=(value)
  #         ...
  #       end
  #     end
  #
  # - def self.method is same as often seen:
  #     foo = Foo.new
  #     def foo.special_method
  #       ...
  #     end
  #     ...
  #
  #   Like in a class definition a singleton class is created for instance foo and special_method
  #   is added as instance method there.
  #
  def self.class_method=(value)
    # self => Foo, self.class => Class
    @@class_variable = value
  end

  def self.class_method
    @@class_variable
  end

  # ---
  # singleton instance variables
  # - This term does not exists in Ruby. It is a instance variable of the singleton class of Foo.
  # - The value of this variable is stored in the singleton class of Foo.
  # - if Bar inherits from Foo then here is one singleton class for Foo and Bar.
  # - A class instance variable of Foo is defined in the singleton class of Foo and in the
  #   singleton class of Bar
  # - A class instance variable holds the same value for Foo and all its instances but not for a
  #   subclass Bar of Foo (and all that instances).
  #
  @singleton_instance_var = "Singleton-Instance-Var-#{self.name}"

  # this class method is not different to class_method=() except it assigns the value
  # to a class instance variable (not a class variable)
  def self.class_method_singleton_var=(value)
    @singleton_instance_var = value
  end

  def self.class_method_singleton_var
    @singleton_instance_var
  end

  # ---
  # class << self
  # - class << self create a singleton class for Foo
  # - All methods are added as *instance* method to the singleton class
  #   Pseudo code: singleton_method()) => class Singleton; def singleton_method; ... end; end
  class << self
    # self => Class::Foo, self.class => Class

    # this creates an class instance variable @foo_self like @singleton_instance_var and
    # not an class variable @@foo_self like @@class_variable
    #attr_accessor :foo_self

    def singleton_method_class_self
      # self => Foo, self.class => Class
    end

    # TODO is this useful?
    def self.singleton_class_method_class_self
    end
  end

  # ---
  # Instance variable
  # The value of an instance variable is stored in the instance of class Foo (e.g. foo).

  # ---
  # instance methods
  # - are hold in the class of the instance (here Foo)

  def instance_method=(value)
    # self => foo, self.class => Foo
    @instance_var = value

    # assigning to @singleton_instance_var here would create an instance variable of Foo
    # (which is independent of class varibale with same name)
    # @singleton_instance_var = value
  end

  def instance_method
    @instance_var
  end

  def instance_method_has_access_to_class_variables
    @@class_variable
    # returning @singleton_instance_var here would create an instance variable of Foo
    # (which is independent of the class variable with same name)
  end

  def instance_method_call_class_method
    # an instance method can call the class method via self.class.METHOD
    self.class.class_method_singleton_var
  end

end