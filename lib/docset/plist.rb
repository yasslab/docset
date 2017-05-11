require 'erb'

module Docset
  class Plist
    def initialize(id:, name:, family:, js: true)
      @id = id
      @name = name
      @family = family
      @js = js
    end

    def to_s
      ERB.new(template, nil, '-').result(binding)
    end

    private

    def template
      <<~TEMPLATE
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      	<key>CFBundleIdentifier</key>
      	<string><%= @id %></string>
      	<key>CFBundleName</key>
      	<string><%= @name %></string>
      	<key>DocSetPlatformFamily</key>
      	<string><%= @family %></string>
      	<key>isDashDocset</key>
      	<true/>
      	<%- if @js -%>
      	<key>isJavaScriptEnabled</key>
      	<true/>
      	<%- end -%>
      </dict>
      </plist>
      TEMPLATE
    end
  end
end
