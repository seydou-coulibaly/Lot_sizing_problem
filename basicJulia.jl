######
#Three basic containers
######
#Arrays
lyrics = ["Never", "Gonna", "Give", "You", "Up"]
println(lyrics)

#arrays can be modified (1-based)
#Modify arrays (1-based)
lyrics[3] = "Let"
lyrics[5] = "Down"
println(lyrics)

#Tuples - like "fixed" arrays
yolo = ("you", "only", "live", "once")
#yolo[end] = "twice" #Raises an error

oddList = Int[]
for i in 1:20
    if i % 2 == 1
        push!(oddList, i)
    end
end
print(oddList)

#Solution 3
#oddList3 = [1:20]
#oddList3 = oddList3[oddList3 .% 2 .== 1]
#print(oddList3)

friendsFood = [ "Daenerys Targaryen"=>3, "Jorah Mormont"=>1, "Tywin Lannister"=>5, "Tyrion Lannister"=>2, "Shae"=>1, "Cersei Lannister"=>3, "Joffrey Baratheon"=>0, "Ned Stark"=>1, "Robb Stark"=>2, "Jon Snow" => 3]
#friends = keys(friendsFood)
println(friendsFood[2])

a=[]
# try, catch can be used to deal with errors as with many other languages
try
    push!(a,10)
catch err
    showerror(STDOUT, err, backtrace());println()
end
println("Continuing after error")
println(a)
