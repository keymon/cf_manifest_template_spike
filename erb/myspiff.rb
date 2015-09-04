#!/usr/bin/ruby
require 'yaml'
require 'deep_merge' # gem install deep_merge
require 'erb'

files=ARGV

FINAL_YAML={}
def search_yaml_values(key)
    def recursive_search(hash, keys)
        if keys == []
            hash
        else
            recursive_search(hash[keys[0]], keys[1..-1])
        end
    end
    recursive_search(FINAL_YAML, key.split('.'))
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
