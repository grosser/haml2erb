require 'haml2erb/erb_writer'
require 'haml2erb/parser'
require 'haml2erb/version'

module Haml2Erb

  def self.convert(text)
    parser = Haml2Erb::HamlParser.new
    writer = Haml2Erb::ErbWriter.new
    parser.parse(text, writer)
    writer.output_to_string
  end

end
