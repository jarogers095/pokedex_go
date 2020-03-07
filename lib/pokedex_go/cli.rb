class PokedexGo::CLI
    FX = {
        black: "\u001b[38;5;136m",
        red: "\u001b[31m",
        green: "\u001b[32;1m",
        yellow: "\u001b[33;1m",
        blue: "\u001b[34m",
        magenta: "\u001b[35m",
        cyan: "\u001b[36m",
        white: "\u001b[37m",
        reset: "\u001b[0m",

    }

    def self.call()
        #entrypoint
        #welcome()
        PokedexGo::Adv_CLI.call()
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
        puts "| #{FX[:green]}Bug        #{FX[:magenta]}Dark       #{FX[:white]}Dragon     #{FX[:yellow]}Electric     #{FX[:cyan]}Fairy      #{FX[:red]}Fighting#{FX[:reset]} |"
        puts "| #{FX[:red]}Fire       #{FX[:white]}Flying     #{FX[:magenta]}Ghost      #{FX[:green]}Grass        #{FX[:black]}Ground     #{FX[:cyan]}Ice#{FX[:reset]}      |"
        puts "| #{FX[:white]}Normal     #{FX[:magenta]}Poison     #{FX[:red]}Psychic    #{FX[:black]}Rock         #{FX[:white]}Steel      #{FX[:blue]}Water#{FX[:reset]}    |"
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

        puts "╔═════════════════════════════════════════════════════════════════════╗"
        print "║"
        print center_string(pokemon.name.upcase, 69, " ")
        puts "║"
        puts "╚═════════════════════════════════════════════════════════════════════╝"


        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        print "│"
        print center_string("Stats", 34, " ")
        print "│"
        print center_string("LEAGUE RANKS", 34, " ")
        puts "│"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"


        print "│"
        print align_left(" Number:   #{pokemon.number}", 34, " ")
        print "│"
        print align_left(" Great League:  #{pokemon.ratings[:great_league]}", 34, " ")
        puts "│"


        print "│"
        print align_left(" Attack:   #{pokemon.attack}", 34, " ")
        print "│"
        print align_left(" Ultra League:  #{pokemon.ratings[:ultra_league]}", 34, " ")
        puts "│"

        print "│"
        print align_left(" Defense:  #{pokemon.defense}", 34, " ")
        print "│"
        print align_left(" Master League:  #{pokemon.ratings[:master_league]}", 34, " ")
        puts "│"
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"

        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        print "│"
        print center_string("VULNERABLE", 34, " ")
        print "│"
        print center_string("RESISTANT", 34, " ")
        puts "│"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"
        


        pokemon.weaknesses.each_with_index do |weakness, index|
            print "│"
            print align_left(" #{weakness[:type]}:", 10, " ")
            print align_left(" #{weakness[:amount]}", 24, " ")
            print "│"
            if (pokemon.resistances[index] != nil)
                resistance = pokemon.resistances[index]
                print align_left(" #{resistance[:type]}:", 10, " ")
                print align_left(" #{resistance[:amount]}", 24, " ")                 
                puts "│"
            else
                puts "                                  │"
            end
        end
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"
        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        puts "│                                  │                                  │"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"
        puts "│                                  │                                  │"
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"

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

        puts " _____________________________________________________________________"
        print "|"
        print center_string("PVE_MOVESETS", 69, "_")
        puts "|"
        puts "|                                                                     |"
        puts "|________Quick___________________Charge___________Atk_Grade_Def_Grade_|"
        pokemon.pve_movesets.each do |moveset|
            print "|"
            print center_string(moveset[:quick], 22, " ")
            print "|"
            print center_string(moveset[:charge], 24, " ")
            print "|"
            print center_string(moveset[:atk_grade], 10, " ")
            print "|"
            print center_string(moveset[:def_grade], 10, " ")   
            puts "|"
            puts "|----------------------|------------------------|----------|----------|"
        end
        puts     "|______________________|________________________|__________|__________|"
    end

    def self.view_pokemon_pvp_movesets(pokemon)
        puts " _____________________________________________________________________"
        print "|"
        print center_string("PVP_MOVESETS", 69, "_")
        puts "|"
        puts "|                                                                     |"
        puts "|________Quick______________Charge 1______________Charge 2______Grade_|"
        pokemon.pvp_movesets.each do |moveset|
            print "|"
            print center_string(moveset[:quick], 20, " ")
            print "|"
            print center_string(moveset[:charge_1], 20, " ")
            print "|"
            print center_string(moveset[:charge_2], 20, " ")
            print "|"
            print center_string(moveset[:grade], 6, " ")   
            puts "|"
            puts "|--------------------|--------------------|--------------------|------|"
        end
        puts "|____________________|____________________|____________________|______|"
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
