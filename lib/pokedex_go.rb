require "pokedex_go/version"

module PokedexGo
  class Error < StandardError; end
  
  require "pry"
  require "nokogiri"
  require "open-uri"

  require "pokedex_go/ascii_image_converter"
  require "pokedex_go/cli"
  require "pokedex_go/pokemon"
  require "pokedex_go/scraper"
end
