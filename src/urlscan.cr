require "har"
require "json"
require "http"
require "colorize"
require "option_parser"

url = ""
method = "GET"
body = ""
headers = HTTP::Headers.new

parser = OptionParser.new do |parser|
  parser.banner = "Usage: urlscan [arguments]"
  parser.on("-u URL", "--url=URL", "Target URL") { |url_arg| url = url_arg }
  parser.on("-m METHOD", "--method=METHOD", "HTTP Method to use (GET/POST/etc..)") { |method_arg| method = method_arg }
  parser.on("-b BODY", "--body=BODY", "Body to send") { |body_arg| body = body_arg }
  parser.on("-H HEADER", "--header=HEADER", "Header to send (NAME:VALUE)") { |header_arg| headers[header_arg.split(":")[0].strip] = header_arg.split(":")[1].strip }

  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

parser.parse

if url.empty?
  STDERR.puts "ERROR: URL is required"
  STDERR.puts parser
  exit(1)
end

request = HTTP::Request.new(
  method: method,
  resource: url,
  body: body,
  headers: headers
)

resp = HTTP::Client.exec(
  method: method,
  url: url,
  headers: headers.empty? ? nil : headers,
  body: body.empty? ? nil : body
)


har = HAR::Log.new
har.entries << HAR::Entry.new(
  request: HAR::Request.new(request),
  response: HAR::Response.new(resp),
  time: 0.0,
  timings: HAR::Timings.new(
    send: 0.0,
    wait: 0.0,
    receive: 0.0
  ),
)

print HAR::Data.new(log: har).to_json
