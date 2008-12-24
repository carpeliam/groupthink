module Merb
  module GlobalHelpers
    include HTMLDiff

    def current_page?(options)
      url_string = CGI.escapeHTML(url(options))
      # We ignore any extra parameters in the request_uri if the
      # submitted url doesn't have any either.  This lets the function
      # work with things like ?order=asc
      if url_string.index("?")
        request_uri = request.uri
      else
        request_uri = request.uri.split('?').first
      end
      if url_string =~ /^\w+:\/\//
        url_string == "#{request.protocol}#{request.host}#{request_uri}"
      else
        url_string == request_uri
      end
    end

    def link_to_unless(condition, name, url = '', options = {}, &block)
      if condition
        if block_given?
          block.arity <= 1 ? yield(name) : yield(name, options, html_options)
        else
          name
        end
      else
        link_to(name, url, options)
      end
    end

    def link_to_unless_current(name, url = '', options = {}, &block)
      link_to_unless current_page?(options), name, url, options, &block
    end

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
      tag :div, h(display_msg), :class => "message #{level}"
    end
  end
end

