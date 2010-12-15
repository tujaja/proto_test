# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

raw_config = File.read(RAILS_ROOT + "/config/config.yml")
APP_CONFIG = YAML.load(raw_config)[RAILS_ENV]


Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  #config.active_record.observers = :user_observer
  config.active_record.observers = :order_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Tokyo'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.active_record.timestamped_migrations = false
end


$KCODE = 'u'
require 'jcode'


# images
require 'pathname'
require 'tempfile'
require 'RMagick'
require 'base64'


require 'will_paginate'

module WillPaginate
  module ViewHelpers
    def page_entries_info collection, options = {}
      if collection.size == 0
        return '検索結果 0 件'
      else
        %{<b>%d</b> 件中 <b>%d&nbsp;-&nbsp;%d</b> 件目を表示} % [
          collection.total_entries,
          collection.offset + 1,
          collection.offset + collection.length
        ]
      end
    end
  end

  class MyLinkRenderer < LinkRenderer
    def to_html
      links = @options[:page_links] ? windowed_links : []
      # previous/next buttons
      links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
      links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
      
      html = links.join(@options[:separator])
      html = @template.content_tag(:ul, html)
      @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
    end
    protected

      def windowed_links
        prev = nil
        per_page = @collection.per_page

        visible_page_numbers.inject [] do |links, n|
          # detect gaps:
          if prev and n > prev + 1
            links << @template.content_tag(:li, gap_marker)
          end

          head = (n-1)*per_page+1
          tail = n == total_pages ? @collection.total_entries : n*per_page
          text = head == tail ? "#{head}" : "#{head}-#{tail}"

          links << page_link_or_span(n, 'current', text)
          prev = n
          links
        end
      end

      def visible_page_numbers
        inner_window, outer_window = @options[:inner_window].to_i, @options[:outer_window].to_i

        window_from = current_page - inner_window
        window_to = current_page + inner_window


        # adjust lower or upper limit if other is out of bounds
        if window_to > total_pages
          window_from -= window_to - total_pages
          window_to = total_pages
        end
        if window_from < 1
          window_to += 1 - window_from
          window_from = 1
          window_to = total_pages if window_to > total_pages
        end

        visible   = (1..total_pages).to_a
        left_gap  = (2 + outer_window)...window_from
        right_gap = (window_to + 1)...(total_pages - outer_window)
        visible  -= left_gap.to_a  if left_gap.last - left_gap.first >= 1
        visible  -= right_gap.to_a if right_gap.last - right_gap.first >= 1

        visible
      end


      def page_link_or_span(page, span_class, text = nil)
        text ||= page.to_s
        if page and page != current_page
          classnames = span_class && span_class.index(' ') && span_class.split(' ', 2).last
          page_link page, text, :rel => rel_value(page), :class => classnames
        else
          page_span page, text, :class => span_class if page == current_page
        end
      end

      def page_link(page, text, attributes = {})
        @template.content_tag( :li,
          (@template.link_to text, url_for(page), attributes))
      end

      def page_span(page, text, attributes = {})
        @template.content_tag( :li,
          (@template.content_tag :span, text, attributes))
      end

  end


end




p '==============================================='
p 'RAILS BOOTING'
p '==============================================='

