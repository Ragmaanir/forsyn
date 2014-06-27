# describe Forsyn::HasInputs do
#   it {
#     class Source
#       include Forsyn::HasOutput

#       def generate!
#         send('test')
#       end
#     end

#     class Sink
#       include Forsyn::HasInputs
#     end

#     source = Source.new
#     sink = Sink.new

#     source.output_to(sink)

#     sink.should_receive(:receive).once.with(source, 'test')

#     source.generate!

#     #sink.input_from(source)
#   }
# end
