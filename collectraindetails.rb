require 'csv'
require 'terminal-table'
require 'artii'
=begin
Rianfall collection challange:

1. Enter rainfalls for several months for different places.
2. Compare rainfalls between places for a particular month
3. Graph the rainfall as a bar chart

The process:

1. view current rainfall entries from the CSV file.
2. Add more rainfall data via user input.
=end


class Place
  def initialize(a_place) # ,year,month)
    @a_place = a_place
    #@year = year
    #@month = month
  end

  def year_month
    puts "Enter the Year of rainfall details for #{@a_place}?"
    year = $stdin.gets.chomp

    valid_months = ["January", "February", "March",
                    "April", "May", "June", "July",
                    "August", "September", "October",
                    "November", "December"]
    valid_months.each_with_index {|mth, index| puts "#{index+1} => #{mth} " }
    puts "Enter the month number from the above list:"
    month = $stdin.gets.chomp.to_i # month number is either 1 to 12
    month = valid_months[month-1]  # month number converted to month name
    # puts "Collecting rainfall stats for #{year} with month #{month}"
    return @a_place, year, month
  end # end method for def year_month

  def get_days(year,month)
    # the number of days within a month is determined by the year
    case month
    when "January", "March", "May", "July", "August", "October", "December"
      days = 31
    when "April", "June", "September", "November"
      days = 30
    else
      if year.to_i % 400 == 0 # feb has 28 days when a year divisible by 400
        days = 28
      elsif year.to_i % 4 == 0
        days = 29
      else
        days = 28
      end
    end # end statement for case month when ...
    return days
  end # end of collect_rainfall method

  def confirm_rainfall(rainfall)
    days = self.get_days(rainfall[1],rainfall[2])
    confirm_loop = true
    while confirm_loop
      puts "Rainfall collection for #{rainfall[0]} in #{rainfall[2]} of #{rainfall[1]} was:"
      print "\nDay: "
      # display rainfall days bewteen 1 to 12
      for i in 1..11
        print "#{i}".rjust(5)
      end
        puts ""
        print " mm: "
      for i in 3..13
        print "#{rainfall[i]}".rjust(5)
      end

      # display rainfall days bewteen 13 to 24
        print "\n\n"
        print "Day: "
      for i in 12..22
        print "#{i}".rjust(5)
      end
        print "\n"
        print " mm: "
      for i in 14..24
        print "#{rainfall[i]}".rjust(5)
      end

      # display rainfall days bewteen 25 to EOM
        print "\n\n"
        print "Day: "
      for i in 23..days
        print "#{i}".rjust(5)
      end
        print "\n"
        print " mm: "
      for i in 25..days+2
        print "#{rainfall[i]}".rjust(5)
      end
      print "\n\n"
      puts "Do you wish to change the Rainfall values? "
      puts "If not then hit Enter, otherwise enter the Day number."
      update_element = $stdin.gets.chomp.to_i
      if update_element == 0  # When using gets.chomp.to_i a nil return is 0
        # place details into CSV file
        confirm_loop = false
      else
        puts "The recorded rainfall for day #{update_element} was #{rainfall[update_element+2]}. "
        puts "Please enter the new recording:"
        rainfall[update_element+2] = $stdin.gets.chomp
      end
    end # end for confirm_loop
      return rainfall

  end # end method for confirm_rainfall

  def collect_rainfall(year,month)
    # the number of days within a month is determined by the year
    days = self.get_days(year,month)

    puts "Please enter the rainfall details in millimeters, eg: 11"
    rainfall = [@a_place, year, month]
    # loop is based on month days
    for day in 1..days
      if day > 1
        print "Day: "
        if day > 1 && day <= 11
            (1..day).each { |i| print "#{i}".rjust(5) }
        end
          puts
          print " mm: "
        if day > 1 and day <= 11
          (1..day).each { |i| print "#{rainfall[i+2]}".rjust(5) }
        end
      end
      puts
      if day > 11 && day <= 22
        print "Day: "
        (1..11).each { |i| print "#{i}".rjust(5) }
        puts
        print " mm: "
        (1..11).each { |i| print "#{rainfall[i+2]}".rjust(5) }
        print "\n\n"
        print "Day: "
        (12..day).each { |i| print "#{i}".rjust(5) }
        puts
        print " mm: "
        (12..day).each { |i| print "#{rainfall[i+2]}".rjust(5) }
      end
      puts
      if day > 22
        print "Day: "
        (1..11).each { |i| print "#{i}".rjust(5) }
        puts
        print " mm: "
        (1..11).each { |i| print "#{rainfall[i+2]}".rjust(5) }
        print "\n\n"
        print "Day: "
        (12..22).each { |i| print "#{i}".rjust(5) }
        puts
        print " mm: "
        (12..22).each { |i| print "#{rainfall[i+2]}".rjust(5) }
        print "\n\n"
        print "Day: "
        (23..day).each { |i| print "#{i}".rjust(5) }
        puts
        print " mm: "
        (23..day).each { |i| print "#{rainfall[i+2]}".rjust(5) }
      end
      puts
      puts "Enter rainfall on Day: #{day} for #{@a_place} at #{month} #{year}"
      rainfall.insert(day+2,$stdin.gets.chomp)
    end

    return rainfall
  end # end method for def collect_rainfall

