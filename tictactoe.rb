class Player
    attr_reader :name, :marker
    @@player = 0

    def initialize(name,marker)
        @name = name
        @marker = marker
        @@player += 1

    end
end

class Board
   # @@board = {:r1 => {:c1 => ".", :c2 => ".", :c3}, :r2 => {:c1 => ".", :c2 => ".", :c3}, :r3 => {:c1 => ".", :c2 => ".", :c3}}
end

def CreatePlayers
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
    $player1 = Player.new(players[:One][:name], players[:One][:marker])
    $player2 = Player.new(players[:Two][:name], players[:Two][:marker])

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

board = {:r1 => {:c1 => ".", :c2 => ".", :c3 => "."}, :r2 => {:c1 => ".", :c2 => ".", :c3 => "."}, :r3 => {:c1 => ".", :c2 => ".", :c3 => "."}}

board.each do |row, col|
    
end
CreatePlayers()

puts "------------------"
puts "Start game with these settings?"
puts "Player One: #{$player1.name} using marker '#{$player1.marker}''"
puts "Player One: #{$player2.name} using marker '#{$player2.marker}''"