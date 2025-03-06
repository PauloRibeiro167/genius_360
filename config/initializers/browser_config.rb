module BrowserHelper
  def modern_browser?(browser)
    case 
    when browser.chrome?  then browser.version.to_i >= 80
    when browser.firefox? then browser.version.to_i >= 78
    when browser.safari?  then browser.version.to_i >= 13
    when browser.edge?    then browser.version.to_i >= 80
    else true # Permite outros navegadores por padrão
    end
  end
end

Browser::Base.include(BrowserHelper)

MOBILE_BROWSERS = [:android, :ipad, :iphone, :mobile_safari, :chrome_mobile]
