class PokedexGo::Scraper

    def self.get_page(url)
        return Nokogiri::HTML(open(url))
    end

    def self.scrape_pokemon_index()
        return get_page("https://gamepress.gg/pokemongo/pokemon-list").css(".pokemon-row")
    end
    
    def self.create_pokemon_from_index()
        scrape_pokemon_index().each do |entry|
            attributes = {
                name: entry.attribute("data-name").value,
                gen: entry.attribute("data-gen").value,
                buddy_dist: entry.attribute("data-buddy").value,
                egg: entry.attribute("data-egg").value,
                evo_cost: entry.attribute("data-candy").value,
                new_move_cost: entry.attribute("data-charge2").value,
                number: entry.attribute("data-id").value,
                stamina: entry.attribute("data-sta").value,
                attack: entry.attribute("data-atk").value,
                defense: entry.attribute("data-def").value,
                max_cp: entry.attribute("data-cp").value,
                overall_rating: entry.attribute("data-rating").value,
                type: entry.attribute("data-type").value,
                profile_url: entry.css("td a").first.attribute("href").value,
            }
            Pokemon.new(attributes)
        end
    end
end
