# Include hook code here
#require 'unique_tokenizer.rb'
ActiveRecord::Base.send :include, UniqueTokenizer
