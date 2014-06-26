class HomeController < ApplicationController
  def index
    @person = Person.new
  end
end
