# encoding: utf-8

require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe Rgrep do
	CLI_VALID_RESPONSE = 0
	CLI_FAIL_RESPONSE = -1

	PATH = File.join(File.dirname(__FILE__), '/','blueprint', '/')

	describe "list operation" do
		context 'correct when' do
			it 'run normally' do
				expect(Rgrep.start(["list"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with params - name' do
				expect(Rgrep.start(["list","--name", "chr"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with params - name and greater-than' do
				expect(Rgrep.start(["list", "--name", "chr", "--greater-than", "100"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with params - name and greater-than and less-than' do
				expect(Rgrep.start(["list", "--name", "chr", "--greater-than", "100", "--less-than", "500"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
		end

		context 'failed when' do
			# TODO: need additioanl time because we should override method from gem Thor
		end
	end

	describe "diff operation" do
		context 'correct when' do
			it 'run normally' do
				expect(Rgrep.start(["diff", "#{PATH}1.txt", "#{PATH}2.txt"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with argument show_similar' do
				expect(Rgrep.start(["diff", "#{PATH}1.txt", "#{PATH}2.txt", "--show_similar"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
		end

		context 'failed when' do
			# TODO: need additioanl time because we should override method from gem Thor
		end
	end

	describe "find operation" do
		context 'correct when' do
			it 'run with arg name' do
				expect(Rgrep.start(["find", PATH.to_s, "--name", "Diary"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with arg name and show dir' do
				expect(Rgrep.start(["find", PATH.to_s, "--name", "Diary", "--dir"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
			it 'run with arg name and show dir and contents' do
				expect(Rgrep.start(["find", PATH.to_s, "--name", "Diary", "--dir", "--contents"]).to_i).to eq( CLI_VALID_RESPONSE)
			end
		end

		context 'failed when' do
			# TODO: need additioanl time because we should override method from gem Thor
		end
	end
end
