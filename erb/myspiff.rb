#!/usr/bin/ruby
require 'yaml'
require 'deep_merge' # gem install deep_merge
require 'erb'

files=ARGV

# Keeps the complete final YAML file
FINAL_YAML={}


# Allows search for existing values in the YAML structure
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

# Executes the string interpolation/expansion in a structure hash
def perform_yaml_interpolation(structure, interpolation_binding)
    case structure
    when String
        if structure =~ /^\#\{(.*)\}$/
            # If there is only this interpolation, expand it and insert the value
            eval $1
        else
            # If not, expand as a string
            eval "\"#{structure}\"" # Don't ask, it works.... %-)
        end
    when Hash
        structure.each { |k, v|
            structure[k] = perform_yaml_interpolation(v, interpolation_binding)
        }
    else
        structure
    end
end

# Get the current binding
context_binding = binding()

files.each do |f|
    if f.downcase =~ /.*\.yml$/
        # A simple yaml, just gets merged
        FINAL_YAML.deep_merge!(YAML.load(File.read(f)))
    elsif f.downcase =~ /.*\.yml\.erb$/
        # a erb, we compile it and merge it
        template = ERB.new(File.read(f))
        FINAL_YAML.deep_merge!(YAML.load(template.result(context_binding)))
    elsif f.downcase =~ /.*.rb$/
        # a ruby file, just evalueate it
        eval(File.read(f), context_binding)
    else
        raise "Unknown file type #{f}"
    end
end

perform_yaml_interpolation(FINAL_YAML, context_binding)

puts FINAL_YAML.to_yaml
