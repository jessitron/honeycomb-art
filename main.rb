print "hello!\n"

# configure
require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
OpenTelemetry::SDK.configure do |c|
  print "Configuring open telemetry\n"
end

input = <<'EOF'
              \     /
          \    o ^ o    /
            \ (     ) /
 ____________(%%%%%%%)____________
(     /   /  )%%%%%%%(  \   \     )
(___/___/__/           \__\___\___)
   (     /  /(%%%%%%%)\  \     )
    (__/___/ (%%%%%%%) \___\__)
            /(       )\
          /   (%%%%%)   \
               (%%%)
                 !
EOF

lines = input.lines
numLines = lines.length
numChars = lines.map { |l| l.length }.max
puts "How many chars in a line? #{numChars}"
characters = lines.map.with_index { |l, y| 
  l.chomp.chars.map.with_index { |c, x|
    { x: x, y: y, char: c }
  }
}.flatten
require 'pp'
events = characters.filter { |c| c[:char] != " " }

pp events

span_attribute_sets = events.map { |e| 
  how_many = e[:char] =~ /[A-Z]/ ? 5 : 1
  one_span = {"character" => e[:char],
   "time_incr" => numChars - e[:x],
   "height" => numLines - e[:y],
  }
  Array.new(how_many) { one_span }
}.flatten

pp span_attribute_sets
# now go

go = Time.now()

pp go

tracer = OpenTelemetry.tracer_provider.tracer('paint')
tracer.in_span("root span", kind: :server, start_timestamp: go) do |root_span| 
  span_attribute_sets.each do |attrs|
    start_at = go - attrs["time_incr"]
    s = tracer.start_span("make an #{attrs["character"]}", start_timestamp: start_at, attributes: attrs)
    pp attrs
    s.finish()
  end 
  puts "This created trace #{root_span.to_span_data.hex_trace_id} with #{span_attribute_sets.length} spans"
end

# maybe wait around for it to send?
puts "Chilling out, hope it sends the batched events"
sleep 10
puts "Good bye"
