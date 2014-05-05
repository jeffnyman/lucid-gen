begin
  require 'symbiont'
rescue LoadError
  STDOUT.puts ['The Symbiont test execution library is not installed.',
               'The driver file is currently set to use the Symbiont library but',
               'that gem was not found. Run the following command:', '',
               '  gem install symbiont'].join("\n")
  Kernel.exit(1)
end

Domain(Symbiont::Factory)

if ENV['BROWSER']
  case ENV['BROWSER']
  when 'firefox', 'ff', 'ie', 'chrome'
    target = ENV['BROWSER'].to_sym
  else
    puts "The browser #{ENV['BROWSER']} is not supported."
    puts ""
    puts "Supported browsers are:"
    puts "  firefox, ie, chrome"
    Kernel.exit(1)
  end
end

module Symbiont
  module Browser

    @@browser = false

    def self.start
      unless @@browser
        target = (ENV['BROWSER'] || 'firefox').to_sym
        @@browser = watir_browser(target) if ENV['DRIVER'] == 'watir' or !ENV['DRIVER']
      end
      @@browser
    end

    def self.stop
      @@browser.quit if @@browser
      @@browser = false
    end

    private

    def self.watir_browser(target)
      if ENV['HEADLESS']
        @driver = Watir::Browser.new :phantomjs
      else
        Watir::Browser.new(target, :http_client => client)
      end
    end

    def self.client
      Selenium::WebDriver::Remote::Http::Default.new
    end
  end
end

AfterConfiguration do |config|
  puts("Specs are being executed from: #{config.spec_location}")
end

Before('~@manual','~@practice','~@sequence') do
  @driver = Symbiont::Browser.start
end

AfterStep('@pause') do
  print 'Press ENTER to continue...'
  STDIN.getc
end

AfterStep do
  if ENV['LATENCY']
    sleep 2
  end
end

After do |scenario|
  Dir::mkdir('results') if not File.directory?('results')

  def screenshot_name(type, name)
    screenshot = "./results/#{type}_#{name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"

    if @driver
      encoded_img = @driver.driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}", 'image/png')

      return screenshot
    end
  end

  if scenario.failed?
    screenshot = screenshot_name('FAILED', scenario.name)
  end

  if ENV['SCREENS']
    if scenario.passed?
      screenshot = screenshot_name('PASSED', scenario.name)
    end
  end

  Symbiont::Browser.stop
end

After do |scenario|
  if ENV['QUICKFAIL']
    Lucid.wants_to_quit = true if scenario.failed?
  end
end

at_exit do
  Symbiont::Browser.stop
end
