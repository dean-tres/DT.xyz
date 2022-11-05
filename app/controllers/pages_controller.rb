class PagesController < ApplicationController
  before_action :set_page_title
  layout 'base'

  def landing
    render(file: "#{Rails.root}/public/landing.html", layout: false)
  end

  def components
    render layout: false
  end

  def test; end

  def blank; end

  private

  def set_page_title
    @page_title = 'default page title'
  end
end
