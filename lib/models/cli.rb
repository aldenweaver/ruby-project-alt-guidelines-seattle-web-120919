require 'pry'

class CommandLineInterface
    def greet
        puts "Welcome to Shift Chains!"
    end

    def run
        greet

        puts "Please enter your username: "
        username = gets.chomp
        puts username
        # binding.pry
        user = User.find_by(login: username)
        puts show_shifts(user.shifts)
    end

    def show_shifts(shifts)
        shifts.each do |shift|
            puts "ID:  #{shift.id}"
            puts "User ID:  #{shift.user_id}"
            puts "Store ID:  #{shift.store_id}"
            puts "Start Time:  #{shift.start_time}"
            puts "End Time:  #{shift.end_time}"
            puts "Taken User ID:  #{shift.taken_user_id}"
            # puts shift.user_id
        end
    end


end