# rubocop:disable all

# TODO: note to self: this is some dirty dirty late night code. please fix this shitshow one day.
# why didnt i use a css preprocessor for this? because i said so....
# but also because i want to generate color combos based on contrast, among other things
# second-note-to-self: i obviously don't need this many colours, i'm being indecisive. cherry pick the ones needed

task :build_css do
  build_css
end

def build_css
  build_spacing_css
  build_colours_css
end

private

def build_spacing_css
  css_file = "#{Rails.root}/public/assets/css/spacing.css"
  css_buffer = []

  puts '-------------------------------------------'
  puts "> executing task #{__method__.to_s.upcase}"
  puts "> output file = #{css_file}"
  puts ''

  # BEGIN -------------------------------------

  spaces_whole = {
    '1' => '0.5rem',
    '2' => '1rem',
    '3' => '1.5rem',
    '4' => '2rem',
    '5' => '2.5rem'
  }

  spaces_half = {
    '0-25' => '0.125rem',
    '0-5' => '0.25rem',
    '1-5' => '0.75rem',
    '2-5' => '1.25rem',
    '3-5' => '1.75rem',
    '4-5' => '2.25rem'
  }

  merged_spaces = spaces_whole.merge(spaces_half)

  File.open(css_file, "w") do |f|
    # WRITE COMMENTS
    f.write "/* @ 16px/em\n" \
    "  SIZE      REMS      PX\n" \
    "  ----      ----      ----\n"
    merged_spaces.each do |name, size|
      f.write "  #{name.ljust(10,' ')}#{size.ljust(10,' ')}#{(16 * size.to_f).to_i}px\n"
    end
    f.write "*/\n\n"

    # FLEX
    f.write "/* Flex */\n"
    merged_spaces.each do |name, size|
      write_css(css_buffer, '.flex.gap', 'gap', name, size)
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"

    # MARGIN
    f.write "/* Margin */\n"
    write_css(css_buffer, '.mx-auto', %w[margin-left margin-right], '', 'auto')
    merged_spaces.each do |name, size|
      write_css(css_buffer, '.m', 'margin', name, size)
      write_css(css_buffer, '.ml', 'margin-left', name, size)
      write_css(css_buffer, '.mr', 'margin-right', name, size)
      write_css(css_buffer, '.mt', 'margin-top', name, size)
      write_css(css_buffer, '.mb', 'margin-bottom', name, size)
      write_css(css_buffer, '.mx', %w[margin-left margin-right], name, size)
      write_css(css_buffer, '.my', %w[margin-top margin-bottom], name, size)
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"

    # PADDING
    f.write "/* Padding */\n"
    merged_spaces.each do |name, size|
      write_css(css_buffer, '.p', 'padding', name, size)
      write_css(css_buffer, '.pl', 'padding-left', name, size)
      write_css(css_buffer, '.pr', 'padding-right', name, size)
      write_css(css_buffer, '.pt', 'padding-top', name, size)
      write_css(css_buffer, '.pb', 'padding-bottom', name, size)
      write_css(css_buffer, '.px', %w[padding-left padding-right], name, size)
      write_css(css_buffer, '.py', %w[padding-top padding-bottom], name, size)
    end
    write_arr(f, css_buffer, clear: true, sort: true)

  end

  # END ---------------------------------------

  puts "> #{__method__.to_s.upcase} Complete!"
end

