class Player
    attr_accessor :name, :marker
    @@player = 0

    def initialize(name,marker)
        @name = name
        @marker = marker
        @@player += 1
    end
end

module Board
    def print_board()
        line = "\u2500"
        count = 0
        @board.each do |row, cols|
            puts "#{cols[:c1]} | #{cols[:c2]} | #{cols[:c3]}"
            if count < 2
                puts line + line + line + line + line + line + line + line + line + line
            end
            count += 1
        end
    end 

    def update_board(player, position)
        @board.each do |row, cols|
            cols.each do |col, val|
                if val == position
                    @picked_squares.push(val)
                    @board[row][col] = player.marker
                end
            end
        end
        print_board()
    end
end

class Game
    attr_reader :board, :win, :player1, :player2
    attr_accessor :player1_turn
    include Board
    
    def initialize
        @board = {:r1 => {:c1 => "1", :c2 => "2", :c3 => "3"}, :r2 => {:c1 => "4", :c2 => "5", :c3 => "6"}, :r3 => {:c1 => "7", :c2 => "8", :c3 => "9"}}
        @picked_squares = []
        @win = false
        @player1_turn = true
    end

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
                player[:marker] = GetMarker(player[:name])
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

    def check_for_duplicate(selection)
        @picked_squares.include? selection
    end

    def get_winner(marker)
        if marker == @player1.marker
            puts "#{@player1.name} Wins"
        else
            puts "#{@player2.name} Wins"
        end
    end

    def check_win_conditions()
        full_array = []
        check_array = []

        #Check for wins across ROWS
        @board.each do |row, cols|
            check_array = cols.values #Create array with with each individual row
            full_array += check_array #Create array with all of the squares for later use.
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
end



def GetMarker(name)
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
game = Game.new



game.create_players()
selected_error = "!!! That square was already selected, choose another !!!"

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
game.print_board()


while !game.win
    if game.player1_turn
        while true
            puts "#{game.player1.name}, Enter the grid # you want to mark."
            selection = gets.chomp
            if !game.check_for_duplicate(selection)
                game.update_board(game.player1, selection)
                game.player1_turn = false
                break
            else
                puts selected_error
            end
        end
    elsif !game.player1_turn
        while true
            puts "#{game.player2.name}, Enter the grid # you want to mark."
            selection = gets.chomp
            if !game.check_for_duplicate(selection)
                game.update_board(game.player2, selection)
                game.player1_turn = true
                break
            else
                puts selected_error
            end
        end
    end
    game.check_win_conditions()
end

puts "game over"






