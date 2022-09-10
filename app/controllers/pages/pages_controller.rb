class Pages::PagesController < ActionController::Base
  def landing
    render(file: "#{Rails.root}/public/landing.html", layout: false)
  end
end
