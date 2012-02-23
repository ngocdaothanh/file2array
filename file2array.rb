# Put list of files here
$filenames = ["myfile.txt"]

# Put format here, see below for a list of formats
$writer_format = lambda { CSharp }

#------------------------------------------------------------------------------
# Formats

CSharp = {
  :filename => lambda do |basename_without_extension|
    basename_without_extension.capitalize + '.cs'
  end,

  :header => lambda do |basename_without_extension|
  	classname = basename_without_extension.capitalize
  	"public class #{classname} {\n" +
    "    public static byte[] data =\n" +
    "    {\n"
  end,

  :footer => "\n    };\n}\n"
}

#------------------------------------------------------------------------------
# A writer should have these methods:
#   initialize(basename_without_extension)
#   write(byte)
#   eof

class Writer
  NUM_ELEMENTS_PER_LINE = 15

  def initialize(basename_without_extension)
    @format = $writer_format.call

    filename = @format[:filename].call(basename_without_extension)
  	@file    = File.open(filename, 'w')

    header = @format[:header].call(basename_without_extension)
  	@file.write(header)

  	@next_is_first                = true
  	@num_elements_on_current_line = 0
  end

  def write(byte)
    if @num_elements_on_current_line == 0
      @file.write(",\n") unless @next_is_first
      @file.write('        ')
    end

  	hex  = byte.to_s(16)
  	hex2 = if hex.length == 1 then "0#{hex}" else hex end
  	if @next_is_first || @num_elements_on_current_line == 0
	  @file.write("0x#{hex2}")
	  @next_is_first = false
	else
	  @file.write(", 0x#{hex2}")
	end

    @num_elements_on_current_line += 1
    if @num_elements_on_current_line > NUM_ELEMENTS_PER_LINE
      @num_elements_on_current_line = 0
    end
  end

  def eof
  	footer = @format[:footer]
  	@file.write(footer)
  	@file.close
  end
end

#------------------------------------------------------------------------------
# main

$filenames.each do |filename|
  File.open(filename) do |file|
  	basename_without_extension = File.basename(filename, File.extname(filename))
  	writer = Writer.new(basename_without_extension)
    file.each_byte { |byte| writer.write(byte) }
    writer.eof
  end
end
