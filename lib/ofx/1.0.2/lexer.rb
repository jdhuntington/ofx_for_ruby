#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.2
# from lexical definition file "ofx_102.rex".
#++

require 'racc/parser'
# Copyright © 2007 Chris Guidry <chrisguidry@gmail.com>
#
# This file is part of OFX for Ruby.
#
# OFX for Ruby is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# OFX for Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

module OFX
module OFX102
class Parser < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader :lineno
  attr_reader :filename

  def scan_setup ; end

  def action &block
    yield
  end

  def scan_str( str )
    scan_evaluate  str
    do_parse
  end

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_evaluate  f.read
    end
  end

  def scan_file( filename )
    load_file  filename
    do_parse
  end

  def next_token
    @rex_tokens.shift
  end

  def scan_evaluate( str )
    scan_setup
    @rex_tokens = []
    @lineno  =  1
    ss = StringScanner.new(str)
    state = nil
    until ss.eos?
      text = ss.peek(1)
      @lineno  +=  1  if text == "\n"
      case state
      when nil
        case
        when (text = ss.scan(/\<\//))
           @rex_tokens.push action { state = :TAG; [:etag_in, text] }

        when (text = ss.scan(/\</))
           @rex_tokens.push action { state = :TAG; [:tag_in, text] }

        when (text = ss.scan(/\s+(?=\S)/))
          ;

        when (text = ss.scan(/.*?(?=(\<|\<\/)+?)/))
           @rex_tokens.push action {               [:text, text] }

        when (text = ss.scan(/.*\S(?=\s*$)/))
           @rex_tokens.push action {               [:text, text] }

        when (text = ss.scan(/\s+(?=$)/))
          ;

        else
          text = ss.string[ss.pos .. -1]
          raise  ScanError, "can not match: '" + text + "'"
        end  # if

      when :TAG
        case
        when (text = ss.scan(/\>/))
           @rex_tokens.push action { state = nil;  [:tag_out, text] }

        when (text = ss.scan(/[\w\-\.]+/))
           @rex_tokens.push action {               [:element, text] }

        else
          text = ss.string[ss.pos .. -1]
          raise  ScanError, "can not match: '" + text + "'"
        end  # if

      else
        raise  ScanError, "undefined state: '" + state.to_s + "'"
      end  # case state
    end  # until ss
  end  # def scan_evaluate

end # class

end # module OFX102
end # module OFX

=begin
if __FILE__ == $0
  exit  if ARGV.size != 1
  filename = ARGV.shift
  rex = OFX::OFX102::Parser.new
  begin
    rex.load_file  filename
    while  token = rex.next_token
      p token
    end
  rescue
    $stderr.printf  "%s:%d:%s\n", rex.filename, rex.lineno, $!.message
  end
end
=end
