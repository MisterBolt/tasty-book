module ApplicationHelper
  include Pagy::Frontend

  def link_to_add__ingredients_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
    # If a block is provided there is no name attribute and the arguments are
    # shifted with one position to the left. This re-assigns those values.
    f, association, options, html_options = name, f, association, options if block

    options = {} if options.nil?
    html_options = {} if html_options.nil?

    locals = if options.include? :locals
      options[:locals]
    else
      {}
    end

    partial = if options.include? :partial
      options[:partial]
    else
      association.to_s.singularize + "_fields"
    end

    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: "FIELDSET_INDEX") do |builder|
      render(partial, locals.merge!(f: builder))
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options["data-form-prepend"] = raw CGI.escapeHTML(fields)
    html_options["href"] = "#"
    html_options["id"] = "add_ingredient"
    html_options["class"] = "btn-primary"
    html_options
  end

  def link_to_add_fields(partial, type, builder, locals = {})
    field = render(partial, locals.merge!(form: builder))
    content_tag(:a, I18n.t("buttons.add"), data: {prepend: field, type: type}, class: "btn-secondary")
  end  
  
  def avatar_for_user_or_guest(user)
    user&.default_or_attached_avatar || "https://res.cloudinary.com/hp7f0176d/image/upload/v1629268606/sample/blank-profile-picture.png"
  end
end
