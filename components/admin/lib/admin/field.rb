require 'active_support/inflector/inflections'

module Admin
  class Field
    # for outside API
    # attr_reader :associated_resource
    attr_accessor :namespace, :column_name, :field_module_name, :has_many_attributes_to_show

    def initialize(params)
      # @namespace = ""
      # @associated_resource = params[:associated_resource]
      @column_name = params[:column_name]
      @field_module_name = params[:field_module_name]
      @has_many_attributes_to_show = field_module_name[:show] if has_many_attribute?
    end

    def to_partial_path
      "admin/field/#{field_type}/form"
    end

    # Hash eg. rooms: {field_type: "Field::HasMany", show: ["names", "room_number"]}
    def field_type
      if field_module_name.is_a?(Hash)
        @namespace = field_module_name[:namespace]
        return get_field_type(field_module_name[:field_type])
      else
        get_field_type(field_module_name)
      end
    end

    def get_field_type(field_module_name)
      field_module_name.to_s.split("::").last.underscore
    end

    def has_many_attribute?
      field_type.match(/has_many/)
    end

    # def associated_resource
    #   if @namespace
    #      "#{@namespace}::#{column_name.to_s.singularize}".camelize
    #   end
    # end
    #
    # def associated_resource_class
    #   ActiveSupport::Inflector.constantize(associated_resource)
    # end
    #
    # def associated_resource_options
    #   resource.send(column_name)
    # end

  end
end
