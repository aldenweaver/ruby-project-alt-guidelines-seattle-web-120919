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
        # elsif response.start_with?("take ")
        #     # parse response and pass
        #     shift_id = response.delete "take "
        #     take_shift(shift_id)
        # elsif response.start_with?("offer ")
        #     offer_shift(store_id, start_time, end_time)
        # elsif response.start_with?("delete ")
        #     shift_id = response.delete "delete "
        #     delete_shift(shift_id)
        else
            puts "Please enter in a valid response!"
            check_response
        end
    end

    # READ
    def all_open_shifts
        show_shifts(@shifts)
    end
end
    # # UPDATE
    # def take_shift(shift_id)
    # end

    # # CREATE
    # def offer_shift(store_id, start_time, end_time)
    # end
    
    # # DELETE
    # def delete_shift(shift_id)
    # end

    # # User can search for all shifts with 
    # # all_open_shifts command - read

    # def all_open_shifts
    # end

    # # User can search for all stores with 
    # # all_stores command - read
    # def all_stores
    # end

    # # Users can take a shift using 
    # # take_shift shift_id - update 
    # # (updates the user_id on the shift)
    # def take_shift(shift_id)
    # end
    
    # # Users can offer a shift by using 
    # # offer_shift store_id start_time end_time 
    # # (shift_id will be auto generated)  - 
    # # update or create (searches for shift; 
    # # if shift is there, it updates the user_id on the shift; 
    # # if the shift is not there it creates an entry in the shifts table)
    
    
    # # User can delete a shift they have offered - 
    # # delete (deletes an entry from the shifts table)

#     def offer_or_search 
#         puts "Would you like to offer up a shift (type 'offer'),
#                 search for a shift (type 'search'),
#                 delete a shift (type 'delete'),
#                 or see all your shifts (type 'my_shifts')?"

#         response = gets.chomp
#         if response == "offer"
#             offer
#         end
#         if response == "search"
#             search
#         end
#         if response == "delete"
#             delete
#         end
#         if response == "my_shifts"
#             display_user_shifts
#         end
#         else
#             puts "Please enter in a valid response!"
#             check_response
#         end
#     end

#     # def offer
#     #     puts "Please enter a store ID: "
#     #     store_id = gets.chomp

#     #     puts "Please enter a start day in the format MM/DD/YYY: "
#     #     start_date = gets.chomp

#     #     puts "Please enter a end day in the format MM/DD/YYY: "
#     #     end_date = gets.chomp

#     #     puts "Please enter a start time in military time in the format HH:MM: "
#     #     start_time = gets.chomp

#     #     puts "Please enter a start day in military time in the format HH:MM: "
#     #     end_time = gets.chomp

#     #     INSERT INTO 
#     #         shifts.user_id, 
#     #         shifts.store_id, 
#     #         shifts.start_date,
#     #         shifts.end_date,
#     #         shifts.start_time, 
#     #         shifts.end_time 
#     #     VALUES
#     #         user.id
#     #         store_id, 
#     #         start_date,
#     #         end_date,
#     #         start_time, 
#     #         end_time 
    
#     # Handle errors
#     # Provide success message
            
#     # end

#     def search
#         check_search_response

#         shift_take_ask
#     end

#     def shift_take_ask
#         puts "Would you like to take any of these shifts (Y/N)?"
#         response = gets.chomp

#         if response == "Y"
#             which_shift
#             take_shift
#         end

#         if response == "N"
#             dont_take_shift
#         end

#         else
#             puts "Please enter a valid response!"
#         end
#     end

#     def which_shift
#         puts "Which shift would you like to take? 
#             Please enter in the shift ID."
#         shift_id = gets.chomp
#         #

#     end

#     def take_shift
#         #change taken_user_id from null to current user_id
#     end

#     def dont_take_shift

#     end

#     def check_search_response
#         puts "Would you like to search by day (type 'day'),
#                 store (type 'store'), 
#                 or see all open shifts (type 'all')"
#         response = gets.chomp

#         if response == "day"
#             search_by_day
#         end
#         if response == "store"
#             search_by_store
#         end
#         if response == "all"
#             search_all
#         end
#         else
#             puts "Please enter in a valid response!"
#             check_search_response
#         end
#     end

#     def search_by_day
#         puts "Please enter a day in the format MM/DD/YYYY:"
#         day = gets.chomp
#         SELECT * FROM shifts WHERE start_date == day OR end_date == day
#         # Handle not found error
#         # puts "Please enter a correct date."
#         # puts "No open shifts found for this day."
#     end

#     def search_by_store
#         puts "Please enter a store ID: "
#         store_id = gets.chomp
#         SELECT * FROM shifts WHERE shifts.store_id == store_id
         
#         # Handle not found error
#         # puts "Store not found. Please check the ID and try again."
#         # puts "No open shifts found for this store."
#     end

#     def search_all
#         # Will return only shifts that are available; 
#         # i.e. shifts that have empty taken_user_ids
#         SELECT * FROM shifts WHERE taken_user_id IS NULL
#         # Handle not found error
#         # puts "No empty shifts found, please try again later!"
#     end

#     # def delete
#     #     puts "Please enter a shift ID to delete: "
#     #         shift_id = gets.chomp
#     #         DELETE * FROM shifts WHERE shift_id == shift_id
#     # Handle not found error
#     # Provide success message
#     # end
#     end
# end