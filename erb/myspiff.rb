#!/usr/bin/ruby
require 'yaml'
require 'deep_merge' # gem install deep_merge
require "erb" # gem install erb
require "dot_hash"

files=ARGV

FINAL_YAML={}
def yaml_values()
    FINAL_YAML.to_properties # use dot_hash
end

context_binding = binding()

files.each do |f|
    if f.downcase =~ /.*\.yml$/
        FINAL_YAML.deep_merge!(YAML.load(File.read(f)))
    elsif f.downcase =~ /.*\.yml\.erb$/
        template = ERB.new(File.read(f))
        FINAL_YAML.deep_merge!(YAML.load(template.result(context_binding)))
    elsif f.downcase =~ /.*.rb$/
        eval(File.read(f), context_binding)
    else
        raise "Unknown file type #{f}"
    end
end

puts FINAL_YAML.to_yaml
