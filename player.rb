class Player
    COLORS = ["red","purple","teal","orange","brown","blue"]
    POSITION = [1,2,3,4]
    attr_accessor :role, :secret_code, :feedback
    attr_reader :id
    def initialize(id)
        @id = id
        @role = ""
        @secret_code = {}
        @feedback = {}
    end

    def create_secret_code
        4.times { |key| secret_code[key+1] = COLORS[rand(6)]} if role.eql?("codemaker") && id.eql?("computer")
        if role.eql?("codemaker") && id.eql?("human")
            puts "----------Enter your Secret code-----------"
            puts "peg positions : #{POSITION}  peg colors : #{COLORS}"
            4.times{ |i|
                loop do
                    puts "enter details for peg #{i+1}"
                    print "position : "
                    position = gets.chomp.to_i
                    print "color : "
                    color = gets.chomp
                    if POSITION.include?(position) && COLORS.include?(color)
                        if secret_code.has_key?(position)
                            puts "position #{position} is occupied"
                        else                        
                            secret_code[position] = color
                            break
                        end
                    else
                        puts "#{position} is not a valid position" unless POSITION.include?(position)
                        puts "#{color} is not a valid color" unless COLORS.include?(color)
                        puts "try again"
                    end                   
                end
            }
            p secret_code
        end
    end

    def matched(color,human_code,computer_code)
        value = false
        result = []
        human_code.each do |position,col|
            if col === computer_code[position]
                result.push(position)
                if col === color
                    value = true                
                end
            end
        end
        result.unshift(value)
    end

    def guess_secret_code
        if role.eql?("codebreaker") && id.eql?("human")
            puts "peg positions : #{POSITION}  peg colors : #{COLORS}"
            4.times{ |i|
                loop do
                    puts "enter details for peg #{i+1}"
                    print "position : "
                    position = gets.chomp.to_i
                    print "color : "
                    color = gets.chomp
                    if POSITION.include?(position) && COLORS.include?(color)
                        if secret_code.has_key?(position)
                            puts "position #{position} is occupied"
                        else                        
                            secret_code[position] = color
                            break
                        end
                    else
                        puts "#{position} is not a valid position" unless POSITION.include?(position)
                        puts "#{color} is not a valid color" unless COLORS.include?(color)
                        puts "try again"
                    end                   
                end
            }
        end

        if role.eql?("codebreaker") && id.eql?("computer")
            previous_code = secret_code
            if secret_code.empty?
                4.times { |key| secret_code[key+1] = COLORS[rand(6)]}
            else
                free_positions = [1,2,3,4]
                feedback.each do |idx,val|
                    if previous_code[idx].eql?(val)
                        secret_code[idx] = val
                        free_positions.delete(idx)                        
                        next
                    else
                        check_Array = matched(previous_code[idx],feedback,previous_code)
                        check_Array.each do |item|
                            if free_positions.include?(item)
                                free_positions.delete(item)
                            end
                        end
                        pos = free_positions[rand(free_positions.length)]
                        if feedback.values.include?(previous_code[idx]) && check_Array.first === false
                            secret_code[pos] = previous_code[idx]
                            free_positions.delete(pos)                            
                            next
                        else
                            secret_code[pos] = COLORS[rand(6)]
                            free_positions.delete(pos)                            
                            next
                        end
                    end
                end
            end
        end
        p secret_code
    end
end