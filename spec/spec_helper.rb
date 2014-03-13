require 'fakefs/spec_helpers'
require 'stringio'

def capture_output
  sio = StringIO.new
  yield(sio)
  sio.rewind
  sio.read
end

