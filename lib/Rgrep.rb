require "thor"
require File.join(File.dirname(__FILE__), 'Rgrep', 'Description.rb')

class MyGrep < Thor
  include Description
  class_option :verbose, :type => :boolean
  map "-l" => :list
  map "-d" => :diff
  map "-f" => :find

  desc "List all running_process", "list -n 'MySql' -gt 100"
  long_desc <<-LONGDESC
  #{LONGDESC_LIST}
  LONGDESC
  option :count, :type => :boolean, :desc => 'Number of running procces', :banner => 'count',:aliases => '-c', :required => true, :default => true
  option :name, :desc => 'Name of running procces', :banner => 'Name',:aliases => '-n'
  option :less_than, :desc => 'Memory allocate, greater than param', :banner => 'Amount',:aliases => '-lt'
  option :greater_than, :desc => 'Memory allocate, less than param', :banner => 'Amount',:aliases => '-gt'
  def list
    # procces = `tasklist` if options[:procces] # TODO: for Win
    outgoing = []
    # Index in command ps aux
    _name_index = 0
    _memory_index = 3

    %x(ps aux).split("\n").each_with_index do  |str, index|
      outgoing << str if index == 0  # Header

      # is options disable or equal to parameters
      is_opt_name_valid = !options[:name] || options[:name] == str.split(' ')[_name_index]
      is_opt_lt_valid = !options[:less_than] || options[:less_than] < str.split(' ')[_memory_index]
      is_opt_gt_valid = !options[:greater_than] || options[:greater_than] > str.split(' ')[_memory_index]

      outgoing << (options[:count] ? index : '') + str if is_opt_name_valid && is_opt_lt_valid && is_opt_gt_valid
    end

    puts outgoing.join("\n")
    # CLI commands should return 0 if command finished succesful, and -1 if failed
    return 0
  rescue Exception => e
    # TODO: handle error
    return -1
  end

  desc "Difference between two files", "diff file1 file2"
  long_desc <<-LONGDESC
  #{LONGDESC_DIFF}
  LONGDESC
  option :count, :type => :boolean, :desc => 'Number of string in file', :banner => 'count',:aliases => '-c', :required => true, :default => true
  option :show_diff, :type => :boolean, :desc => 'true - Show difference lines, false - show different lines', :aliases => '-sd', :required => true, :default => true
  def diff( _file1 , _file2)
    file1 = {}
    file2 = {}
    file1[:out] = []
    file2[:out] = []
    file1[:out] << _file1
    file2[:out] << _file2

    cnt = 0
    file1[:io_file] = File.new( _file1, "r")
    file2[:io_file] = File.new( _file2, "r")

    while ( file1[:line] = file1[:io_file].gets) || ( file2[:line] = file2[:io_file].gets)
      cnt = cnt + 1
      is_matching = options[:show_diff] ? file1[:line] != file2[:line] : file1[:line] == file2[:line]
      file1[:out] << (options[:count] ? cnt : '') + file1[:line] if is_matching
      file2[:out] << (options[:count] ? cnt : '') + file2[:line] if is_matching
    end
    file1.close
    file2.close

    puts file1[:out].join("\n")
    puts '**********************************************************************'
    puts file2[:out].join("\n")
    # CLI commands should return 0 if command finished succesful, and -1 if failed
    return 0
  rescue Exception => e
    # TODO: handle error
    return -1
  end

  desc "List all running_process", "list -n 'MySql' -gt 100"
  long_desc <<-LONGDESC
  #{LONGDESC_FIND}
  LONGDESC
  option :count, :type => :boolean, :desc => 'Count of finded items', :banner => 'count',:aliases => '-c', :required => true, :default => true
  option :name, :desc => 'Name of files to find', :banner => 'Name',:aliases => '-n', :required => true
  option :dir, :type => :boolean, :desc => 'Search only for folders and file names', :aliases => '-dir', :required => true, :default => true
  option :files, :type => :boolean, :desc => 'Search for containig items in files', :aliases => '-fs', :required => true, :default => false
  def find( _path)
    @dir = {}
    @files = {}
    @name = option[:name]

    incr_search( _path)

    if option[:dir]
      puts "Dir:"
      puts @dir.[:out].join("\n")
    end
    puts "*******************************************************" if option[:dir] && option[:files]
    if option[:files]
      puts "Into files:"
      puts @files.[:out].join("\n")
    end

    # CLI commands should return 0 if command finished succesful, and -1 if failed
    return 0
  rescue Exception => e
    # TODO: handle error
    return -1
  end

  private
  def incr_search( path)
    path = path[-1,1] == '/' ? path : path + '/'

    Dir.foreach( path) do |file|
      @dir[:out] << file if file.include? @name
      incr_search( path + file) unless file.include? '.'

      cnt = 0
      file = File.new(  path + file, "r")
      while ( line = file.gets) 
        cnt = cnt + 1
        if line.include? @name
          @files[:out] << path + file + ':'
          @files[:out] << cnt + ': '+ line
        end
      end
      file.close
    end
  end

end

MyGrep.start(ARGV)
