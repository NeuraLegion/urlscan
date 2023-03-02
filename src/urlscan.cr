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

har_request = HAR::Request.new(
  url: url,
  method: method,
  http_version: "HTTP/1.1"
)

har_request.headers << HAR::Header.new(name: "Host", value: URI.parse(url).authority.to_s)

headers.each do |k, v|
  har_request.headers << HAR::Header.new(name: k, value: v.first)
end

unless body.empty?
  har_request.post_data = HAR::PostData.new(
    text: body,
    mime_type: headers["Content-Type"]? || ""
  )
end

response = HTTP::Client.exec(
  method: method,
  url: url,
  headers: headers.empty? ? nil : headers,
  body: body.empty? ? nil : body
)

har_response = HAR::Response.new(
  status: response.status_code,
  status_text: HTTP::Status.new(response.status_code).description.to_s,
  http_version: "HTTP/1.1",
  content: HAR::Content.new(
    text: response.body || "",
    size: 0
  ),
  redirect_url: "",
)

har = HAR::Log.new
har.entries << HAR::Entry.new(
  request: har_request,
  response: har_response,
  time: 0.0,
  timings: HAR::Timings.new(
    send: 0.0,
    wait: 0.0,
    receive: 0.0
  ),
)

print HAR::Data.new(log: har).to_json
