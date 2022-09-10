class ErrorPages::ErrorPagesController < ActionController::Base
  # 40x
  def not_found
    render(file: "#{Rails.root}/public/error_pages/404_not_found.html", layout: false)
  end

  def not_acceptable
    render(file: "#{Rails.root}/public/error_pages/406_not_acceptable.html", layout: false)
  end

  def application_error
    render(file: "#{Rails.root}/public/error_pages/500_application_error.html", layout: false)
  end
end
