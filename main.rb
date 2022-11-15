print "hello!\n"

require "securerandom"
run_id = SecureRandom.uuid
puts "The run ID is #{run_id}"

# configure
require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
OpenTelemetry::SDK.configure do |c|
  print "Configuring open telemetry\n"
end

input = <<EOF
 XXXx 
X    X
 XXXx 
      
EOF

characters = input.lines.map.with_index { |l, y| 
  l.chomp.chars.map.with_index { |c, x|
    { x: x, y: y, char: c }
  }
}.flatten
require 'pp'
events = characters.filter { |c| c[:char] != " " }

pp events


# now go

tracer = OpenTelemetry.tracer_provider.tracer('paint')
tracer.in_root_span("root span", kind: :server) do |root_span| 
  tracer.start_span("boogers", kind: :server, attributes: { "coolness" => 90 }).finish()
  tracer.in_span("noodles", kind: :server, attributes: { "coolness" => 98 }) do |span|
    # ... cool stuff
  end
  tracer.in_span("noodles", kind: :server, attributes: { "coolness" => 97 }) do |span|
    # ... cool stuff
  end
  puts "This created trace #{root_span.to_span_data.hex_trace_id}"
end

# maybe wait around for it to send?
puts "Chilling out, hope it sends the batched events"
sleep 10
puts "Good bye from #{run_id}"
