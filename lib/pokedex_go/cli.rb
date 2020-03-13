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
        bold: "\u001b[1m",
        line_start: "\u001b[1000D",
        line_up: "\u001b[1A",
        line_clear: "\u001b[2K",
        window_size: "\e[8;25;80t",
        reverse: "\u001b[7m"
    }

    #entrypoint - called from executable bin/pokedex_go
    def self.call()
        #calls welcome to initiate setup
        welcome()
    end

    #Welcome adjusts terminal window size if allowed, and 
    ##initiates the scraping of the Pokemon site to allow creation of Pokemon objects
    ##It then initiates the interface by calling main_menu() 
    def self.welcome()
        print FX[:window_size]
        PokedexGo::Scraper.create_pokemon_from_index()
        main_menu()
    end

    #Main Menu displays an intro graphic as well as four navigational options
    def self.main_menu()
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
        prompt = "Enter an option: "

        while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
            print FX[:line_clear]
            print prompt
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
                print FX[:line_clear]
                print "Enter pokemon name: "
                user_input = gets.chomp
                search_by_name(user_input)
                #break
            when 4
                quit()
                break
            else
                print FX[:line_up]
                print FX[:line_clear]
                puts "#{user_input} is an invalid selection"
            end
        end
    end

    #Present Pokemon List takes in a list of pokemon objects and creates 
    ##a paged interface consisting of 15 pokemon per page
    ##It also gives the option to type in one of the pokemon's names
    ##to see a detailed profile page, or to retreat to the main menu
    def self.present_pokemon_list(list)
        offset = 0

        loop do
            system("clear")
            puts "╭─────────────────────────────────────────────────────────────────────╮"
            (15).times do |n|
                i = offset + n
                print "│"
                if i < list.size
                    print align_left(" #{list[i].number}: #{list[i].name} [#{list[i].type}]", 69, " ")
                else
                    69.times {print " "}
                end
                puts "│"
            end
            puts "╰─────────────────────────────────────────────────────────────────────╯"
            window_navigation_quad("1: Next page", "2: Previous page", "3: Enter name", "4: Main menu")
            
            user_input = 0
            prompt = "Enter an option: "
            while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
                print prompt
                user_input = gets.chomp.to_i
                case user_input
                when 1
                    if offset < (list.size - 15)
                        offset += 15
                    end
                    break
                when 2
                    if offset > 0
                        offset -= 15
                    end
                    break
                when 3
                    print FX[:line_up]
                    print "Enter pokemon name: "
                    user_input = gets.chomp
                    search_by_name(user_input)
                    #break
                when 4
                    main_menu()
                else
                    print FX[:line_up]
                    print FX[:line_clear]
                    puts "#{user_input} is an invalid selection"
                end
            end
        end
    end

    #List Pokemon of Type presents the user with a display containing all the possible pokemon types
    #and allows the user to search for one, calling "present_pokemon_list()" with the pokemon of that type
    def self.list_pokemon_of_type()
        system("clear")
        window_title_single("Pokemon Types")
        puts "│                                                                     │"
        puts "│ #{FX[:green]}Bug        #{FX[:magenta]}Dark       #{FX[:white]}Dragon       #{FX[:yellow]}Electric     #{FX[:cyan]}Fairy      #{FX[:red]}Fighting#{FX[:reset]} │"
        puts "│                                                                     │"
        puts "│ #{FX[:red]}Fire       #{FX[:white]}Flying     #{FX[:magenta]}Ghost        #{FX[:green]}Grass        #{FX[:black]}Ground     #{FX[:cyan]}Ice#{FX[:reset]}      │"
        puts "│                                                                     │"
        puts "│ #{FX[:white]}Normal     #{FX[:magenta]}Poison     #{FX[:red]}Psychic      #{FX[:black]}Rock         #{FX[:white]}Steel      #{FX[:blue]}Water#{FX[:reset]}    │"
        puts "│                                                                     │"
        window_tail_single()

        window_navigation_single("Enter a Pokemon type")

        user_input = "none"
        print "Type: "
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

    #Search by Name allows a user to search for a Pokemon by name. If more than one Pokemon
    ##is found with the entered string, it defers to "select_from_pokemon()" before "view_pokemon_profile()"
    def self.search_by_name(user_input)
        pokemon_of_name = PokedexGo::Pokemon.all.select do |pokemon|
            pokemon.name.downcase.include?(user_input.downcase)
        end
        if pokemon_of_name.size > 1
            select_from_pokemon(pokemon_of_name)
        elsif pokemon_of_name.size == 1
            view_pokemon_profile(pokemon_of_name[0])
        else
            #print FX[:line_up]
            puts "Name not found!"
        end
    end

    #Select from pokemon is called whenever a name search is done and the number of pokemon returned is
    ##greater than 1. It allows the user to select from a list the specific pokemon they want.
    def self.select_from_pokemon(list)
        system("clear")
        offset = 0
        puts "╭─────────────────────────────────────────────────────────────────────╮"
        (15).times do |n|
            i = offset + n
            print "│"
            if i < list.size
                print align_left(" #{i}: #{list[i].name} [#{list[i].type}]", 69, " ")
            else
                69.times {print " "}
            end
            puts "│"
        end
        puts "╰─────────────────────────────────────────────────────────────────────╯"
        window_navigation_single("Multiple Pokemon found. Select a number from the list.")
        

        user_input = 0

        while user_input < 1 || user_input > list.size
            print "Number: "
            user_input = gets.chomp.to_i
            view_pokemon_profile(list[user_input])
        end
    end

    #View Pokemon Profile presents the detailed profile of a selected pokemon and includes the options
    ##to view PVP and PVE movesets, search for another pokemon, or return to the main menu
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

        print "│"
        print align_left(" Stamina:  #{pokemon.stamina}", 34, " ")
        print "│"
        print align_left(" ", 34, " ")
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
        prompt = "Enter an option: "
        while user_input != 1 && user_input != 2 && user_input != 3 && user_input != 4
            print prompt
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
                    pokemon.name.downcase.include?(user_input.downcase)
                end
                if pokemon_of_name.size > 1
                    select_from_pokemon(pokemon_of_name)
                elsif pokemon_of_name.size == 1
                    view_pokemon_profile(pokemon_of_name[0])
                else
                    print FX[:line_up]
                    prompt =  "Name not found! Reselect 1, 2, 3 or 4:"
                end
                break
            when 4
                main_menu()
                break
            else
                puts "#{user_input} is an invalid selection"
            end
        end

    end

    #View Pokemon PVE Movesets displays the PVE movesets of a specific pokemon in a list view
    def self.view_pokemon_pve_movesets(pokemon)

        system("clear")
        window_title_single("PVE Movesets")
        puts "│        Quick                    Charge          Atk Grade Def Grade │"
        puts "├──────────────────────┬────────────────────────┬──────────┬──────────┤"
        pokemon.pve_movesets.each_with_index do |moveset, index|
            print "│"
            print center_string(moveset[:quick], 22, " ")
            print "│"
            print center_string(moveset[:charge], 24, " ")
            print "│"
            print center_string(moveset[:atk_grade], 10, " ")
            print "│"
            print center_string(moveset[:def_grade], 10, " ")   
            puts "│"
            if((index + 1) < pokemon.pve_movesets.size)
                puts "├──────────────────────┼────────────────────────┼──────────┼──────────┤"
            else
                puts "╰──────────────────────┴────────────────────────┴──────────┴──────────╯"
            end
        end

        window_navigation_single("Type '1' to return to #{pokemon.name}'s profile")

        user_input = 0

        while user_input != 1
            print "Return?: "
            user_input = gets.chomp.to_i
            if user_input == 1
                view_pokemon_profile(pokemon)
            end
        end
    end

    #View Pokemon PVP Movesets displays the PVP movesets of a specific pokemon in a list view
    def self.view_pokemon_pvp_movesets(pokemon)
        system("clear")
        window_title_single("PVP Movesets")
        puts "│        Quick              Charge 1             Charge 2       Grade │"
        puts "├────────────────────┬────────────────────┬────────────────────┬──────┤"
        pokemon.pvp_movesets.each_with_index do |moveset, index|
            print "│"
            print center_string(moveset[:quick], 20, " ")
            print "│"
            print center_string(moveset[:charge_1], 20, " ")
            print "│"
            print center_string(moveset[:charge_2], 20, " ")
            print "│"
            print center_string(moveset[:grade], 6, " ")   
            puts "│"
            if((index + 1) < pokemon.pvp_movesets.size)
                puts "├────────────────────┼────────────────────┼────────────────────┼──────┤"
            else
                puts "╰────────────────────┴────────────────────┴────────────────────┴──────╯"
            end
        end

        window_navigation_single("Type '1' to return to #{pokemon.name}'s profile")

        user_input = 0

        while user_input != 1
            print "Return?: "
            user_input = gets.chomp.to_i
            if user_input == 1
                view_pokemon_profile(pokemon)
            end
        end
    end

    #quit makes sure the application exits successfully
    def self.quit()
        system("clear")
        window_banner("Goodbye!")
        exit(true)
    end

    #The methods beginning with "window" are helper methods for constructing pieces of the text
    ##based interface
    ##Window Banner creates a large banner with a passed string in all caps, centered within it
    def self.window_banner(name)
        puts "╔═════════════════════════════════════════════════════════════════════╗"
        print "║"
        print center_string(name.upcase, 69, " ")
        puts "║"
        puts "╚═════════════════════════════════════════════════════════════════════╝"
    end

    #Window Title Single creates a title bar for a window that stretches across the entire width
    ##of the interface and includes the passed string, centered.
    def self.window_title_single(title)
        puts "╭─────────────────────────────────────────────────────────────────────╮"
        print "│"
        print FX[:bold]
        print center_string(title, 69, " ")
        print FX[:reset]
        puts "│"
        puts "├─────────────────────────────────────────────────────────────────────┤"
    end

    #Window Title Double creates a title bar that is divided in the center to create two window title bars
    ##It centers the passed strings within their respective title bar
    def self.window_title_double(title_1, title_2)
        puts "╭──────────────────────────────────┬──────────────────────────────────╮"
        print "│"
        print center_string(title_1, 34, " ")
        print "│"
        print center_string(title_2, 34, " ")
        puts "│"
        puts "├──────────────────────────────────┼──────────────────────────────────┤"
    end

    #Window Tail Single creates the bottom edge of a window that spans the entire width of the interface
    def self.window_tail_single()
        puts "╰─────────────────────────────────────────────────────────────────────╯"
    end

    #Window Tail Double creates the bottom edge of a window that contains two sub-divisions
    def self.window_tail_double()
        puts "╰──────────────────────────────────┴──────────────────────────────────╯"
    end

    #Window Navigation Single creates a single "bubble style" prompt with centered text
    ##for use before receiving user input
    def self.window_navigation_single(prompt)
        puts "╭─────────────────────────────────────────────────────────────────────╮"
        print "│"
        print center_string(prompt, 69, " ")
        puts "│"
        puts "╰─────────────────────────────────────────────────────────────────────╯"
    end

    #Window Navigation Quad creates a larger "Bubble Style" prompt with 4 sub-divisions for text
    ##This allows more options to be presented to the user
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

    #Center String and Align String help build the titles and columns of the interface
    ##by padding the left and right or just the right side of the string with a given
    ##filler character
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
