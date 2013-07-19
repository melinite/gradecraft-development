module CustomFabricators
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def define_custom_fabricator(name, &defaults)
      define_method name do
        instance_eval "@#{name} ||= create_#{name}", __FILE__, __LINE__
      end

      define_method "create_#{name}" do |overrides = {}, &block|
        Fabricate(name, attributes_eval(defaults).merge(overrides)).tap do |object|
          instance_eval_with_fabricated_object(name, object, block) if block
        end
      end

      define_method "build_#{name}" do |overrides = {}, &block|
        Fabricate.build(name, attributes_eval(defaults).merge(overrides)).tap do |object|
          instance_eval_with_fabricated_object(name, object, block) if block
        end
      end
    end
  end

  private

  def attributes_eval(attributes)
    attributes ? instance_eval(&attributes) : {}
  end

  def instance_eval_with_fabricated_object(name, object, block)
    original = method(name).unbind
    define_singleton_method name, -> { object }
    instance_eval(&block)
    define_singleton_method name, original
  end
end
