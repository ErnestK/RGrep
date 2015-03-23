require "thor"
require File.join(File.dirname(__FILE__), 'Rgrep', 'Description.rb')

class MyGrep < Thor
  include Description
  class_option :verbose, :type => :boolean
  map "-Hey" => :hello
  map "-l" => :list
  map "-d" => :diff
  map "-f" => :recursive

  desc "hello NAME", "say hello to NAME"
  long_desc <<-LONGDESC
  #{LONGDESC_HELLO}
  LONGDESC
  option :from, :desc => 'Field from', :banner => 'Vasya', :required => true,
   :default => 'Def Lutz', :aliases => '-f'
  option :yell, :type => :boolean
  def hello(name)
    output = []
    output << "from: #{options[:from]}" if options[:from]
    output << "Hello #{name}"
    output = output.join("\n")
    puts options[:yell] ? output.upcase : output
  end

  desc "List all files/folders/running_process", "list -p 'MySql'"
  option :procces, :desc => 'Running procces', :banner => 'All',:aliases => '-p'
  option :procces, :desc => 'Running procces', :banner => 'All',:aliases => '-p'
  def list
    procces = `ps aux` if options[:procces]
    # procces = `tasklist` if options[:procces] # TODO: for Win
  rescue Exception => e
  end

  def diff

  rescue Exception => e
  end

  def find

  rescue Exception => e
end

MyGrep.start(ARGV)