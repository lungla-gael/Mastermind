require './player.rb'
COLORS = ["red","purple","teal","orange","brown","blue"]
POSITION = [1,2,3,4]

$human = Player.new("human")
$computer = Player.new("computer")
is_valid_input = false

def human_codebreaker
    puts "------------- Guess the secretCode!--------------"
    stop = false
    tries = 0
    loop do
        puts "-------------Guess Again!-------------" unless tries === 0
        $human.secret_code = {}
        $human.guess_secret_code
        
        feedback = []
        def matched?(color)
            value = false
            $computer.secret_code.each do |position,col|
                if col === $human.secret_code[position]
                    if col === color
                        value = true                
                    end
                end
            end
            value
        end

        $human.secret_code.each do |position, color|
            if $computer.secret_code.values.count(color) > 1 
                if color === $computer.secret_code[position]
                    feedback.push("black")
                    next
                else
                    feedback.unshift("white") if $human.secret_code.values.first(position).count(color) === 1 && matched?(color) == false
                    next
                end
            else
                if color === $computer.secret_code[position]
                    feedback.push("black")
                    next
                else
                    if matched?(color) == false && $computer.secret_code.values.include?(color)
                        feedback.unshift("white") if $human.secret_code.values.first(position).count(color) === 1
                        next
                    end 
                    next
                end
            end
        end
        
        if $human.secret_code.eql?($computer.secret_code)
            puts "would you look at that! You Win!"
            puts "---------------feedback---------------"
            p feedback
            puts "--------------------------------------"
            stop = true
        else
            puts "Wrong guess"
            puts "---------------feedback---------------"
            p feedback
            puts "--------------------------------------"
            stop = false
            puts "Common Sherlock! you are left with #{11-tries} guess#{"es" unless (11-tries) ===  1}"  unless (11-tries).eql?(0)
        end
        tries += 1
        if stop === true || tries === 12
            puts "You've exhausted all your chances" if tries === 12 
            puts "-------the secret code is--------"
            p $computer.secret_code
            puts "---------------------------------"
            break
        end
    end    
end

def artificial_codebreaker
    puts "-------------Computer guessing--------------"
    stop = false
    tries = 0
    loop do
        puts "-------------Guess Again!-------------" unless tries === 0
        $computer.guess_secret_code
        
        if $computer.secret_code.eql?($human.secret_code)
            puts "OOOoooH! you've been outwitted The AI Wins!"
            stop = true
        else
            puts "not smart enough"
            stop = false
            puts "Common AI just #{11-tries} guess#{"es" unless (11-tries) ===  1} left" unless (11-tries).eql?(0)
        end
        tries += 1
        if stop === true || tries === 12
            puts "You've exhausted all your chances" if tries === 12 
            puts "-------the secret code is--------"
            p $human.secret_code
            $human.secret_code = {}
            puts "---------------------------------"
            break
        end
    end
end

def play_again?
    puts "do you want to play again? yes/no"
    answer = gets.chomp
    true if answer === "yes"
end

while is_valid_input === false
    puts "Which role do you want to play codemaker/codebreaker?"
    role = gets.chomp
    case role
    when "codemaker"
        $computer.secret_code = {}
        $human.role = role
        $computer.role = "codebreaker"
        puts "the computer is the #{$computer.role}"
        $human.create_secret_code
        $computer.feedback = $human.secret_code
        artificial_codebreaker
        if play_again?
            is_valid_input = false
        else
            is_valid_input = true            
        end
    when "codebreaker"
        $human.role = role
        $computer.role = "codemaker"
        puts "the computer is the #{$computer.role}"
        $computer.create_secret_code
        human_codebreaker
        if play_again?
            is_valid_input = false
        else
            is_valid_input = true            
        end
    else
        puts "Sorry that role is not valid"
        is_valid_input = false
    end    
end
