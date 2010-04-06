local lfs = require"lfs"

if arg then
    if arg[1] == "auto" then
        day = os.date("%y-%m-%d")
    else
        day = arg[1] or nil
    end
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

if cam == "1" then
    fps = 5
elseif cam == "2" then
    fps = 10
end

menc = io.popen("mencoder -msglevel all=1 -mf w=640:h=480:fps="..fps.." -ovc copy -o C"..cam.."-"..day..".avi mf://"..day.."/C"..cam.."*.jpg")
menc:read("*all") -- wait for it to finish
print("Mencoder is done! Running ffmpeg...")
os.execute("ffmpeg -i C"..cam.."-"..day..".avi -b 512000 C"..cam.."-"..day..".mp4 2>/dev/null")
print("ffmpeg is done! removing the mjpeg video...")
os.remove("C"..cam.."-"..day..".avi")
print("All is well!")
