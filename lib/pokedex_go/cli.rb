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
        line_start: "\u001b[1000D",
        line_up: "\u001b[1A",
        line_clear: "\u001b[2K",
        window_size: "\e[8;25;80t"
    }

    def self.call()
        #entrypoint
        welcome()
    end

    def self.welcome()
        #creation of Pokemon index
        print FX[:window_size]
        PokedexGo::Scraper.create_pokemon_from_index()
        main_menu()
    end

    def self.main_menu()
        #Root of menu system
        system("clear")
        window_title_single("Pokedex Go")
        puts "│                                   ,'\\                               │"
        puts "│     _.----.        ____         ,'  _\\   ___    ___     ____        │"
        puts "│ _,-'       `.     |    |  /`.   \\,-'    |   \\  /   |   |    \\  |`.  │"
        puts "│ \\      __    \\    '-.  | /   `.  ___    |    \\/    |   '-.   \\ |  | │"
        puts "│  \\.    \\ \\   |  __  |  |/    ,','_  `.  |          | __  |    \\|  | │"
        puts "│    \\    \\/   /,' _`.|      ,' / / / /   |          ,' _`.|     |  | │"
        puts "│     \\     ,-'/  /   \\    ,'   | \\/ / ,`.|         /  /   \\  |     | │"
        puts "│      \\    \\ |   \\_/  |   `-.  \\    `'  /|  |    ||   \\_/  | |\\    | │"
        puts "│       \\    \\ \\      /       `-.`.___,-' |  |\\  /| \\      /  | |   | │"
        puts "│        \\    \\ `.__,'|  |`-._    `|      |__| \\/ |  `.__,'|  | |   | │"
        puts "│         \\_.-'       |__|    `-._ |              '-.|     '-.| |   | │"
        puts "│                                 `'                            '-._| │"
        puts "│                        Welcome to Pokedex Go                        │"
        window_tail_single()

        window_navigation_quad("1: List all Pokemon", "2: Search by Pokemon type", "3: Search by Name", "4: Exit")

        user_input = 0

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
                print FX[:line_up]
                print "Enter pokemon name: "
                user_input = gets.chomp
                pokemon_of_name = PokedexGo::Pokemon.all.select do |pokemon|
                    pokemon.name.downcase == user_input.downcase
                end
                if pokemon_of_name.size > 1
                    select_from_pokemon(pokemon_of_name)
                elsif pokemon_of_name.size == 1
                    view_pokemon_profile(pokemon_of_name[0])
                else
                    print FX[:line_up]
                    print "Name not found! Reselect 1, 2, 3 or 4:"
                end
                break
            when 4
                break
            else
                puts "#{user_input} is an invalid selection"
            end
        end
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
        puts "|"
        puts "│ #{FX[:green]}Bug        #{FX[:magenta]}Dark       #{FX[:white]}Dragon       #{FX[:yellow]}Electric     #{FX[:cyan]}Fairy      #{FX[:red]}Fighting#{FX[:reset]} │"
        puts "|"
        puts "│ #{FX[:red]}Fire       #{FX[:white]}Flying     #{FX[:magenta]}Ghost        #{FX[:green]}Grass        #{FX[:black]}Ground     #{FX[:cyan]}Ice#{FX[:reset]}      │"
        puts "|"
        puts "│ #{FX[:white]}Normal     #{FX[:magenta]}Poison     #{FX[:red]}Psychic      #{FX[:black]}Rock         #{FX[:white]}Steel      #{FX[:blue]}Water#{FX[:reset]}    │"
        puts "|"
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

    def self.search_by_name(input)

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

        window_navigation_quad("1: PVE Movesets", "2: PVP Movesets", "3: Search by name", "4: Main Menu")
        
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
                print FX[:line_up]
                print "Enter pokemon name: "
                user_input = gets.chomp
                pokemon_of_name = PokedexGo::Pokemon.all.select do |pokemon|
                    pokemon.name.downcase == user_input.downcase
                end
                if pokemon_of_name.size > 1
                    select_from_pokemon(pokemon_of_name)
                elsif pokemon_of_name.size == 1
                    view_pokemon_profile(pokemon_of_name[0])
                else
                    print FX[:line_up]
                    print "Name not found! Reselect 1, 2, 3 or 4:"
                end
                break
            when 4
                break
            else
                puts "#{user_input} is an invalid selection"
            end
        end

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
end
