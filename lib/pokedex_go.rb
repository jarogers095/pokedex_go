require_relative "pokedex_go/version"


module PokedexGo
  class Error < StandardError; end
  
  require "nokogiri"
  require "open-uri"

  require_relative "concerns/sortable"
  require_relative "pokedex_go/cli"
  require_relative "pokedex_go/pokemon"
  require_relative "pokedex_go/scraper"
end
