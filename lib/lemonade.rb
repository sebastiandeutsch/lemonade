module Lemonade
  module SassExtensions
    module Functions
    end
  end
end

require 'rubygems'
require 'compass'
require 'sass/plugin'
require 'rmagick'
require File.dirname(__FILE__) + '/lemonade/sass_extensions/functions/lemonade'
require File.dirname(__FILE__) + '/lemonade/lemonade'

module Sass::Script::Functions
  include Lemonade::SassExtensions::Functions::Lemonade
end

module Compass
  class Compiler
    alias_method :compile_without_lemonade, :compile
    def compile(sass_filename, css_filename)
      compile_without_lemonade sass_filename, css_filename
      Lemonade::generate_sprites
    end
  end
end

module Sass
  module Plugin
    alias_method :update_stylesheets_without_lemonade, :update_stylesheets
    def update_stylesheets
      if update_stylesheets_without_lemonade
        Lemonade::generate_sprites
      end
    end
  end
end

module Sass
  class Engine
    alias_method :render_without_lemonade, :render
    def render
      if result = render_without_lemonade
        Lemonade::generate_sprites
        result
      end
    end
    alias_method :to_css, :render
  end
end
