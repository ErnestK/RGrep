# ErnestK - Rgrep

## Introduction

A Ruby gem, just for showing on interview. 
This is alternative for Bash grep, but in that library implemented only 3 most common operations.

### Features
When I develop gem I wish to implement really CLI commands like true "grep".
Thats why I used gem "thor", which help me with that.
Now we can call commands from console and pass arguments. 
Also we can pass multipule arguments - I detailed will described it below in section "Usage".
You can see all commands in console:
``` bash
cd lib
ruby Rgrep.rb --help
```

Some problems coming with that gem:) cause his dont have stable version yet.
As an example I cant write whole spec test like I wont - I cant write section "failed when", 
because I should to rewrite some methods in thor gems. 
TODO: as fast as I can find some time:)

Also I used gem "os" which help me works correct on Windows/Mac/Linux.
This is great gem - really love it. 

### Installing 
You can simple install gem by command:
``` bash
gem install Rgrep
```
after that you can check 
in irb:
``` ruby
irb(main):002:0> Rgrep.start(["--help"])
Commands:
  irb Difference between two files                              # diff file1 ...
  irb List all running_process                                  # list -n 'My...
  irb Search by names in dir/contents of files -n, --name=Name  # find --dir ...
  irb help [COMMAND]                                            # Describe av...
=> {}
irb(main):003:0>
```

### Notes

- Gem works correct on Windows, Mac and Linux.
- You should have ruby > 1.9.
- Gems dependency( of course in gemspec also): thor, os, rspec.

## Usage
In that gem was been implemented three operations that inspired by work with "grep".
### LIST:
Inspired by "ps aux | grep" - Its not really grep fucntions, but most users common used grep like that, 
thats why I implemented fuction "list".

#### Without arguments:
``` bash
cd lib
ruby Rgrep.rb list
```
or on ruby 
``` ruby
Rgrep.start(["list"])
```

This is equivalent "ps aux" in Linux/Mac and "tasklist" in Windows.
operations list, like all CLI commands, have parameters: name, greater-than and less-than.

##### --name
Show all runing process with name that we passed in arguments:
``` bash
ruby Rgrep.rb list --name chrome
```
or on ruby 
``` ruby
Rgrep.start(["list","--name","chrome"])
```
we also can just pass only part of word.
``` bash
cd lib
ruby Rgrep.rb list --name chr
```
or on ruby 
``` ruby
Rgrep.start(["list","--name","chr"])
```

##### --greater_than
Show all runing process that allocate greater than <params> memory:
``` bash
ruby Rgrep.rb list --greater-than 100
```
or on ruby 
``` ruby
Rgrep.start(["list","--greater-than","100"])
```

##### --less_than
Show all runing process that allocate less than <params> memory:
``` bash
ruby Rgrep.rb list --less-than 500
```
or on ruby 
``` ruby
Rgrep.start(["list","--less-than","500"])
```

##### combinig parameters:
You can combine all parameters:
``` bash
ruby Rgrep.rb list --name chr --less-than 500 --greater-than 100
```
or on ruby 
``` ruby
Rgrep.start(["list","--name","chr","--less-than","500","--greater-than","100"])
```

example result:
``` bash
1:      chrome.exe                    4220 Console                    1   205 440 КБ
2:      chrome.exe                    3672 Console                    1   159 148 КБ
3:      chrome.exe                    4972 Console                    1   107 756 КБ
4:      chrome.exe                    3800 Console                    1   105 880 КБ
5:      chrome.exe                    6324 Console                    1   135 860 КБ
6:      chrome.exe                    7456 Console                    1   104 260 КБ
7:      chrome.exe                    5084 Console                    1   107 396 КБ
```

### DIFF:
Inspired by "grep -f file1 file2" - used to find difference between two files.

#### Without arguments:
In common case "diff" shows difference lines between two files. 
In 1 block - show lines that we have only in first file, and in other only lines from second files
``` bash
cd lib
ruby Rgrep.rb diff /home/Documents/1.txt /home/Documents/2.txt
```
or on ruby 
``` ruby
Rgrep.start(["diff","/home/Documents/1.txt","/home/Documents/2.txt"])
```

output example:
``` bash
File: /home/Documents/1.txt
**************************************
File: /home/Documents/2.txt
2: different line
```

##### --show_similar
Show similar lines instead different.
``` bash
ruby Rgrep.rb diff /home/Documents/1.txt /home/Documents/1.txt --show_similar
```
or on ruby 
``` ruby
Rgrep.start(["diff","/home/Documents/1.txt","/home/Documents/2.txt","--show_similar"])
```

### FIND:
Inspired by simple "grep" - search for files and for contents in file.

#### Without arguments:
Search only for file names or directory names, not for contents.
``` bash
cd lib
ruby Rgrep.rb find /home/Documents --name Diary 
```
or on ruby 
``` ruby
Rgrep.start(["find","/home/Documents","Diary"])
```

output example:
``` bash
Dir:
/home/Documents/TestGit/TestGit/Diary.txt
/home/Documents/YAFU/app/Diary.txt
```

##### --contents
In additionally search for the contents.
Shows also nuber of lines and file.

``` bash
ruby Rgrep.rb find /home/Documents --name Diary --contents
```
or on ruby 
``` ruby
Rgrep.start(["find","/home/Documents","Diary","--contents"])
```

output example:
``` bash
Dir:
/home/Documents/TestGit/TestGit/Diary.txt
/home/Documents/YAFU/app/Diary.txt
*******************************************************
Into files:
/home/Documents/Rgrep/lib/Rgrep.rb            104:   desc "Search by names in dir/contents of  files", "find --dir --contents '/home' --name 'Diary'"
/home/Documents/Rgrep/spec/rgrep_spec.rb      50: expect(Rgrep.start(["find", PATH.to_s, "--name", "Diary"]).to_i).to eq( CLI_VALID_RESPONSE)
/home/Documents/Rgrep/spec/rgrep_spec.rb      53: expect(Rgrep.start(["find", PATH.to_s, "--name", "Diary", "--contents"]).to_i).to eq( CLI_VALID_RESPONSE)
/home/Documents/TestGit/TestGit/Diary.txt     5: Diary for test
```

## Tests

Off course I developed test using "rspec" for gem.
You can run it:
``` bash
cd spec
rspec rgrep_spec.rb
```
output example:
``` bash
.

Finished in 0.42 seconds (files took 0.54 seconds to load)
8 examples, 0 failures
```
