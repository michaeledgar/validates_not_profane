##########################################
#                                        #
#   Validations for profane language     #
#   Michael J. Edgar                     #
#   OurGreen, Inc.                       #
#   1/17/2009                            #
#                                        #
##########################################

module OurGreen
  module Validations
    module NotProfane
      ##
      # Add these methods to the ActiveRecord::Base class
      #
      def self.included(base)
        base.extend ClassMethods
      end
      
      ##
      # methods to be added to ActiveRecord
      #
      module ClassMethods
        ##
        # the message to be displayed to the user for using naughty words
        #
        @@is_profane_message = 'must not contain any vulgar words'
        ##
        # regex to check for bad words. We can expand this to a method that
        # scans a dictionary later. for now, let's get the real bad words out.
        #
        @@is_profane_wordlist  = /fuck|shit|cunt|nigger|asshole|titties|faggot/ #most obvious ones off the top of my head
        
        ##
        # class method that enables profanity validation.
        # attr_names = attributes to filter
        # also takes a hash as configuration. Options:
        #    :label   =   Name of field to display instead of the field's name itself
        #                 (eg :label => "URL" instead of displaying "permalink")
        #
        # The core of this code comes from the ActiveRecord validations.rb file,
        # courtesy of David Heinemeier Hansson. Thanks dude.
        def validates_not_profane(*attr_names)
          configuration = { :message   => @@is_profane_message }
          configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
          
          # let's check for that label parameter
          addName = false
          if configuration.has_key?(:label)
              msg_string = "#{configuration[:label]} #{configuration[:message]}"
              addName = false
          else
              msg_string = "#{configuration[:message]}"
              addName = true
          end
          configuration.store(:message, msg_string)
          configuration.delete(:label)
          
          # ok now we do real validation. validates_each is a helper method in validations
          # that will run our validation on the list of attributes and our config.
          
          validates_each(attr_names, configuration) do |record, attr_name, value|
            record.errors.add(attr_name, configuration[:message]) if addName && value =~ @@is_profane_wordlist
            record.errors.add_to_base(configuration[:message])    if !addName && value =~ @@is_profane_wordlist
            
          end
        end
        
      end
      # end ClassMethods
      
    end
  end
end
