module AllowBrowser
  extend ActiveSupport::Concern

  included do
    before_action :check_browser_support
  end

  private

  def check_browser_support
    browser = Browser.new(request.user_agent)
    
    return if browser.bot? || browser.search_engine?
    return if browser.modern?
    return if MOBILE_BROWSERS.any? { |mobile| browser.send("#{mobile}?") }
    
    render 'public/406-unsupported-browser', layout: false, status: :not_acceptable
  end
end
