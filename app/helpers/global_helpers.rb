module Merb
  module GlobalHelpers
    include HTMLDiff
    def show_time_ago(date)
      "<acronym title=\"#{date.strftime '%A, %B %d, %Y at %I:%M %p'}\">#{time_ago_in_words date}</acronym> ago"
    end
    
    def display_standard_messages
      if message[:notice]
        display_msg, level = message[:notice], 'notice'
      elsif message[:warning]
        display_msg, level = message[:warning], 'warning'
      elsif message[:error]
        level = 'error'
#        if message[:error].instance_of? ActiveRecord::Errors
#          display_msg = message
#          display_msg << activerecord_error_list(message[:error])
#        else
          display_msg = message[:error]
#        end
      else
        return
      end
      tag :div, display_msg, :class => "message #{level}"
    end
  end
end
