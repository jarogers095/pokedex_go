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
        welcome()
    end

    def self.welcome()
        #initial welcome message and creation of Pokemon index
        puts ": "
        PokedexGo::Scraper.create_pokemon_from_index()
        main_menu()
    end

    def self.main_menu()
        #Root of menu system
        system("clear")
        window_title_single("Pokedex Go")
        puts "│                  Welcome to Pokedex Go                              │"
        puts "│    The World's Best Text-Based Pokemon Go Search Tool!              │"
        window_tail_single()

        window_navigation_quad("1: List all Pokemon", "2: List by Pokemon type", "3: Search by Name or Number", "4: Exit")

        while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
            print "Enter an option: "
            user_input = gets.chomp.to_i
            case user_input
            when 1
                present_pokemon_list(PokedexGo::Pokemon.all())
                break
            when 2
                list_pokemon_of_type()
                break
            when 3
                break
            when 4
                main_menu()
            else
                puts "#{user_input} is an invalid selection"
            end
        end
    end

    def self.list_all_pokemon()
        present_pokemon_list(PokedexGo::Pokemon.all())
        
        print "Select a Pokemon: "
        user_input = gets.chomp.to_i
        view_pokemon_profile(PokedexGo::Pokemon.all.detect{|mon| mon.number == user_input})
    end

    def self.present_pokemon_list(list)
        offset = 0

        loop do
            system("clear")
            puts "╭─────────────────────────────────────────────────────────────────────╮"
            (15).times do |n|
                i = offset + n
                print "│"
                if i < list.size
                    print align_left(" #{list[i].number}: #{list[i].name} (#{list[i].type})", 69, " ")
                else
                    69.times {print " "}
                end
                puts "│"
            end
            puts "╰─────────────────────────────────────────────────────────────────────╯"
            window_navigation_quad("1: Next page", "2: Enter name", "3: Enter number", "4: Main menu")
            user_input = 0

            while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
                print "Enter an option: "
                user_input = gets.chomp.to_i
                case user_input
                when 1
                    if offset < (list.size - 15)
                        offset += 15
                    end
                    break
                when 2
                    break
                when 3
                    break
                when 4
                    main_menu()
                else
                    puts "#{user_input} is an invalid selection"
                end
            end
        end
    end

    def self.list_pokemon_of_type()
        #lists all pokemon of given type
        system("clear")
        window_title_single("Pokemon Types")
        puts "│ #{FX[:green]}Bug        #{FX[:magenta]}Dark       #{FX[:white]}Dragon       #{FX[:yellow]}Electric     #{FX[:cyan]}Fairy      #{FX[:red]}Fighting#{FX[:reset]} │"
        puts "│ #{FX[:red]}Fire       #{FX[:white]}Flying     #{FX[:magenta]}Ghost        #{FX[:green]}Grass        #{FX[:black]}Ground     #{FX[:cyan]}Ice#{FX[:reset]}      │"
        puts "│ #{FX[:white]}Normal     #{FX[:magenta]}Poison     #{FX[:red]}Psychic      #{FX[:black]}Rock         #{FX[:white]}Steel      #{FX[:blue]}Water#{FX[:reset]}    │"
        window_tail_single()

        window_navigation_single("Enter a Pokemon type")

        user_input = "none"
        while !PokedexGo::Pokemon.types.include?(user_input)
            user_input = gets.chomp.downcase
            if !PokedexGo::Pokemon.types.include?(user_input)
                puts "#{user_input} is an invalid selection"
            end
        end

        pokemon_of_type = PokedexGo::Pokemon.all.select do |pokemon|
            pokemon.type.include?(user_input)
        end

        present_pokemon_list(pokemon_of_type)
    end

    def self.search_by_name_or_number()

    end

    def self.view_pokemon_profile(pokemon)
        #view full profile of individual pokemon
        PokedexGo::Scraper.add_profile_stats(pokemon)

        system("clear")
        window_banner(pokemon.name)

        window_title_double("Stats", "League Ranks")
        
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

        window_tail_double()


        window_title_double("Vulnerable", "Resistant")
        
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

        window_tail_double()

        window_navigation_quad("1: PVE Movesets", "2: PVP Movesets", "3: Back to list", "4: Main Menu")

    end

    def self.exit(pokemon)
        system("clear")
        window_banner("Goodbye!")
    end

    def self.window_banner(name)
        puts "╔═════════════════════════════════════════════════════════════════════╗"
        print "║"
        print center_string(name.upcase, 69, " ")
        puts "║"
        puts "╚═════════════════════════════════════════════════════════════════════╝"
    end

    def self.window_title_single(title)
        puts "╭─────────────────────────────────────────────────────────────────────╮"
        print "│"
        print center_string(title, 69, " ")
        puts "│"
        puts "├─────────────────────────────────────────────────────────────────────┤"
    end

    def self.window_title_double(title_1, title_2)
        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        print "│"
        print center_string(title_1, 34, " ")
        print "│"
        print center_string(title_2, 34, " ")
        puts "│"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"
    end

    def self.window_tail_single()
        puts "╰─────────────────────────────────────────────────────────────────────╯"
    end

    def self.window_tail_double()
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"
    end

    def self.window_navigation_single(prompt)
        puts "╭─────────────────────────────────────────────────────────────────────╮"
        print "│"
        print center_string(prompt, 69, " ")
        puts "│"
        puts "╰─────────────────────────────────────────────────────────────────────╯"
    end

    def self.window_navigation_quad(option_1, option_2, option_3, option_4)
        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        print "│"
        print center_string(option_1, 34, " ")
        print "│"
        print center_string(option_2, 34, " ")
        puts "│"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"
        print "│"
        print center_string(option_3, 34, " ")
        print "│"
        print center_string(option_4, 34, " ")
        puts "│"
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"
    end

    def self.capture_input(method_1, method_2, method_3, method_4)
        user_input = 0

        while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
            print "Enter an option: "
            user_input = gets.chomp.to_i
            case user_input
            when 1
                method_1.call()
                break
            when 2
                method_2.call()
                break
            when 3
                method_3.call()
                break
            when 4
                method_4.call()
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
