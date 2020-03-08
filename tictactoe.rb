class Player
    attr_reader :name, :marker, :player_number
    @@player = 0

    def initialize(name,marker)
        @name = name
        @marker = marker
        @@player += 1
        @player_number = @@player
    end

end

puts "Player One, enter your name:"
p1_name = gets.chomp
puts "#{p1_name}, Would you like your marker to be X or O?"
while true
    p1_marker = gets.chomp
    puts p1_marker
    if p1_marker.downcase == ("x" || "o")
        break
    else
        puts "Please Select X or O"
    end
end

player1 = Player.new("james", "X")

puts player1.name
puts player1.marker
puts player1.player_number

player2 = Player.new("Ashley", "O")

puts player2.name
puts player2.marker
puts player2.player_number