end  # end of class Place

def append_csv(rainfall) # append rainfall details into CSV file
  filename = "rainfall_collection.csv"
  if !File.file?(filename) # places header information
    header = ["Place","year","Month",
      "day1","day2","day3","day4","day5","day6","day7","day8","day9","day10",
      "day11","day12","day13","day14","day15","day16","day17","day18","day19","day20",
      "day21","day22","day23","day24","day25","day26","day27","day28","day29","day30",
      "day31"]
    CSV.open(filename, "w+") do |hdr|
      hdr << header
      hdr << rainfall
    end
  else
    CSV.open(filename, "a+") do |mth|
      mth << rainfall
    end
  end # end for File.file? if file exists

end # end of method append_csv

def get_places(menu_opt) # read from CSV to display the places
  places = []
  filename = "rainfall_collection.csv"
  if !File.file?(filename) # places header information
    puts "No rainfall collection has been entered."
    puts
    puts "Please hit enter to go back to main menu."
    gets
  else
    CSV.foreach(filename, headers: true) do |row| # read line by line
      places << row[0] # row[0] is the place from each row
    end
    places = places.uniq
    puts "There is rainfall collection for the following places:"
    places.each_with_index {|loc, index| print "#{index+1}".rjust(5) +". " + "#{loc}\n"  }
    puts ""
    if menu_opt == 'add'
      puts "A".rjust(5) + ". To Add new place"
    end
    puts "X".rjust(5) + ". To exit"
    puts "Please select from above:"
    chosen = $stdin.gets.chomp.upcase

    if chosen == 'X'
      locale = nil
    elsif chosen == 'A'
      puts "Please enter the name of a new place?"
      locale = $stdin.gets.chomp
    elsif chosen.to_i > places.uniq.count
      puts "Not a valid choice."
      gets
      locale = nil
    else
      locale = places[chosen.to_i-1]  # the place chosen
    end
  end
  return locale
end # end method for def read_csv

def get_years(place)
  years = []
  puts "For #{place} please select the year you wish to view:"
  filename = "rainfall_collection.csv"
  CSV.foreach(filename, headers: true) do |row| # read line by line
    if place == row[0] # row[0] is the place from each row
      years << row[1] # row[1] is the year of the collected rainfalls
    end
  end
  years.uniq.each_with_index {|yr, index| print "#{index+1}".rjust(5) +". " + "#{yr}\n"  }
  puts ""
  puts "X".rjust(5) + ". To exit"
  puts "Please select from above:"
  chosen = $stdin.gets.chomp
  if chosen.upcase == 'X'
    year = nil
  elsif chosen.to_i > years.uniq.count
    puts "Not a valid choice."
    gets
    year = nil
  else
    year = years[chosen.to_i-1]  # the year chosen
  end
  return year
