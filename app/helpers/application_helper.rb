module ApplicationHelper
  include Pagy::Frontend

  def link_to_add_fields(name = nil, f = nil, association = nil, partial = nil, id = nil, values = {})
    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "FIELDSET_INDEX") do |builder|
      render partial: partial, locals: values.merge!(f: builder)
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options = {}
    html_options["data-form-prepend"] = raw CGI.escapeHTML(fields)
    html_options["href"] = "#"
    html_options["id"] = id
    html_options["class"] = "btn-secondary"

    content_tag(:a, name, html_options)
  end
end
