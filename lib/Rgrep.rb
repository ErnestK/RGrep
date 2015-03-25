# encoding: UTF-8
require "thor"
require "os"
require File.join(File.dirname(__FILE__), 'Rgrep', 'Description.rb')

class Rgrep < Thor
	include Description

	map "-l" => :list
	map "-d" => :diff
	map "-f" => :find

	desc "List all running_process", "list -n 'MySql' -gt 100"
	long_desc <<-LONGDESC
	#{LONGDESC_LIST}
	LONGDESC
	option :name, :desc => 'Name of running procces', :banner => 'Name',:aliases => '-n'
	option :less_than, :desc => 'Memory allocate, greater than param', :banner => 'Amount',:aliases => '-lt'
	option :greater_than, :desc => 'Memory allocate, less than param', :banner => 'Amount',:aliases => '-gt'
	def list
		@result = 0

		if OS.windows?
			_memory_index = 4
			list = `tasklist`
		elsif OS.linux? || OS.mac?
			_memory_index = 3
			list = %x(ps aux)
		end
		_name_index = 0
		outgoing = []
		is_header = true

		cnt = 0
		list.split("\n").each do  |str|
			outgoing << str if is_header
			is_header = false

			# is options disable or equal to parameters
			arr = str.split(' ')
			is_opt_name_valid = !options[:name] || arr[_name_index].to_s.include?( options[:name].to_s)
			is_opt_lt_valid = !options[:less_than] || options[:less_than].to_i > arr[_memory_index].to_i
			is_opt_gt_valid = !options[:greater_than] || options[:greater_than].to_i < arr[_memory_index].to_i

			if is_opt_name_valid && is_opt_lt_valid && is_opt_gt_valid
				cnt = cnt + 1
				outgoing << cnt.to_s + ":\t" + str
			end
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
	option :show_similar, :type => :boolean, :desc => 'Show similar lines instead differnece', :aliases => '-ss'
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
				puts cnt.to_s + ' ' + line if file2[:lines].include?( line)
			else
				puts cnt.to_s + ' ' + line unless file2[:lines].include?( line)
			end
		end

		cnt = 0
		puts "**************************************"
		puts "File: #{_file2}"
		file2[:lines].each do |line|
			cnt = cnt + 1      
			if options[:show_similar]
				puts cnt.to_s + ' ' + line if file1[:lines].include?( line)
			else
				puts cnt.to_s + ' ' + line unless file1[:lines].include?( line)
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
	option :name, :desc => 'Name of files to find', :banner => 'Name',:aliases => '-n', :required => true
	option :contents, :type => :boolean, :desc => 'Search for containig items in files', :aliases => '-cs'
	def find( _path)
		@dir = {}
		@contents = {}
		@dir[:out] = []
		@contents[:out] = []
		@name = options[:name]
		@contents[:enable] = options[:contents]

		incr_search( _path)

		puts "Dir:"
		puts @dir[:out].join("\n")

		puts "*******************************************************" if options[:contents]
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
		if OS.windows?
			path = path[-1,1] == '\\' ? path : path + '\\'   # for Win
		elsif OS.linux? || OS.mac?
			path = path[-1,1] == '/' ? path : path + '/'
		end

		Dir.foreach( path) do |file_name|
			@dir[:out] << path + file_name if file_name.include? @name
			incr_search( path + file_name) if file_name.strip[0,1] != '.' && File.directory?(path + file_name)

			if file_name.strip[0,1] != '.' && !File.directory?(path + file_name) && @contents[:enable]
				cnt = 0
				file = File.open(  path + file_name)
				while ( line = file.gets)
					cnt = cnt + 1
					@contents[:out] << path.to_s + file_name.to_s + "\t" + cnt.to_s + ': '+ line.to_s if line.include? @name
				end
				file.close
			end
		end
	end
end

Rgrep.start(ARGV)
