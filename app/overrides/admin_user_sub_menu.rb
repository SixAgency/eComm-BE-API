Deface::Override.new(
    virtual_path: 'spree/admin/shared/_tabs',
    name: 'admin_user_sub_menu_index',
    replace: "erb[loud]:contains('BackendConfiguration::USER_TABS')",
    text: <<-ERB)
<%= tab *Spree::BackendConfiguration::USER_TABS, url: spree.admin_users_path, icon: 'user' do %>
  <%- render 'spree/admin/users/sub_menu' %>
<%- end %>
ERB

Deface::Override.new(
    virtual_path: "spree/admin/shared/_main_menu",
    name: "admin_user_sub_menu_index",
    insert_after: "#admin-menu",
    partial: "spree/admin/users/sub_menu",
)