end # end of method for def get_years

def get_months(place,yearselect)
  months = []
  puts "Please select the month of #{yearselect} for #{place} you wish to view:"
  filename = "rainfall_collection.csv"
  CSV.foreach(filename, headers: true) do |row| # read line by line
    if place == row[0] # row[0] is the place from each row
      if yearselect == row[1] # row[1] is the year of the collected rainfalls
        months << row[2] # row[1] is the year of the collected rainfalls
      end
    end
  end
  months.uniq.each_with_index {|mth, index| print "#{index+1}".rjust(5) +". " + "#{mth}\n"  }
  puts ""
  puts "X".rjust(5) + ". To exit"
  puts "Please select from above:"
  chosen = $stdin.gets.chomp
  if chosen.upcase == 'X'
    month = nil
  elsif chosen.to_i > months.uniq.count
    puts "Not a valid choice."
    gets
    month = nil
  else
    month = months[chosen.to_i-1]  # the year chosen
  end
  # CSV month details into an array
  place_yr_mth = nil
  CSV.foreach(filename, headers: true) do |row| # read line by line
    # match on row[0] for place, row[1] for year, row[2] for month
    if place == row[0] && yearselect == row[1] && month == row[2]
      place_yr_mth  = row # dump the whole row into an array
    end
  end
  return place_yr_mth
end # end of method for def get_months(place,yearselect)

def intro
  clear  # execute method clear to clear screen and place logo
  puts '          "I cant stand the rain!!"  '
  puts ' Welcome to GK Rainfall collection application'
  puts '                Version 0.205'
  puts ' Hit enter to continue'
  gets
  end  # end for method: intro

def clear    # method that clears the screen and places the logo
  system "clear" or system "cls"
  logo = Artii::Base.new :font => 'slant'
  puts logo.asciify('Rainfall')
  puts
end  # end for method: clear

def menu_rainfall
  clear
  puts "Please select from the following options: "
  puts
  puts "1. View rainfall details"
  puts "2. Add rainfall details"
  # puts "3. Delete rainfall details"
  puts
  puts "x. to exit "
  menuoption = $stdin.gets.chomp.upcase
  return menuoption
end

#### Main program
#### body



# while loop for collecting storing and displaying information

intro # call the intro before menu selection
main_menu = true
while main_menu

  menuption = menu_rainfall
  case menuption
  when "X"
    main_menu = false
  when "1"
    place = get_places("view") # list of places with rainfall details
    if !place.nil? # if place has been chosen
      yearselect = get_years(place) # get year of rainfall details
      if !yearselect.nil?
        mthselect = get_months(place,yearselect) # get the months of rainfall details
        if !mthselect.nil?
          clear
          locale = Place.new(place) # create instance for Place class
          confirmation = locale.confirm_rainfall(mthselect)
        end # end if for !mthselect.nil?
      end # end if for !yearselect.nil?
    end  # end if for !place.nil?
  when "2"
    place = get_places("add") # list of places with rainfall details
    if !place.nil? # if place has been chosen
      locale = Place.new(place)
      yearmonth = locale.year_month
      month_details = locale.collect_rainfall(yearmonth[1],yearmonth[2])
      clear
      confirmation = locale.confirm_rainfall(month_details)
      # append confirmation into csv
      append_csv(confirmation)
      puts "Rainfall details was added into CSV for:"
      puts "#{confirmation[0]} in #{confirmation[2]} of #{confirmation[1]}"
      puts "Press enter to go back to main menu."
      gets
    end
  when "3"
    main_menu = false
  else
    puts "Not a valid option!!"
    gets
  end # end for case menuption

end # end of while loop for main menu
