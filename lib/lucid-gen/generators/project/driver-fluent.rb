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
