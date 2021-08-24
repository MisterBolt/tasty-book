module ApplicationHelper
  include Pagy::Frontend

  def link_to_add_fields(f = nil, association = nil, partial = nil, id = nil)
    # Render the form fields from a file with the association name provided
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, child_index: 'FIELDSET_INDEX') do |builder|
      render partial: partial, locals: {f: builder}
    end

    # The rendered fields are sent with the link within the data-form-prepend attr
    html_options = {}
    html_options['data-form-prepend'] = raw CGI::escapeHTML( fields )
    html_options['href'] = '#'
    html_options['id'] = id
    html_options['class'] = 'bg-transparent hover:bg-blue-500 text-blue-700 mt-4 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded'
    html_options
  end
end
