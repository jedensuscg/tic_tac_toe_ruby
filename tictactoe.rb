$line = "\u2500"
$sc = ["\u00B9","\u00B2","\u00B3","\u2074","\u2075","\u2076","\u2077","\u2078","\u2079"]
class Player
    attr_accessor :name, :marker
    @@player = 0

    def initialize(name,marker)
        @name = name
        @marker = marker
        @@player += 1
    end
end

module ValidateInput
    attr_accessor :valid_input, :input

    @valid_input = false
    @input = ""
    
    def valid_int?(player, low = 1,high = 9)
        input = gets.chomp
        check = Integer(input) rescue false
        if check
            if input.to_i > 0 && input.to_i < 10
                check_for_duplicate(input, player)
            else
                40.times{print($line)}
                puts ""
                puts "!!Invalid number! Choose between 1 and 9!!"
                40.times{print($line)}
                2.times{puts ""}
            end
        else 
            40.times{print($line)}
            puts ""
            puts "!!Invalid selection! That was not a number!!"
            40.times{print($line)}
            2.times{puts ""}
        end
    end

    def check_for_duplicate(selection, player)
        if !@picked_squares.include? selection
            #Debug puts "dup check #{selection}"
            #Debug puts "square picked: #{@picked_squares}"
            update_board(player, selection)
            @player1_turn = !@player1_turn
        else
            40.times{print($line)}
            puts ""
            puts "!!You selected an already chosen square. Try again!!"
            40.times{print($line)}
            2.times{puts ""}
            valid_int?(player)
        end
    end
end

module Board
    def print_board()
        line = "\u2500"
        count = 0
        puts " TIC TAC TOE"
        13.times{print("=")}
        puts ""
        @board.each do |row, cols|
            puts "| #{cols[:c1]} | #{cols[:c2]} | #{cols[:c3]} |"
            if count < 2
                13.times{print(line)}
                puts ""
            end
            count += 1
        end
        13.times{print("=")}
        3.times{puts ""}
    end 

    def update_board(player, position)
        @board.each do |row, cols|
            cols.each do |col, val|
                if val == $sc[position.to_i - 1]
                    @picked_squares.push(position)
                    @board[row][col] = player.marker
                    @round += 1
                end
            end
        end
        clear_console()
        puts "Round: #{@round}"
        print_board()
    end
end

class Game
    attr_reader :board, :win, :player1, :player2, :round
    attr_accessor :player1_turn
    include Board, ValidateInput
    
    def clear_console
        if RUBY_PLATFORM =~ /win21|win64|\.NET|windows|cygwin|mingw32/i
            system('clr')
        else
            system('clear')
        end
    end

    def initialize
        @board = {:r1 => {:c1 => $sc[0], :c2 => $sc[1], :c3 => $sc[2]}, :r2 => {:c1 => $sc[3], :c2 => $sc[4], :c3 => $sc[5]}, :r3 => {:c1 => $sc[6], :c2 => $sc[7], :c3 => $sc[8]}}
        @picked_squares = []
        @win = false
        @round = 1
        @player1_turn = true
        create_players()
    end

    #Creates two player objects. Ran during Game inititialize
    def create_players
        other_marker = ""
        players = {:One => {:name => "One", :marker => ""}, :Two => {:name => "Two", :marker => ""}}
        first_player = true
        players.each do |player_num, player|
            puts "Player #{player_num.to_s}, Enter your name."
            puts "---"
            player[:name] = gets.chomp
            puts "---"
            if first_player 
                player[:marker] = set_marker(player[:name])
                if player[:marker] == "X"
                    other_marker = "O"
                else
                    other_marker = "X"
                end
                first_player = false
            else
                puts "#{player[:name]}, your marker is #{other_marker}"
                player[:marker] = other_marker
            end
        end
        @player1 = Player.new(players[:One][:name], players[:One][:marker])
        @player2 = Player.new(players[:Two][:name], players[:Two][:marker])
    end

    # Gets and sets players markers. Called from create_player()
    def set_marker(name)
        puts "#{name}, select which marker you would like to use. X or O."
        while true
            puts "---"
            marker = gets.chomp
            puts "---"
            if marker.downcase == "x" || marker.downcase == "o"
                return marker.upcase
                break
            else
                puts "Please Select X or O"
            end
        end
    end



    #Check all win conditions after each turn.
    def check_win_conditions()
        full_array = []
        check_array = []

        #Check for wins across ROWS
        @board.each do |row, cols|
            check_array = cols.values #Create array with with each individual row
            full_array += check_array #Create array with all of the squares for checking other win conditions.
            check = check_array.uniq.size <=1
            if check == true
                get_winner(check_array[0])
                @win = true
                
            end
        end

        #Check for wins across COLUMNS
        check_array = full_array.group_by.with_index{|_,i| i % 3}.values
        i = 0
        while i <= 2
            check = check_array[i].uniq.size <= 1
            if check == true
                puts check_array[i]
                get_winner(check_array[i][0])
                @win = true
                return
            end
            i += 1
        end

        #Check fo win DIAGONALLY left to right
        check_array = full_array.group_by.with_index{|_,i| i % 4}.values
        check = check_array[0].uniq.size <= 1
        if check == true
            get_winner(check_array[0][0])
            @win = true
            return
        end
        
        #Check fo win DIAGONALLY right to left
        check_array = []
        i = 2
        while i <= 6
            check_array.push(full_array[i])
            i += 2
        end
        check = check_array.uniq.size <= 1
        if check == true
            get_winner(check_array[2])
            @win = true
        end
    end

    #Get player object of the winner.
    def get_winner(marker)
        if marker == @player1.marker
            puts "#{@player1.name} Wins"
        else
            puts "#{@player2.name} Wins"
        end
    end

    def check_for_draw?
        if @round <10
            return false
        else
            puts "Cat's Game!"
            return true
        end
    end

end

game = Game.new

error_duplicate = "!!! That square was already selected, choose another !!!"

puts "------------------"
puts "Start game with these settings?"
puts "Player One: #{game.player1.name} using marker '#{game.player1.marker}''"
puts "Player One: #{game.player2.name} using marker '#{game.player2.marker}''"

puts "HOW TO PLAY"
puts "--------------"
puts "Starting with player 1, #{game.player1.name}, type in the number you would like to place your marker in, and press enter when done."
puts "The board will update, and the next player will be prompted to select their marker."
puts "Press ENTER key when ready"
puts "--------------"
puts
gets.chomp
game.clear_console()
game.print_board()


while !game.win && !game.check_for_draw?
    if game.player1_turn
        puts "#{game.player1.name}, Enter the grid # you want to mark."
        5.times{print($line)}
        puts ""
        selection = game.valid_int?(game.player1)
    elsif !game.player1_turn
        puts "#{game.player2.name}, Enter the grid # you want to mark."
        5.times{print($line)}
        puts ""
        selection = game.valid_int?(game.player2)
    end
    game.check_win_conditions()
end

puts "game over"






