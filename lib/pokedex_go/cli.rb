class PokedexGo::CLI
    def self.call()
        #entrypoint
        welcome()
    end

    def self.welcome()
        #initial welcome message and creation of Pokemon index
        puts "Welcome to Pokedex Go: The World's Best Text-Based Pokemon Go Search Tool!"
        PokedexGo::Scraper.create_pokemon_from_index()
        main_menu()
    end

    def self.main_menu()
        #Root of menu system
        puts ".-=-=-=-=-=-=-=-=-=-=-=-=-=Main Menu=-=-=-=-=-=-=-=-=-=-=-=-=-=-."
        puts "|                                                               |"
        puts "| 1: List all available Pokemon                                 |"
        puts "| 2: List all Pokemon of a specific type                        |"
        puts "| 3: View individual Pokemon profile                            |"
        puts "|                                                               |"
        puts "`-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'"
        puts ""

        user_input = 0

        while user_input != 1 && user_input != 2 && user_input != 3
            print "Enter an option: "
            user_input = gets.chomp.to_i
            case user_input
            when 1
                list_all_pokemon()
                break
            when 2
                list_pokemon_of_type()
                break
            when 3
                view_pokemon_profile()
                break
            else
                puts "#{user_input} is an invalid selection"
            end
        end
    end

    def self.list_all_pokemon()
        #presents entire list of pokemon, broken up into segments
        PokedexGo::Pokemon.all.each do |pokemon|
            puts "#{pokemon.number}: #{pokemon.name}"
        end
        print "Select a Pokemon: "
        user_input = gets.chomp.to_i
        view_pokemon_profile(PokedexGo::Pokemon.all.detect{|mon| mon.number == user_input})
    end

    def self.list_pokemon_of_type()
        #lists all pokemon of given type
        puts ".-=-=-=-=-=-=-=-=-=-=-=-=-=Type Menu=-=-=-=-=-=-=-=-=-=-=-=-=-=-."
        puts "|                                                               |"
        puts "| Bug       Dark      Dragon     Electric    Fairy     Fighting |"
        puts "| Fire      Flying    Ghost      Grass       Ground    Ice      |"
        puts "| Normal    Poison    Psychic    Rock        Steel     Water    |"
        puts "|                                                               |"
        puts "`-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-'"
        puts ""

        user_input = "none"
        while !PokedexGo::Pokemon.types.include?(user_input)
            print "Enter a type: "
            user_input = gets.chomp
            if !PokedexGo::Pokemon.types.include?(user_input)
                puts "#{user_input} is an invalid selection"
            end
        end



        pokemon_of_type = PokedexGo::Pokemon.all.select do |pokemon|
            pokemon.type.include?(user_input)
        end

        pokemon_of_type.each do |mon|
            puts "#{mon.number}: #{mon.name} (#{mon.type})"
        end
        
        print "Select a Pokemon: "
        user_input = gets.chomp.to_i
        view_pokemon_profile(PokedexGo::Pokemon.all.detect{|mon| mon.number == user_input})
    end

    def self.view_pokemon_profile(pokemon)
        #view full profile of individual pokemon
        PokedexGo::Scraper.add_profile_stats(pokemon)
    end
end
