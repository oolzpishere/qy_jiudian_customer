module Admin
  module ApplicationHelper
    autoload :DeviseHelper,        'devise_helper'

    def render_field(form, field)
      render partial: field.to_partial_path, locals: {form: form, field: field}
    end

    def path_with_search_args(path_helper, *args)
      if params.include?("conf")
        path_helper.send(conf: params["conf"])
      else
        path_helper
      end

    end



  end
end
