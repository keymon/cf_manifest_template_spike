#!/usr/bin/ruby
require 'yaml'
require 'deep_merge' # gem install deep_merge
require "erb" # gem install erb

yamls = []

files=ARGV

context_binding = binding()

files.each do |f|
    if f.downcase =~ /.*\.yml$/
        yamls << YAML.load(File.read(f))
    elsif f.downcase =~ /.*\.yml\.erb$/
        template = ERB.new(File.read(f))
        yamls << YAML.load(template.result(context_binding))
    elsif f.downcase =~ /.*.rb$/
        eval(File.read(f), context_binding)
    else
        raise "Unknown file type #{f}"
    end     
end

final_yaml={}

yamls.each { |y| 
    final_yaml.deep_merge!(y)
} 

puts final_yaml.to_yaml
