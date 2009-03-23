##########################################
#                                        #
#   Validations for profane language     #
#   Michael J. Edgar                     #
#   OurGreen, Inc.                       #
#   1/17/2009                            #
#                                        #
##########################################

require_dependency File.join(File.dirname(__FILE__), 'lib/active_record/validations/validates_not_profane')
ActiveRecord::Base.send :include, ActiveRecord::Validations::NotProfane
