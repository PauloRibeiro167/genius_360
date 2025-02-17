class Devise::SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def create
    super
  end

  private

  def resource
    @resource ||= User.new
  end

  def resource_name
    :user
  end

  helper_method :resource, :resource_name
end
