begin
  require 'fluent'
rescue LoadError
  STDOUT.puts ['The Fluent test execution library is not installed.',
               'The driver file is currently set to use the Fluent library but',
               'that gem was not found. Run the following command:', '',
               '  gem install fluent'].join("\n")
  Kernel.exit(1)
end

Domain(Fluent::Factory)

module Fluent
  module Browser

    @@browser = false

    class Selenium::WebDriver::IE::Server
      old_server_args = instance_method(:server_args)
      define_method(:server_args) do
        old_server_args.bind(self).() << "--silent"
      end
    end

    class Selenium::WebDriver::Chrome::Service
      old_initialize = instance_method(:initialize)
      define_method(:initialize) do |executable_path, port, *extra_args|
        old_initialize.bind(self).call(executable_path, port, '--silent', *extra_args)
      end
    end

    def self.start
      unless @@browser
        target = ENV['BROWSER'] || 'firefox'
        @@browser = watir_browser(target)
      end
      @@browser
    end

    def self.stop
      @@browser.quit if @@browser
      @@browser = false
    end

    private

    def self.watir_browser(target)
      Watir::Browser.new(target.to_sym)
    end
  end
end

AfterConfiguration do |config|
  puts("Specs are being executed from: #{config.spec_location}")
end

Before('~@practice','~@sequence') do
  @browser = Fluent::Browser.start
end

AfterStep('@pause') do
  print 'Press ENTER to continue...'
  STDIN.getc
end

After do |scenario|
  if scenario.failed?
    Dir::mkdir('results') if not File.directory?('results')
    screenshot = "./results/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"

    if @browser
      # This way attempts to save the screenshot as a file.
      #@browser.driver.save_screenshot(screenshot)

      # This way the image is encoded into the results.
      encoded_img = @browser.driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png')
    end
  end
  Fluent::Browser.stop
end

at_exit do
  Fluent::Browser.stop
end
