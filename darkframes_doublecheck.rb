iso_array = []
shutterspeed_array = []
frame_hash = {}
i = 0

puts "drag and drop directory"
url = gets.strip


#darkframes_doublecheck
Dir.foreach(url) do |item|
  #removes last four characters from filename
  # if they are not equal to .jpg the action proceeds
  if item.split(//).last(4).join.downcase != ".jpg"
    if item != "." && item != ".." && item != ".DS_Store"
    #pull in iso
      iso  = `exiftool -iso "#{url}/#{item}"`
      iso.slice!("ISO")
      iso.slice!(":")
      iso.lstrip!
      iso.chomp!
      i += 1
      print "\r" + iso + " " + "."*(i%3+1)
      iso_array.push iso 
    #pull in shutterspeed
      shutterspeed = `exiftool -shutterspeed "#{url}/#{item}"`
      shutterspeed.slice!("Shutter Speed")
      shutterspeed.slice!(":")
      shutterspeed.lstrip!
      shutterspeed.chomp!
      #puts shutterspeed
      shutterspeed_array.push shutterspeed

    #make a list of captured frames
      if frame_hash.has_key?(iso) == false
        frame_hash.store(iso, {})
      end
      frame_hash[iso].store(shutterspeed, true)
    end
  end
end

puts "Here are the values"
#Sort doesnt work on these two because they're strings
##puts iso_array.sort.uniq
##puts shutterspeed_array.sort.uniq
# puts iso_array.uniq
# puts shutterspeed_array.uniq

iso_array.each do |iso_holder|
  shutterspeed_array.each do |shutterspeed_holder|
    if frame_hash[iso_holder][shutterspeed_holder] != true
      frame_hash[iso_holder].store(shutterspeed_holder, false)
    end #frame_hash test
  end #shutterspeed_array iteration
end #iso_array iteration

frame_hash.keys.each do |iso_key|
  frame_hash[iso_key].keys.each do |shutter_key|
    if frame_hash[iso_key][shutter_key] == false
      puts iso_key + " " + shutter_key
    end #if frame_hash
  end
end #frame_hash.keys.each

puts frame_hash
##There has to be a way to correctly order the ShutterSpeeds and ISOs
#otherwise the csv will look all wrong
#final hash 
#take iso_array(ordered) and ss_array(ordered)
#ask fram_hash for it's value at those coordinates
#write them in the correct order in csv format
#export to .csv


#sorting might go something like this
#ss_array.each 
#if contains "/"
#frac = frac.split("/")
#1/(frac[1].to_i).to_f
#
def decimalator(frac) 
  if frac.include?("/") == true
    return eval(frac + ".0")
  else
    return frac
  end
end

#this is the sort array

# array.sort! {|a, b| 
#   next 1 if eval(b+".0") < eval(a+".0") 
#   next  -1 if eval(b+".0") > eval(a+".0")
#         0 
# }
  
#or something like this
#array.sort! {|a, b| 
#   next 1 if eval(b[0]+".0") < eval(a[0]+".0") 
#   next  -1 if eval(b[0]+".0") > eval(a[0]+".0")
#         0 
# }



# // This little script writes out all of the values to csv

# def write_file
#   hashes = [ { 'dog' => 'canine', 'cat' => 'feline', 'donkey' => 'asinine' },
#              { 'dog' => 'rover', 'cat' => 'kitty', 'donkey' => 'ass' } ]

#   CSV.open("data.csv", "w", headers: hashes.first.keys) do |csv|
#     hashes.each do |h|
#       csv << h.values
#     end
#   end
# end



# //double loop iterates through first key, and second key and displays values
# hash.keys.each do |lem|
#   hash[lem].keys.each do |bar|
#     puts lem + ", "+ bar + ", " + hash[lem][bar].to_s
#   end
# end

# // creates a list of all possible
# hashes.keys.each do |ram|
#   hashes[ram].keys.each do |bar|
#     array.push(bar)
#     array.uniq!
#   end
# end


# //after you have all of the shutterspeeds they can be used to call the values of each key
# array.each do |cram|
#   puts hashes["100"][cram]
# end




  #|   | 100 | 200 | 400 | 800 | < iso_array
  #|---|*---*|*---*|*---*|*---*|
  #|30s|true |true |true |true |
  #|25s|true |true |true |true |
  #|20s|true |true |true |false|
  # ^shutterspeed_array

#value of shutterspeed_array at iso_array == true make duplicate
#value of shutterspeed_array at iso_array == false make true
#value of shutterspeed_array at iso_array == duplicate do nothing