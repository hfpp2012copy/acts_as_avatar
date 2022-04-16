# frozen_string_literal: true

require "loofah"

module ActsAsAvatar
  module Scrubber
    #
    # rails: sanitize(svg.to_s, scrubber: scrubber).html_safe
    #
    def sanitize(unsafe_xml)
      unsafe_xml = unsafe_xml.to_s
      unsafe_xml.force_encoding "UTF-8"
      return Loofah.xml_document(unsafe_xml).scrub!(scrubber).to_s if document?(unsafe_xml)

      Loofah.xml_fragment(unsafe_xml).scrub!(scrubber).to_s
    end

    private

    def scrubber
      Loofah::Scrubber.new do |node|
        node.remove if node.name == "script"
      end
    end

    def document?(unsafe)
      unsafe.include?("<?xml") || unsafe.include?("<!DOCTYPE")
    end
  end
end
