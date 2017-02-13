Deface::Override.new(virtual_path: 'spree/admin/products/_form',
                     name: 'add_max_quantity_allowed_in_cart_to_product_edit',
                     insert_after: 'div[data-hook=admin_product_form_cost_currency]',
                     text: "
    <%= content_tag(:div, data: { hook: 'admin_product_form_max_quantity_allowed_in_cart' }) do %>
      <%= f.field_container :max_quantity_allowed_in_cart, class: ['form-group'] do %>
        <%= f.label :max_quantity_allowed_in_cart, Spree.t(:max_quantity_allowed_in_cart) %>
        <%= f.text_field :max_quantity_allowed_in_cart, class: 'form-control' %>
        <%= f.error_message_on :max_quantity_allowed_in_cart %>
      <% end %>
    <% end %>
  ")