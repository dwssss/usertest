# Lockerz coding exercise => https://gist.github.com/amorphid/fdd3e0d8c7a69354c7c1
# 
# Author:  David Szeto
#
# This program models the lockers in a Hash Array with 3000 keys
#  Each key is of the form snnn  where
#  s is the size of the locker:  1 - small, 2 - medium, 3- large
#  nnn is the locker no.  
#  For example:  10001  is the first small locker, 20010 is the 10th medium locker.
#  This program will ask for a lockerz data file name, say lockerz.data
#  If the file does not exist, it will initialize the file with 3 thousand entries
#    10001,0 till 11000,0 indicating that all 1000 small lockers are available.
#    20001,0 till 21000,0 indicating that all 1000 medium lockers are available.
#    30001,0 till 31000,0 indicating that all 1000 large lockers are available.
#   
# Then the program will ask for action:  exit, checkin or checkout.

# Sample data file: lockerz.data
# Sample runs.
# 
#  To run do:   ruby lockerz.rb
#
# Does not need database, internet, nor rails.





#  Note:  e.g. use Input file : 'lockerz.data'

puts "Please enter the name of the lockerz data file"

input_file=gets.chomp

puts "File name you entered is #{input_file}"

if (File.file? input_file)
  ## needs work inside this block
  puts "Opening #{input_file} for reading"
  lockerz_hash=Hash.new
  keys=[]
  fileIn = File.open(input_file, 'r')
  if (fileIn)
    linesin =+ 1
    fileIn.each_line do |line|
      key,value=line.split(",")
      lockerz_hash[key]=value.gsub( /\n/, "" )        
    end 
  else
    puts "Cannot open input file #{input_file}"
  end
else
  puts "File does not exist or location is wrong, initialize new lockerz file? Enter : init"
  initfile=gets.chomp
  exit unless initfile == 'init'
  ## initialize array lockerz{locker_size,locker_no} to 0 for not occupied.
  key1=[*"10001".."11000"]
  key2=[*"20001".."21000"]
  key3=[*"30001".."31000"]
  keys=key1+key2+key3
  puts " keys[0]:  #{keys[0]} "
  puts " keys[999]:  #{keys[999]} "
  puts " keys[1000]:  #{keys[1000]} "
  puts " keys[2000]:  #{keys[2000]} "
  puts " keys[2000]:  #{keys[2999]} "
  lockerz_hash=Hash[keys.each_with_object("0").to_a]

  fileOut = File.open(input_file, 'w')
  lockerz_hash.keys.each do |k|
    line="#{k},#{lockerz_hash[k]}\n"
    fileOut.write(line)
  end
  fileOut.close


end

#  At this point the Hash is read and ready for processing.

while true do
   puts " Please enter :  exit, checkin or checkout "
   action = gets.chomp
   case action
   when /checkin/    
    puts "checkin, please enter bagsize:  1 for small, 2 for medium, 3 for large"
    line_no=0
    bagsize=gets.chomp
    checked_in="no"
    fileOut = File.open(input_file, 'w')
    lockerz_hash.keys.each do |k|
      line_no += 1
      if lockerz_hash[k]=="0" and k[0]==bagsize and checked_in=="no"
        lockerz_hash[k]="1"  
        checked_in="yes"
        puts " your bag is checked in; the ticket no is: #{k}"
        end      
      line="#{k},#{lockerz_hash[k]}\n"
      #puts " line_no:  #{line_no}  #{line}"
      fileOut.write(line)
      end
    fileOut.close
    ##  end checkin ##

   when /checkout/
    puts "checkout, please enter your ticket no"
    ticket_no=gets.chomp
    fileOut = File.open(input_file, 'w')
    lockerz_hash.keys.each do |k|
      line_no += 1
      if k==ticket_no then 
        lockerz_hash[k]="0"  
        puts " your bag is checked out; the ticket no was: #{k}"
        end      
      line="#{k},#{lockerz_hash[k]}\n"
      #puts " line_no:  #{line_no}  #{line}"
      fileOut.write(line)
      end
    fileOut.close
    ##  end checkout ##

   when /exit/
    break
    
   else
    puts "none of the above"
    break

  end
end


puts "exit from loop"

##  then update the file ...

