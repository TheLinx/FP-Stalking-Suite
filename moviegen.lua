local lfs = require"lfs"

if arg then
	day = arg[1] or nil
	cam = arg[2] or nil
end

if not day then
	io.write("Choose a date: ")
	day = io.read("*l")
end
if not lfs.attributes(day) then print("You must choose a valid date!") error() end

if not cam then
	io.write("Choose a camera: ")
	cam = io.read("*l")
end

os.execute("mencoder -mf w=640:h=480:fps=10 -ovc copy -o C"..cam.."-"..day..".avi mf://"..day.."/C"..cam.."*.jpg")
