class PokedexGo::CLI
    CLR = {
        black: "\u001b[38;5;136m",
        red: "\u001b[31m",
        green: "\u001b[32;1m",
        yellow: "\u001b[33;1m",
        blue: "\u001b[34m",
        magenta: "\u001b[35m",
        cyan: "\u001b[36m",
        white: "\u001b[37m",
        reset: "\u001b[0m"
    }

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
        puts " ___________________________________________________________________"
        puts "|\\__________________________MAIN_MENU______________________________/|"
        puts "|                                                                   |"
        puts "|             1: List all available Pokemon                         |"
        puts "|             2: List all Pokemon of a specific type                |"
        puts "|             3: View individual Pokemon profile                    |"
        puts "|___________________________________________________________________|"
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
        puts " ___________________________________________________________________"
        puts "|\\__________________________TYPE_MENU______________________________/|"
        puts "|                                                                   |"
        puts "| #{CLR[:green]}Bug        #{CLR[:magenta]}Dark       #{CLR[:white]}Dragon     #{CLR[:yellow]}Electric     #{CLR[:cyan]}Fairy      #{CLR[:red]}Fighting |"
        puts "| #{CLR[:red]}Fire       #{CLR[:white]}Flying     #{CLR[:magenta]}Ghost      #{CLR[:green]}Grass        #{CLR[:black]}Ground     #{CLR[:cyan]}Ice      |"
        puts "| #{CLR[:white]}Normal     #{CLR[:magenta]}Poison     #{CLR[:red]}Psychic    #{CLR[:black]}Rock         #{CLR[:white]}Steel      #{CLR[:blue]}Water#{CLR[:reset]}    |"
        puts "|___________________________________________________________________|"
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

        puts " ____________________________________________________________________"
        print "|\\_#"
        (3 - pokemon.number.to_s.length).times {print "0"}
        print "#{pokemon.number}:#{pokemon.name}"
        (26 - pokemon.name.length).times {print "_"}
        puts "/|\\_________LEAGUE_RANKS__________/|"
        print "| Type:     #{pokemon.type}"
        (23 - pokemon.type.length).times {print " "}
        puts "| Great  League: 4.5 / 5          |"
        puts "| Max CP:   #{pokemon.max_cp}                   | Ultra  League: 3.5 / 5          |"
        puts "| Attack:   #{pokemon.attack}                    | Master League: 2.0 / 5          |"
        puts "| Defense:  #{pokemon.defense}                    |                                 |"
        puts "| Stamina:  #{pokemon.stamina}                    |                                 |"
        puts "|__________________________________|_________________________________|"
        puts "|\\___________VULNERABLE___________/|\\__________RESISTANT____________/|"
        puts "| Fire:     160%                   | Electric:  62.5%                |"
        puts "| Flying:   160%                   | Fairy:     62.5%                |"
        puts "| Ice:      160%                   | Fighting:  62.5%                |"
        puts "| Psychic:  160%                   | Grass:     39.1%                |"
        puts "|                                  | Water:     62.5%                |"
        puts "|__________________________________|_________________________________|"


    end
end
