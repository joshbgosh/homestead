class SignupSigninController < ApplicationController
  #Renders a page with both sign-in and sign-up pages, which isn't well supported by devise out of the box.
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  def signup_or_signin
    resource = build_resource
       clean_up_passwords(resource)
       respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
  end
end