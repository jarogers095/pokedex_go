require_relative "pokedex_go/version"

module PokedexGo
  class Error < StandardError; end
  
  require "nokogiri"
  require "open-uri"

  require_relative "pokedex_go/adv_cli"
  require_relative "pokedex_go/ascii_image_converter"
  require_relative "pokedex_go/cli"
  require_relative "pokedex_go/pokemon"
  require_relative "pokedex_go/scraper"
end
