class PokedexGo::Adv_CLI
    require 'io/console'
    require 'timeout'

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
        line_clear: "\u001b[2K"
    }

    def self.readkey()
        c = ''
        result = ''
        $stdin.raw do |stdin|
            c = stdin.getc
            result << c
            if c == "\e"
                begin
                    while (c = Timeout::timeout(0.0001) { stdin.getc })
                        result << c
                    end
                rescue Timeout::Error
                    # no action required
                end
            end
        end
        result
    end

    def self.call()
        #entrypoint
        system("clear")
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

        menu_main = Menu.new()
        button_1 = Button.new("List", 3, 5)
        button_1.draw()
    end

    class Menu
        attr_reader(:buttons)

        def add_button(button)
            @buttons << button
        end

        def set_selection(which)
            @buttons[which].select()
        end
    end

    class Button
        attr_reader(:label, :x, :y, :selected)

        def initialize(label, x, y)
            @label = label
            @x = x
            @y = y
            @selected = false
        end
        
        def select()
            @selected = true
        end

        def draw()
            if (@selected == true)
                print FX[:red]
            end

            print "\u001b[5;#{@x}H"
            print "╭────────╮"
            print "\u001b[6;#{@x}H"
            print "│"
            print center_string(@label, 8, " ")
            print "│"
            print "\u001b[7;#{@x}H"
            print "╰────────╯"

            print FX[:reset]
        end
    end


    def self.move_cursor(row, colum)
        print "\u001b[#{row};#{column}H"
    end

    def self.capture_input(selection)
        case readkey.inspect
        when "\"\\e[C\""
            navigation_menu(selection + 1)
        when "\"\\e[D\""
            navigation_menu(selection - 1)
        end
    end

    def self.quit()
        system("clear")
        window_banner("Goodbye!")
        exit(true)
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
        print FX[:bold]
        print center_string(title, 69, " ")
        print FX[:reset]
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

