print "hello!\n"

# configure
require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
OpenTelemetry::SDK.configure do |c|
  print "Configuring open telemetry\n"
end

input = <<EOF
 XXXX 
 X  X 
 XXXX 
      
EOF

# now go

tracer = OpenTelemetry.tracer_provider.tracer('paint')
tracer.in_span("noodles", kind: :server, attributes: { "coolness" => 96 }) do |span|
  # ... cool stuff
end
tracer.in_span("noodles", kind: :server, attributes: { "coolness" => 98 }) do |span|
  # ... cool stuff
end
tracer.in_span("noodles", kind: :server, attributes: { "coolness" => 97 }) do |span|
  # ... cool stuff
end

# maybe wait around for it to send?
sleep 10
print "Good bye\n"
