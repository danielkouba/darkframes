## TODO
### Start a bookmark; start test at a certain iso and shutterspeed
###----create a user input to ask iso and shutterspeed 
###----write them to variables
###----search respective arrays for those values
###------if those values dont exist, either offer a close iso or ss
###----otherwise begin test at that array value and proceed to iterate upwards
###	Battery Warning
###	Dump last shot settings

def initialize
	iso_array = []
	shutterspeed_array = []
	n = 0
	i = 0
	


	puts #simply for readability
	puts
	puts
	
	puts "Set Camera to Manual Setting."
	gets
	puts "Set Camera to Capture RAW only."
	gets
	puts "Set Camera to Manual focus."
	gets

##This is how we determine what extension to add to the filename
	while i == 0
	  puts "What kind of Camera is this?"
	  puts "1. Canon"
	  puts "2. Nikon"
	  puts "3. Other"
	  n = gets.chomp
		if n == "1"
			extension = "CR2"
			manu = "Canon"
			i = 1
		elsif n == "2"
			extension = "NEF"
			manu = "Nikon"
			i = 1
		elsif n == "3"
			puts "Enter a file extension:"
			extension = gets.chomp
			puts "Do you want to use .#{extension}? Y/N"
			answer = gets.chomp
			if answer.downcase == "y"
				i = 1
			elsif answer.downcase == "n"
				i = 0
			else
				i = 0
			end
		else
			puts "Please enter a number."
			i = 0
		end
		puts #simply for readability
		puts
		puts
	end
	
	#build destination folder
	#Dir.chdir("desktop/darkframes")
	`mkdir #{manu}`
	Dir.chdir(manu)
	`mkdir darkframes`
	Dir.chdir("darkframes")
			
	#prepare camera to be interfaced with
	`killall PTPCamera`
	 
	#detect camera and name
	puts `gphoto2 --auto-detect`



#-------------------------------------
#        ISO SETTINGS
#-------------------------------------
	#obtain available ISOs
	holder = `gphoto2 --get-config=iso`
	#write the ISOs to an array splitting at the spaces
	#this will require further formatting to clear 
	#the values other than ISOs
	iso_array = holder.split(' ')
	iso_array.delete_if { |a| a == "Choice:" || a == "Label:" || a == "ISO" || a == "Type:" || a == "Speed" ||  a == "RADIO" || a == "Current:"  }
	iso_array.shift #this removes the first iso which is the "current iso"
	iso_array.keep_if {|v| iso_array.index(v).odd?}
	iso_array.map! { |e| e.to_i  }
	iso_array.delete_if { |z| z.to_i == 0}


#-------------------------------------
#        SHUTTERSPEED SETTINGS
#-------------------------------------
	#obtain available shutterspeeds
	holder = `gphoto2 --get-config=shutterspeed`
	#write the shutter speeds to an array, splitting at the spaces
	#this will require further formatting to clear 
	#the values other than shutter speeds
	shutterspeed_array = holder.split(' ')
	shutterspeed_array.delete_if { |a| a == "Choice:" || a == "Label:" || a == "Type:" || a == "Speed" ||  a == "RADIO" || a == "Current:" || a == "Shutter" }
	shutterspeed_array.shift #removes "current shutter speed"
	#shutterspeed_array.pop # TODO if above certain number of seconds, remove Bulb limiter
	shutterspeed_array.keep_if {|v| shutterspeed_array.index(v).odd?}
	#shutterspeed_array.map! {|e| e.delete('s').to_frac}
	shutterspeed_array.keep_if {|v| v.delete('s').to_frac <= 120.0} #maximum shutterspeed is 2minutes
#end

#-------------------------------------
#        RUNNING THE TEST
#-------------------------------------

#def darkframes
	#the purpose of darkframes is to run
	#every shutterspeed at every ISO.

	iso_array.each do |iso_holder|
		#set the ISO on the camera
		`gphoto2 --set-config iso=#{iso_holder}`

		shutterspeed_array.each do |shutterspeed_holder|
			if File.file?("iso#{iso_holder}_ss#{shutterspeed_holder}sec.#{extension}") != true
				#set the shutterspeed on the camera
				`gphoto2 --set-config shutterspeed=#{shutterspeed_holder}`

				#take the picture
				puts "iso: #{iso_holder} shutterspeed: #{shutterspeed_holder}"
				`gphoto2  --capture-image-and-download --folder /darkframes --filename=iso#{iso_holder}_ss#{shutterspeed_holder}sec.#{extension}`
			else
				puts "iso: #{iso_holder} shutterspeed: #{shutterspeed_holder} exists"
			end #if
		end   #shutterspeed_array.each
	end     #iso_array.each

end #def initialize

#this is used to format shutterspeeds given in fractions
class String
	def to_frac
		numerator, denominator = split('/').map(&:to_f)
		denominator ||= 1
		numerator/denominator
	end
end

initialize