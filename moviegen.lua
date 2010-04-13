local lfs = require"lfs"

out = true

if arg then
    if arg[1] == "auto" then
        day = os.date("%y-%m-%d")
    else
        day = arg[1]
    end
    cam = arg[2]
    out = arg[3] and nil
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
if out then print("mencoder is done! Running ffmpeg...") end
ffmg = io.popen("ffmpeg -i C"..cam.."-"..day..".avi -b 512000 C"..cam.."-"..day..".mp4 2>/dev/null")
ffmg:read("*all")
if out then print("ffmpeg is done! Removing the mjpeg video...") end
os.remove("C"..cam.."-"..day..".avi")
if out then print("All is well!") end
