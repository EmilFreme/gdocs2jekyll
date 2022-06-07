# frozen_string_literal: true

require_relative "gdocs2jekyll/version"
require 'http'
require 'nokogiri'
require 'pandoc-ruby'
require 'cgi'

module Jekyll
  class GDocsToJekyll < Liquid::Tag

    def initialize(tag_name, doc_id, token)
      super
      @docId = doc_id.rstrip.lstrip
    end

    def render(context)
      gDocsURL = "https://www.googleapis.com/drive/v3/files/#{@docId}/export"
      params = {
        :mimeType => "text/html",
        :key => ENV["GOOGLE_DRIVE_API_KEY"]
      }
      res = HTTP.get(gDocsURL, :params => params)


      if res.code != 200
        "#{res.to_s()}"
        return
      end

      resBody = res.body.to_s()
      parsedHTML = Nokogiri::HTML5(resBody)

      parsedHTML.search("*").each do |node|
        if node.name == "span" and node["style"]
          if node["style"].include? "font-style:italic"
            semantic_swap(parsedHTML, node, "i")
          elsif node["style"].include? "font-weight:700"
            semantic_swap(parsedHTML, node, "b")
          end
        end

        if not ["img", "a"].include? node.name
          node.keys.each do |attr|
            node.delete(attr)
          end
        end

        if node.name == "a" and not node["href"]
          parsedHTML.delete(node)
        end

        if(node.name == "span")
          unwrap(node)
        end
      end

        mddoc = PandocRuby.convert("#{parsedHTML.to_html}",
                                   from: :html,
                                   to: :markdown_mmd)
                          .force_encoding("UTF-8")

        "#{mddoc}"
    end

    def semantic_swap(doc, node, semantic_tag)
      semantic_node = doc.create_element(semantic_tag)
      semantic_node.inner_html = node.inner_html
      node.replace(semantic_node)
    end

    def unwrap(node)
      if node.parent
        node.replace(node.inner_html)
      end
    end

  end
end

Liquid::Template.register_tag('gdocs2jekyll', Jekyll::GDocsToJekyll)
