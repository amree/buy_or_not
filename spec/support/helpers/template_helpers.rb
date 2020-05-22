# frozen_string_literal: true

module TemplateHelpers
  def read_template(module_name)
    Class
      .new
      .extend("Chats::MessageTemplates::#{module_name}".constantize)
  end
end
