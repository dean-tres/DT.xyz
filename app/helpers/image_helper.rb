# frozen_string_literal: true

module ImageHelper
  def svg_tag(path, **params)
    abs_path = "#{Rails.root}/public/assets/images/#{path}#{'.svg' unless path.end_with('.svg')}"
    return '[svg not found]' unless File.exist?(abs_path)

    svg_match_data = File.read(abs_path).match(MATCH_SVG)
    return '[svg invalid]' unless svg_match_data

    svg_attribute_data = svg_match_data[:opening_tag]
                         .scan(MATCH_ATTR)
                         .map { |key, _, val| [key, val] }
                         .to_h
                         .with_indifferent_access.merge(params)

    content_tag(:svg, svg_attribute_data) do
      svg_match_data[:contents].html_safe
    end
  end
end
