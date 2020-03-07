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
        puts "|             2: Search by Pokemon type                             |"
        puts "|             3: Search by Pokemon name or number                   |"
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
                search_by_name_or_number()
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
        puts "| #{CLR[:green]}Bug        #{CLR[:magenta]}Dark       #{CLR[:white]}Dragon     #{CLR[:yellow]}Electric     #{CLR[:cyan]}Fairy      #{CLR[:red]}Fighting#{CLR[:reset]} |"
        puts "| #{CLR[:red]}Fire       #{CLR[:white]}Flying     #{CLR[:magenta]}Ghost      #{CLR[:green]}Grass        #{CLR[:black]}Ground     #{CLR[:cyan]}Ice#{CLR[:reset]}      |"
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
        
        print "Enter a Pokemon's NUMBER to see their profile: "
        user_input = gets.chomp.to_i
        view_pokemon_profile(PokedexGo::Pokemon.all.detect{|mon| mon.number == user_input})
    end

    def self.search_by_name_or_number()

    end

    def self.view_pokemon_profile(pokemon)
        #view full profile of individual pokemon
        PokedexGo::Scraper.add_profile_stats(pokemon)

        puts " ____________________________________________________________________"
        print "|\\____________POKEMON_____________"
        puts "/|\\_________LEAGUE_RANKS__________/|"
        print "| #"
        (3 - pokemon.number.to_s.length).times {print "0"}
        print "#{pokemon.number}"
        (32 - pokemon.number.to_s.length).times {print " "}
        print "| Great  League:  #{pokemon.ratings[:great_league]}"
        (16 - pokemon.ratings[:great_league].length).times {print " "}
        puts "|"
        print "| Name: #{pokemon.name}                   | Ultra  League:  #{pokemon.ratings[:ultra_league]}"
        (16 - pokemon.ratings[:ultra_league].length).times {print " "}
        puts "|"
        print "| Attack:   #{pokemon.attack}                    | Master League:  #{pokemon.ratings[:master_league]}"
        (16 - pokemon.ratings[:master_league].length).times {print " "}
        puts "|"
        puts "| Defense:  #{pokemon.defense}                    |                                 |"
        puts "| Stamina:  #{pokemon.stamina}                    |                                 |"
        puts "|__________________________________|_________________________________|"
        puts "|\\___________VULNERABLE___________/|\\__________RESISTANT____________/|"
        pokemon.weaknesses.each_with_index do |weakness, index|
            print "| #{weakness[:type]}:"
            (9 - weakness[:type].length).times {print " "}
            print "#{weakness[:amount]}                   | "
            if (pokemon.resistances[index] != nil)
                resistance = pokemon.resistances[index]
                print "#{resistance[:type]}:"
                (9 - resistance[:type].length).times {print " "}
                puts "#{resistance[:amount]}                 |"
            else
                puts "                                |"
            end
        end
        puts "|__________________________________|_________________________________|"
        puts " ____________________________________________________________________"
        puts "|                                                                    |"
        print "|              1: View #{pokemon.name}\'s movesets"
        (35 - pokemon.name.length).times {print " "}
        puts "|"
        print "|              2: View #{pokemon.name}\'s move pool"                  
        (34 - pokemon.name.length).times {print " "}
        puts "|"
        puts "|              3: Return to main menu                                |"
        puts "|____________________________________________________________________|"

        user_input = 0

        while user_input != 1 && user_input != 2 && user_input != 3
            print "Enter an option: "
            user_input = gets.chomp.to_i
            case user_input
            when 1
                view_pokemon_pve_movesets(pokemon)
                break
            when 2
                list_pokemon_of_type()
                break
            when 3
                search_by_name_or_number()
                break
            else
                puts "#{user_input} is an invalid selection"
            end
        end
    end

    def self.view_pokemon_pve_movesets(pokemon)

        puts " ___________________________________________________________________"
        puts "|\\__________________________PVE_MOVESETS__________________________/|"
        puts "|                                                                   |"
        pokemon.pve_movesets.each do |moveset|
            puts "Quick: #{moveset[:quick]} Charge: #{moveset[:charge]}"
            puts "Atk Grade: #{moveset[:atk_grade]} Def Grade: #{moveset[:def_grade]}"
            puts "-----------------------------------------------------------------"
        end
        puts "|____________________________________________________________________|"
    end
end
