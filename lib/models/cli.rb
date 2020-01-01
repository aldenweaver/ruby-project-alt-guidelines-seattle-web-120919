require 'pry'
require_relative 'user'
require_relative 'shift'
require_relative 'store'

class CommandLineInterface
    @user = User.new
    @shifts = []

    def run
        greet

        login

        action_ask
        # offer_or_search
    end

    #User is greeted and prompted with instructions
    def greet
        puts "Welcome to Shift Chains!"
    end

    # User logs in by entering user ID or username 
    # (no password, add user-friendly fail) - read
    def login
        puts "Please enter your username: "
        username = gets.chomp
        # puts username
        # binding.pry
        @user = User.find_by(login: username)
        @shifts = Shift.all
        # TODO: add fail happy

        puts "Your upcoming shifts are: \n"
        puts show_shifts(@user.shifts)

        # TODO: also show shifts they have taken 
        # by comparing to taken_user_id
    end

    def show_shifts(shifts)
        shifts.each do |shift|
            puts "Shift ID:  #{shift.id}"
            puts "User ID:  #{shift.user_id}"
            puts "Store ID:  #{shift.store_id}"
            puts "Start Time:  #{shift.start_time}"
            puts "End Time:  #{shift.end_time}"
            puts "Taken User ID:  #{shift.taken_user_id}"
            puts "\n"
            # puts shift.user_id
            # TODO: Table formatting, date/time formatting
        end
    end

    def action_ask 
        # READ
        puts "To see all open shifts, enter 'all_open_shifts'."
    
        # UPDATE
        puts "To take a shift, enter 'take ' and the shift ID."
        
        # CREATE
        puts "To offer a shift, enter 'offer ' and the store ID, 
            start time, and end time in x format."
        
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
            # parse response and pass
            shift_id = response.delete "take "
            take_shift(shift_id)
            action_ask
        # elsif response.start_with?("offer ")
        #     offer_shift(store_id, start_time, end_time)
        # action_ask
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
    def all_open_shifts
        # TODO: shows all shifts regardless of whether or not they are open; fix this
        show_shifts(@shifts)

        # Will return only shifts that are available; 
#         # i.e. shifts that have empty taken_user_ids
#         SELECT * FROM shifts WHERE taken_user_id IS NULL
#         # Handle not found error
#         # puts "No empty shifts found, please try again later!"
# 
    end

    # # UPDATE
     # # Users can take a shift using 
    # # take_shift shift_id - update 
    # # (updates the user_id on the shift)
    def take_shift(shift_id)
        shift = Shift.find_by id: shift_id
        shift.taken_user_id = @user.id
        # TODO: doesn't throw error but doesn't persist to DB
    # UPDATE shifts
    # SET shift.taken_user_id = @user.id
    # WHERE shift.shift_id == shift_id
    # change taken_user_id from null to current user_id
    # Handle if taken_user_id is not null?
    puts "Shift #{shift_id} successfully taken."
    end

    # # CREATE
    # # Users can offer a shift by using 
    # # offer_shift store_id start_time end_time 
    # # (shift_id will be auto generated)  - 
    # # update or create (searches for shift; 
    # # if shift is there, it updates the user_id on the shift; 
    # # if the shift is not there it creates an entry in the shifts table)
    def offer_shift(store_id, start_time, end_time)
    end
    
    # # DELETE
    # # User can delete a shift they have offered - 
    # # delete (deletes an entry from the shifts table)
     def delete_shift(shift_id)
#     #   DELETE * FROM shifts WHERE shift_id == shift_id
#     # Handle not found error
#     # Provide success message
        Shift.find(shift_id).destroy
        puts "Shift #{shift_id} successfully deleted."
    end
end