def build_colours_css
  css_file = "#{Rails.root}/public/assets/css/colours.css"
  css_buffer = []

  puts '-------------------------------------------'
  puts "> executing task #{__method__.to_s.upcase}"
  puts "> output file = #{css_file}"
  puts ''

  # BEGIN -------------------------------------

  rgb_contrast_coefficients = {r: 213, g: 715, b: 72}
  min_contrast = 4.5 # 3.0 - 4.5

  colours = {
    'transparent' => '00000000',
    'white' => 'ffffff',
    'black' => '000000',

    'eerie-black' => '111313',
    'gunmetal' => '2c3138',
    'platinum' => 'e9eaec',
    'titanium-yellow' => 'd9d90b',
    'lemon' => 'fff70e',

    'red-salsa' => 'ff595e',
    'sunglow' => 'ffca3a',
    'yellow-green' => '8ac926',
    'green-blue-crayola' => '1982c4',
    'royal-purple' => '6a4c93',

    'athens-gray' => 'EEF0F3', # cultured
    'concrete' => 'F2F2F2', # cultured
    'crimson' => 'DC143C',
    'blue-sapphire' => '175579', # blue sapphire / chathams-blue
    'rhino' => '2E3F62', # dark cornflower blue
    'smoky-black' => '121212', # smoky black / cod-gray
    'bitter-lemon' => 'CAE00D',
    'starship' => 'ECF245', # maximum-yellow
    'sun' => 'FBAC13',
    'sunset-orange' => 'FE4C40', # tart orange
    'azure' => '315BA1',
    'raisin-black' => '2A2630', # raisin black / baltic-sea
    'cerise' => 'DE3163',
    'chicago' => '5D5C58', # davys grey
    'cinnabar' => 'E34234',
    'coral-red' => 'FF4040',
    'black-coffee' => '301F1E', # black coffee / cocoa-brown
    'sangria' => '92000A', # dark red
    'shark' => '25272C',
    'shiraz' => 'B20931',
    'alabaster' => 'EEEEE8', # alabaster / carrara
  }.map { |c, h| [c, h.ljust(8, 'f')] }.to_h.with_indifferent_access

  File.open(css_file, "w") do |f|
    # WRITE COMMENTS
    f.write "/* colour list\n" \
    "  NAME                HEX        RGBA                LUM\n" \
    "  ------------------  ---------  ------------------  ----\n"
    colours.each do |name, hex|
      colour_rgba = hex_rgba(hex)
      f.write "  #{name.ljust(20,' ')}##{hex.ljust(8, 'f').ljust(10,' ')}#{hex_rgba(hex, float_alpha: true).values.join(', ').ljust(20, ' ')}#{luminance(colour_rgba).round(3)}\n"
    end
    f.write "*/\n\n"

    f.write(":root {\n")
    colours.each do |name, hex|
      f.write "  --#{name}: ##{hex};\n"
    end
    f.write("}\n\n")

    # TEXT-COLOUR
    f.write "/* Text-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.text-', 'color', name, "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"
    # HOVER-TEXT-COLOUR
    f.write "/* Hover-text-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.hover-text-', 'color', "#{name}:hover", "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"

    # BG-COLOUR
    f.write "/* Background-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.bg-', 'background-color', name, "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"
    # HOVER-BG-COLOUR
    f.write "/* Hover-bg-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.hover-bg-', 'background-color', "#{name}:hover", "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"

    # BORDER-COLOUR
    f.write "/* Border-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.border-', 'border-color', name, "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"
    # HOVER-BORDER-COLOUR
    f.write "/* Hover-border-colour */\n"
    colours.each do |name, hex|
      write_css(css_buffer, '.hover-border-', 'border-color', "#{name}:hover", "var(--#{name})")
    end
    write_arr(f, css_buffer, clear: true, sort: true)
    f.write "\n"

    # GENERATE COLOR COMBOS, OBEY MINIMUM CONTRAST
    exclude_colours = ['transparent']
    f.write "/* Colour combinations, checked for minimum contrast ratio of #{min_contrast} */\n"
    colours.each do |first_colour, first_hex|
      next if exclude_colours.include?(first_colour)
      colours.each do |second_colour, second_hex|
        next if exclude_colours.include?(second_colour)
        next if first_colour == second_colour
        next if first_hex == second_hex
        contrast_value = contrast(hex_rgba(first_hex), hex_rgba(second_hex))
        if contrast_value < min_contrast
          puts "BAD contrast: #{first_colour} vs #{second_colour} = #{contrast_value}"
          next
        end

        puts "GOOD contrast: #{first_colour} vs #{second_colour} = #{contrast_value} - generating color combo .#{first_colour}-#{second_colour}"
        f.write ".#{first_colour}-#{second_colour} { color: var(--#{first_colour}); background-color: var(--#{second_colour}); } /* contrast: #{contrast_value.round(3)} */\n"
        f.write ".hover-#{first_colour}-#{second_colour}:hover { color: var(--#{first_colour}); background-color: var(--#{second_colour}); }\n\n"
      end
    end

    # SVG-COLOUR
    # TODO: finish me!

    # ICON-COLOUR
    # TODO: finish me!
  end

  css_file = "#{Rails.root}/public/colours.css.html"
  File.open(css_file, "w") do |f|
    f.write("<html>\n")
    f.write("<head>\n")
    f.write("<title>colour styles</title>\n")
    f.write("<link rel=\"stylesheet\" href=\"/assets/css/colours.css\">\n")
    f.write("</head>\n")
    f.write("<body>\n")

    exclude_colours = ['transparent']
    f.write "<h1>Colour combinations</h1>\n"
    colours.each do |first_colour, first_hex|
      next if exclude_colours.include?(first_colour)
      colours.each do |second_colour, second_hex|
        next if exclude_colours.include?(second_colour)
        next if first_colour == second_colour
        next if first_hex == second_hex
        contrast_value = contrast(hex_rgba(first_hex), hex_rgba(second_hex))
        next if contrast_value < min_contrast

        f.write("<span style=\"line-height:56px; margin: 8px; padding: 16px; font-size: 16px; border-radius: 8px; font-weight: 600; font-family: sans-serif;\" class=\"#{first_colour}-#{second_colour}\">.#{first_colour}-#{second_colour}</span>")
      end
    end

    f.write("</body>\n")
    f.write("</html>\n")
  end

  # END ---------------------------------------

  puts "> #{__method__.to_s.upcase} Complete!"
end

def write_css(buffer, selector, *attrib, name, value)
  attribs = attrib.flatten.map { |key| "#{key}: #{value}\;" }
  output = "#{selector}#{name} { #{attribs*' '} }\n"
  puts ">> #{output}"
  case
  when buffer.is_a?(Array) then buffer << output
  when buffer.is_a?(File) then f.write output
  end
end

def write_arr(file, buffer, clear: false, sort: false, uniq: false)
  buffer.sort! if sort
  buffer.uniq! if uniq
  file.write buffer.join
  buffer.clear if clear
end

def luminance(rgb)
  lum = rgb.map do |k, v|
    v /= 255.0
    v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4
  end
  lum[0]*0.2126 + lum[1]*0.7152 + lum[2]*0.0722
end

def contrast(first, second)
  pair = [luminance(first), luminance(second)]
  (pair.max + 0.05) / (pair.min + 0.05)
end

# convert a rgb/rgba hex string ie 'ff00ff' to a hash {r: 255, g: 0, b: 255, a: 255}
# if only rgb is provided, alpha will be set to 255 (100%)
def hex_rgba(hex_string, float_alpha: false)
  hex_string.ljust(8, 'f').scan(/../).each_with_index.map { |v, i| ['rgba'[i].to_sym, v.hex] }.to_h.with_indifferent_access.tap { |rgb| rgb[:a] /= 255.0 if float_alpha }
end

def hex_arr(colour)
  colour.scan(/../).map(&:hex)
end

# rubocop:enable all
