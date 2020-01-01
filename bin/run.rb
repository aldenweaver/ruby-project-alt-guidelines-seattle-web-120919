require_relative '../config/environment'
# require 'artii'

# a = Artii::Base.new :font => 'slant'
# a.asciify('Art!')

cli = CommandLineInterface.new
cli.run
