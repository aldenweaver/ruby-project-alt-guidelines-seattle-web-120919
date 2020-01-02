require 'pry'
require_relative 'user'
require_relative 'shift'
require_relative 'store'

class CommandLineInterface
    @user = User.new

    def run
        greet

        login

        action_ask
    end

    #User is greeted and prompted with instructions
    def greet
        puts "Welcome to Shift Chains!"
    end

    # User logs in by entering user ID or username 
    # (no password, add user-friendly fail) - read
    # TODO: also show shifts they have taken 
    # by comparing to taken_user_id
    # TODO: add fail happy
    def login
        puts "Please enter your username: "
        username = gets.chomp

        @user = User.find_by(login: username)

        puts "Your upcoming shifts are: \n"
        puts show_shifts(@user.shifts)

    
    end

    # TODO: Parse out start/end day and make pretty with columns
    def show_shifts(shifts)
        shifts.each do |shift|
            puts "Shift ID:  #{shift.id}"
            puts "User ID:  #{shift.user_id}"
            puts "Store ID:  #{shift.store_id}"
            puts "Start Time:  #{shift.start_time}"
            puts "End Time:  #{shift.end_time}"
            puts "Taken User ID:  #{shift.taken_user_id}"
            puts "\n"
        end
    end

    def action_ask 
        # READ
        puts "To see all open shifts, enter 'all_open_shifts'."
    
        # UPDATE
        puts "To take a shift, enter 'take ' and the shift ID."
        
        # CREATE
        puts "To offer a shift, enter 'offer ' and the store ID"
        
        # DELETE
        puts "To delete a shift, enter 'delete ' and the shift ID."

        response = gets.chomp
        check_response(response)
    end

    def check_response(response)
        if response.start_with?("all_open_shifts")
            all_open_shifts
            action_ask
        elsif response.start_with?("take ")
            shift_id = response.delete "take "
            take_shift(shift_id)
            action_ask
        elsif response.start_with?("offer ")
            store_id = response.delete "offer "
            offer_shift(store_id)
            action_ask
        elsif response.start_with?("delete ")
            shift_id = response.delete "delete "
            delete_shift(shift_id)
            action_ask
        else
            puts "Please enter in a valid response!"
            check_response
        end
    end

    # READ
    # # User can search for all shifts with 
    # # all_open_shifts command - read
    # TODO: shows all shifts regardless of whether or not they are open; fix this
    # Should return only shifts that are available; 
    # i.e. shifts that have empty taken_user_ids
    # SELECT * FROM shifts WHERE taken_user_id IS NULL
    # Handle not found error
    # puts "No empty shifts found, please try again later!"
    def all_open_shifts        
        show_shifts(Shift.all)
    end

    # UPDATE
    # Users can take a shift using take_shift shift_id - update 
    # (updates the user_id on the shift)
    # UPDATE shifts
    # SET shift.taken_user_id = @user.id
    # WHERE shift.shift_id == shift_id
    # change taken_user_id from null to current user_id
    # TODO: Handle if taken_user_id is not null - they shouldn't be able to take it
    def take_shift(shift_id)
        Shift.update(shift_id, :taken_user_id => @user.id)

        puts "Shift #{shift_id} successfully taken."
    end

    # # CREATE
    # # Users can offer a shift by using 
    # # offer_shift store_id start_time end_time 
    # # (shift_id will be auto generated)  - 
    # # update or create (searches for shift; 
    # # if shift is there, it updates the user_id on the shift; 
    # # if the shift is not there it creates an entry in the shifts table)
    def offer_shift(store_id)
        puts "Please enter the start date (YYYY-MM-DD): "
        start_date = gets.chomp

        puts "Please enter the end date (YYYY-MM-DD): "
        end_date = gets.chomp 

        puts "Please enter the start time (HH:MM): "
        start_time = gets.chomp 

        puts "Please enter the end time (HH:MM): "
        end_time = gets.chomp 

        # Combine date and time from user into DateTime to store in DB
        start_datetime = DateTime.parse(start_date + " " + start_time)
        end_datetime = DateTime.parse(end_date + " " + end_time)

        Shift.create(
            :user_id => @user.id,
            :store_id => store_id,
            :start_time => start_datetime,
            :end_time => end_datetime,
            :taken_user_id => nil)
    end
    
    # DELETE #
    # User can delete a shift they have offered - 
    # delete (deletes an entry from the shifts table)
    # DELETE * FROM shifts WHERE shift_id == shift_id
    # TODO: Handle not found error
    # TODO: User can only delete a shift with their id on it
     def delete_shift(shift_id)
        Shift.find(shift_id).destroy
        puts "Shift #{shift_id} successfully deleted."
    end
end