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

        puts " _____________________________________________________________________"
        print "|"
        print center_string(pokemon.name.upcase, 34, "_")
        print "|"
        print center_string("LEAGUE_RANKS", 34, "_")
        puts "|"


        print "|"
        print align_left(" Number:   #{pokemon.number}", 34, " ")
        print "|"
        print align_left(" Great League:  #{pokemon.ratings[:great_league]}", 34, " ")
        puts "|"


        print "|"
        print align_left(" Attack:   #{pokemon.attack}", 34, " ")
        print "|"
        print align_left(" Ultra League:  #{pokemon.ratings[:ultra_league]}", 34, " ")
        puts "|"

        print "|"
        print align_left(" Defense:  #{pokemon.defense}", 34, " ")
        print "|"
        print align_left(" Master League:  #{pokemon.ratings[:master_league]}", 34, " ")
        puts "|"
        puts "|__________________________________|__________________________________|"

        print "|"
        print center_string("VULNERABLE", 34, "_")
        print "|"
        print center_string("RESISTANT", 34, "_")
        puts "|"


        pokemon.weaknesses.each_with_index do |weakness, index|
            print "|"
            print align_left(" #{weakness[:type]}:", 10, " ")
            print align_left(" #{weakness[:amount]}", 24, " ")
            print "|"
            if (pokemon.resistances[index] != nil)
                resistance = pokemon.resistances[index]
                print align_left(" #{resistance[:type]}:", 10, " ")
                print align_left(" #{resistance[:amount]}", 24, " ")                 
                puts "|"
            else
                puts "                                |"
            end
        end
        puts "|__________________________________|__________________________________|"
        puts " _____________________________________________________________________"
        puts "|                                                                    |"
        print "|              1: View #{pokemon.name}\'s PVE movesets"
        (31 - pokemon.name.length).times {print " "}
        puts "|"
        print "|              2: View #{pokemon.name}\'s PVP movesets"
        (31 - pokemon.name.length).times {print " "}
        puts "|"
        print "|              3: View #{pokemon.name}\'s move pool"                  
        (34 - pokemon.name.length).times {print " "}
        puts "|"
        puts "|              4: Return to main menu                                 |"
        puts "|_____________________________________________________________________|"

        user_input = 0

        while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
            print "Enter an option: "
            user_input = gets.chomp.to_i
            case user_input
            when 1
                view_pokemon_pve_movesets(pokemon)
                break
            when 2
                view_pokemon_pvp_movesets(pokemon)
                break
            when 3
                search_by_name_or_number()
                break
            when 4
                main_menu()
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

    def self.view_pokemon_pvp_movesets(pokemon)
        puts " __________________________________________________________________"
        puts "|\\__________________________PVP_MOVESETS__________________________/|"
        puts "|                                                                  |"
        puts "|_______Quick_____________Charge 1_____________Charge 2______Grade_|"
        pokemon.pvp_movesets.each do |moveset|
            print "|"
            print center_string(moveset[:quick], 19, " ")
            print "|"
            print center_string(moveset[:charge_1], 19, " ")
            print "|"
            print center_string(moveset[:charge_2], 19, " ")
            print "|"
            print center_string(moveset[:grade], 6, " ")   
            puts "|"
            puts "|-------------------|-------------------|-------------------|------|"
        end
        puts "|___________________|___________________|___________________|______|"
    end

    def self.center_string(string, gap, filler_character)
        centered_string = ""
        ((gap - string.length) / 2).times {centered_string << filler_character}
        centered_string << string
        ((gap - string.length) / 2).times {centered_string << filler_character}
        ((gap - string.length) % 2).times {centered_string << filler_character}
        return centered_string
    end

    def self.align_left(string, gap, filler_character)
        aligned_string = string
        (gap - string.length).times {aligned_string << filler_character}
        return aligned_string
    end

    def self.align_right()

    end
end
