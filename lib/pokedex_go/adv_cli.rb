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
        main_menu()
    end

    def self.main_menu()
        #Root of menu system

        puts "  ╭─────────────────────────────────────────────────────────────────────╮"
        puts "  │              This is some text inside of a fancy box                │"
        puts "  ╰─────────────────────────────────────────────────────────────────────╯"

        navigation_menu()
    end

    def self.navigation_menu(selection = 0)
        case selection
        when 0
            draw_button(3, true)
            draw_button(14)
            draw_button(25)
            draw_button(36)
        when 1
            draw_button(3)
            draw_button(14, true)
            draw_button(25)
            draw_button(36)
        when 2
            draw_button(3)
            draw_button(14)
            draw_button(25, true)
            draw_button(36)
        when 3
            draw_button(3)
            draw_button(14)
            draw_button(25)
            draw_button(36, true)
        end

        capture_input(selection)
    end

    def self.draw_button(column, selected = false)
        if (selected == true)
            print FX[:red]
        end

        print "\u001b[5;#{column}H"
        print "╭────────╮"
        print "\u001b[6;#{column}H"
        print "│ Button │"
        print "\u001b[7;#{column}H"
        print "╰────────╯"

        print FX[:reset]
    end

    def self.capture_input(selection)
        case readkey.inspect
        when "\"\\e[C\""
            navigation_menu(selection + 1)
        when "\"\\e[D\""
            navigation_menu(selection - 1)
        end
    end
end
