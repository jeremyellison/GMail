require 'encumber'
require 'rexml/document'
require 'time'

class GMail
  class ExpectationFailed < RuntimeError
  end
  
  attr_accessor :navigation_bar_title
  
  def has_navigation_bar?
    xml = @gui.dump
    doc = REXML::Document.new xml

    xpath = '////UINavigationItemView/title'
    navbar = REXML::XPath.first(doc, xpath)
    @navigation_bar_title = navbar.text
    return !navbar.nil?
  end
  
  def press_reload
    @gui.press("//UIToolbarButton[3]")
  end

  def initialize(host = 'localhost')
    @gui = Encumber::GUI.new host
  end

  def reset
    # restoreDefaults: is not implemented
    # @gui.command 'restoreDefaults'
  end

  def restart
    begin
      @gui.command 'terminateApp'
    rescue EOFError
      # no-op
    end

    sleep 3

    yield if block_given?

    system(<<-HERE)
      osascript -e 'tell application "Xcode"' \
      	   -e 'set GMail to active project document' \
              -e 'launch the executable named "Brominet" of GMail' \
            -e 'end tell' >/dev/null
    HERE

    sleep 7
  end
  
end
