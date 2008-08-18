class <%= model.name %>Seed < Germinate::Seed
  <%= options[:method] %> do |<%= singular_name %>|
    <%- attributes.each do |attribute| -%>
    <%= "#{singular_name}.#{attribute.name}(#{attribute.type})" %>
    <%- end -%>
  end
end
