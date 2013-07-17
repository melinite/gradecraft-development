module CustomFabricators
  def fabricate(name, &block)
    define_method name do
      instance_variable_get("@#{name}") || instance_variable_set("@#{name}", send("create_#{name}"))
    end

    define_method "create_#{name}" do |overrides = {}|
      default_attributes = (instance_eval(&block) if block_given?) || {}
      Fabricate name, default_attributes.merge(overrides)
    end

    define_method "build_#{name}" do |overrides = {}|
      default_attributes = respond_to?("#{name}_attributes") ? send("#{name}_attributes") : {}
      Fabricate.build name, default_attributes.merge(overrides)
    end
  end
end
