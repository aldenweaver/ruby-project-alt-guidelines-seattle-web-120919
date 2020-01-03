require 'pry'
require 'colorize'
require_relative 'user'
require_relative 'shift'
require_relative 'store'

class CommandLineInterface
    # User who is logged in
    @user = User.new

    def run
        greet

        login

        action_ask
    end

    #User is greeted and prompted with instructions
    def greet
        a = Artii::Base.new
        puts a.asciify('Shift Chains')
        puts "Welcome to Shift Chains!".colorize(:blue)
    end

    # User logs in by entering user ID or username - read
    def login
        puts "Please enter your username: ".colorize(:green)
        username = gets.chomp

        if(!User.find_by(login: username).nil?)
            @user = User.find_by(login: username)
            puts "Your upcoming shifts are: "
            show_shifts(find_all_shifts)
        else 
            puts "Login not found. Please try again.".colorize(:red)
            login
        end

    
    end

    def find_all_shifts
        # Refresh user object
        @user = User.find_by(id: @user.id)

        original_shifts = @user.shifts
        # Find all shifts the user has taken (taken_user_id == @user.id)
        taken_shifts = Shift.where(taken_user_id: @user.id)
        return original_shifts + taken_shifts
    end

    def show_shifts(shifts)
        puts "SHIFT ID|USER ID|STORE ID|        START TIME        |         END TIME         |TAKEN USER ID|".colorize(:blue)
        shifts.each do |shift|
            puts "#{shift.id}         #{shift.user_id}        #{shift.store_id}     #{shift.start_time}     #{shift.end_time}      #{shift.taken_user_id}"
            puts "\n"
        end
    end

    def action_ask 
        # READ
        puts "To see all open shifts, enter 'all_open_shifts'.".colorize(:red)

        # READ
        puts "To see all your shifts, enter 'my_shifts'.".colorize(:yellow)

        # UPDATE
        puts "To take a shift, enter 'take ' and the shift ID.".colorize(:green)
        
        # CREATE
        puts "To offer a shift, enter 'offer ' and the store ID.".colorize(:blue)
        
        # DELETE
        puts "To delete a shift, enter 'delete ' and the shift ID.".colorize(:cyan)

        # EXIT PROGRAM
        puts "To exit the program, enter 'exit'.".colorize(:magenta)

        response = gets.chomp
        check_response(response)
    end

    def check_response(response)
        if response.start_with?("all_open_shifts")
            all_open_shifts
            action_ask
        elsif response.start_with?("my_shifts")
            show_shifts(find_all_shifts)
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
        elsif response.start_with?("exit")
            return
        else
            puts "Please enter in a valid response!".colorize(:red)
            action_ask
        end
    end

    # READ
    # User can search for all shifts with all_open_shifts command
    # Returns only shifts that are available; 
    # i.e. shifts that have empty taken_user_ids
    # SELECT * FROM shifts WHERE taken_user_id IS NULL
    def all_open_shifts
        # A shift is open if there is no taken user ID
        open_shifts = Shift.where(taken_user_id: nil)

        # Handle nil errors by making sure there are open shifts
        if (!open_shifts.nil? && !open_shifts.empty?) 
            show_shifts(open_shifts)
        else
            # If no open shifts, tell the user
            puts "No open shifts found, please try again later!".colorize(:red)
        end        
        
    end

    # UPDATE
    # Users can take a shift using take_shift shift_id 
    # (updates the user_id on the shift)
    # Users can only take shifts that are not taken; i.e.,
    # shifts where taken_user_id is nil
    # UPDATE shifts
    # SET shift.taken_user_id = @user.id
    # WHERE shift.shift_id == shift_id
    # change taken_user_id from null to current user_id
    def take_shift(shift_id)
        # Find Shift corresponding to shift ID
        # If the Shift is not taken (aka taken_user_id is nil)
        # then allow them to take the shift
        if(Shift.find(shift_id).taken_user_id.nil?)
            Shift.update(shift_id, :taken_user_id => @user.id)
            puts "Shift #{shift_id} successfully taken.".colorize(:green)
        # Otherwise, tell them the shift is already taken
        else
            puts "Shift #{shift_id} is already taken.".colorize(:red)
        end
    
    end

    # CREATE
    # Users can offer a shift by using offer_shift store_id 
    # (shift_id will be auto generated)  - 
    # Prompt user for start_date end_date start_time end_time 
    # TODO EXTRA: Date/time validation
    def offer_shift(store_id)
        puts "Please enter the start date (YYYY-MM-DD): "
        start_date = gets.chomp

        puts "Please enter the end date (YYYY-MM-DD): "
        end_date = gets.chomp 

        puts "Please enter the start time in military time (HH:MM): "
        start_time = gets.chomp 

        puts "Please enter the end time in military time (HH:MM): "
        end_time = gets.chomp 

        # Combine date and time from user into DateTime to store in DB
        start_datetime = DateTime.parse(start_date + " " + start_time)
        end_datetime = DateTime.parse(end_date + " " + end_time)

        Shift.find_or_create_by(
            :user_id => @user.id,
            :store_id => store_id,
            :start_time => start_datetime,
            :end_time => end_datetime)

        puts "Shift successfully offered!".colorize(:green)
    end
    
    # DELETE
    # User can delete a shift they have offered - 
    # delete (deletes an entry from the shifts table)
    # DELETE * FROM shifts WHERE shift_id == shift_id
     def delete_shift(shift_id)
        # Find the shift_id and store the Shift object it corresponds to
        # Check that the Shift object exists
        # otherwise, print an error
        if(Shift.find_by(id: shift_id).nil?)
            puts "Shift not found.".colorize(:red)
            action_ask

        # If the user_id for the shift they want to delete
        # is their user ID, allow them to delete the shift
        # If it is not originally their shift, they cannot delete it
        elsif(Shift.find(shift_id).user_id == @user.id)
            Shift.find(shift_id).destroy
            puts "Shift #{shift_id} successfully deleted.".colorize(:green)
        else
            puts "You cannot delete this shift.".colorize(:red)
        end
    end
end