# encoding: UTF-8
require "thor"
require File.join(File.dirname(__FILE__), 'Rgrep', 'Description.rb')

class Rgrep < Thor
	include Description
	class_option :verbose, :type => :boolean
	map "-l" => :list
	map "-d" => :diff
	map "-f" => :find

	desc "List all running_process", "list -n 'MySql' -gt 100"
	long_desc <<-LONGDESC
	#{LONGDESC_LIST}
	LONGDESC
	option :count, :type => :boolean, :desc => 'Number of running procces', :banner => 'count',:aliases => '-c', :default => true
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
		puts "error = #{e}, backtrace = #{e.backtrace.join("\n")}"
		return -1
	end

	desc "Difference between two files", "diff file1 file2"
	long_desc <<-LONGDESC
	#{LONGDESC_DIFF}
	LONGDESC
	option :count, :type => :boolean, :desc => 'Number of string in file', :banner => 'count',:aliases => '-c', :default => true
	option :show_similar, :type => :boolean, :desc => 'Show similar lines', :aliases => '-ss'
	def diff( _file1 , _file2)
		file1 = {}
		file2 = {}

		file1[:io_file] = File.open(_file1)
		file2[:io_file] = File.open(_file2)

		file1[:lines] = file1[:io_file].readlines
		file2[:lines] = file2[:io_file].readlines

		cnt = 0
		puts "File: #{_file1}"
		file1[:lines].each do |line|
			cnt = cnt + 1
			if options[:show_similar]
				puts (options[:count] ? cnt.to_s : '') + line if file2[:lines].include? line
			else
				puts (options[:count] ? cnt.to_s : '') + line unless file2[:lines].include? line
			end
		end

		cnt = 0
		puts "**************************************"
		puts "File: #{_file2}"
		file2[:lines].each do |line|
			cnt = cnt + 1
			if options[:show_similar]
				puts (options[:count] ? cnt.to_s : '') + line if file1[:lines].include? line
			else
				puts (options[:count] ? cnt.to_s : '') + line unless file1[:lines].include? line
			end
		end

		# CLI commands should return 0 if command finished succesful, and -1 if failed
		return 0
	rescue Exception => e
		puts "error = #{e}, backtrace = #{e.backtrace.join("\n")}"
		return -1
	end

	desc "Search by names in dir/contents of files", "find --dir --contents '/home' --name 'Diary'"
	long_desc <<-LONGDESC
	#{LONGDESC_FIND}
	LONGDESC
	option :count, :type => :boolean, :desc => 'Count of finded items', :banner => 'count',:aliases => '-c', :default => true
	option :name, :desc => 'Name of files to find', :banner => 'Name',:aliases => '-n', :required => true
	option :dir, :type => :boolean, :desc => 'Search only for folders and file names', :aliases => '-dir'
	option :contents, :type => :boolean, :desc => 'Search for containig items in files', :aliases => '-cs'
	def find( _path)
		@dir = {}
		@contents = {}
		@dir[:out] = []
		@contents[:out] = []
		@name = options[:name]
		@contents[:enable] = options[:contents]

		incr_search( _path)

		if options[:dir]
			puts "Dir:"
			puts @dir[:out].join("\n")
		end
		puts "*******************************************************" if options[:dir] && options[:contents]
		if options[:contents]
			puts "Into files:"
			puts @contents[:out].join("\n")
		end

		# CLI commands should return 0 if command finished succesful, and -1 if failed
		return 0
	rescue Exception => e
		puts "error = #{e}, backtrace = #{e.backtrace.join("\n")}"
		return -1
	end

	private
	def incr_search( path)
		# path = path[-1,1] == '/' ? path : path + '/'
		path = path[-1,1] == '\\' ? path : path + '\\'   # for Win

		Dir.foreach( path) do |file|
			@dir[:out] << path + file if file.include? @name
			incr_search( path + file) if file.strip[0,1] != '.' && File.directory?(path + file)

			if file.strip[0,1] != '.' && !File.directory?(path + file) && @contents[:enable]
				cnt = 0
				file = File.open(  path + file)
				while ( line = file.gets)
					cnt = cnt + 1
					@contents[:out] << path.to_s + file.to_s + "\t" + cnt.to_s + ': '+ line.to_s if line.include? @name
				end
				file.close
			end
		end
	end

end

Rgrep.start(ARGV)
