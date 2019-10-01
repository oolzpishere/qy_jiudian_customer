require "admin/field"

module Admin
  class Engine < ::Rails::Engine
    isolate_namespace Admin
  end
end
