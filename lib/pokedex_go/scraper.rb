class PokedexGo::Scraper

    def self.get_page(url)
        return Nokogiri::HTML(open(url))
    end

    def self.scrape_pokemon_index()
        return get_page("https://gamepress.gg/pokemongo/pokemon-list").css(".pokemon-row")
    end

    def self.scrape_pokemon_profile(profile_url)
        return get_page("https://gamepress.gg#{profile_url}")
    end
        
    def self.create_pokemon_from_index()
        scrape_pokemon_index().each do |entry|
            attributes = {
                number: entry.attribute("data-id").value.to_i,
                name: entry.attribute("data-name").value,
                gen: entry.attribute("data-gen").value,
                buddy_dist: entry.attribute("data-buddy").value,
                egg: entry.attribute("data-egg").value,
                evo_cost: entry.attribute("data-candy").value,
                new_move_cost: entry.attribute("data-charge2").value,
                stamina: entry.attribute("data-sta").value,
                attack: entry.attribute("data-atk").value,
                defense: entry.attribute("data-def").value,
                max_cp: entry.attribute("data-cp").value,
                pve_rating: entry.attribute("data-rating").value,
                type: entry.attribute("data-type").value,
                profile_url: entry.css("td a").first.attribute("href").value,
            }
            PokedexGo::Pokemon.new(attributes)
        end
        PokedexGo::Pokemon.sort("number")
    end

    def self.add_profile_stats(pokemon)
        profile_page = scrape_pokemon_profile(pokemon.profile_url)

        pve_movesets_parsed = []
        pvp_movesets_parsed = []
        weaknesses_parsed = []
        resistances_parsed = []

        pve_movesets_html = profile_page.css(".pve-section .views-element-container .view .view-content .views-table tbody tr")
        pve_movesets_html.each do |moveset|
            moveset_hash = {
                quick: moveset.css(".views-field-views-conditional-field div a div span").text,
                charge: moveset.css(".views-field-views-conditional-field-1 div a div span").text,
                atk_grade: moveset.css(".views-field-field-offensive-moveset-grade div").text,
                def_grade: moveset.css(".views-field-field-defensive-moveset-grade div").text
            }
            pve_movesets_parsed << moveset_hash
        end

        pvp_movesets_html = profile_page.css(".pvp-section .views-element-container .view .view-content .views-table tbody tr")
        pvp_movesets_html.each do |moveset|
            moveset_hash = {
                quick: moveset.css(".views-field-views-conditional-field div a div span").text,
                charge_1: moveset.css(".views-field-views-conditional-field-1 div a div span")[0].text,
                charge_2: moveset.css(".views-field-views-conditional-field-1 div a div span")[1].text,
                grade: moveset.css(".views-field-field-offensive-moveset-grade div").text
            }
            pvp_movesets_parsed << moveset_hash
        end

        weaknesses_html = profile_page.css("#weak-table tr")
        weaknesses_html.each do |weakness|
            weakness_hash = {
                type: File.basename(weakness.css(".type-img-cell img").attribute("src").value).chomp(".gif").capitalize,
                amount: weakness.css(".type-weak-value").text
            }
            weaknesses_parsed << weakness_hash
        end

        resistances_html = profile_page.css("#resist-table tr")
        resistances_html.each do |resistance|
            resistance_hash = {
                type: File.basename(resistance.css(".type-img-cell img").attribute("src").value).chomp(".gif").capitalize,
                amount: resistance.css(".type-resist-value").text
            }
            resistances_parsed << resistance_hash
        end

        profile_stats = {
            weight: profile_page.css(".pokemon-weight").text.strip().split("\n")[0],
            height: profile_page.css(".pokemon-height").text.strip().split("\n")[0],
            fast_moves: profile_page.css(".field--name-field-primary-moves .pokemon-page-moves-item"),
            charge_moves: profile_page.css(".field--name-field-secondary-moves .pokemon-page-moves-item"),
            pve_movesets: pve_movesets_parsed,
            pvp_movesets: pvp_movesets_parsed,
            female_ratio: profile_page.css(".female-percentage").text.strip(),
            weaknesses: weaknesses_parsed,
            resistances: resistances_parsed
        }

        pokemon.add_stats(profile_stats)
        return pokemon
    end
end
