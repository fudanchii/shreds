class StaticController < ApplicationController
  skip_before_action :init_props
  layout 'static'

  def login
  end
end
