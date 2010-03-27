local socket = require"socket" -- luarocks install luasocket
local http = require"socket.http"
local ltn12 = require"ltn12"
local lfs = require"lfs" --                        luafilesystem

-- Stolen from http://lua-users.org/wiki/TimeZone
local function getLocalTimezone()
  local now = os.time()
  local timezone = os.difftime(now, os.time(os.date("!*t", now)))
  local h, m = math.modf(timezone / 3600)
  return h + m*0.1
end
tz = getLocalTimezone()

do
	local d = os.date
	function os.date(s)
		return d(s, os.time()-tz*3600)
	end
	local p = print
	function print(m)
		p(d("%y/%m/%d %H:%M:%S: "..m.."."))
	end
end

while true do
	if not day then
		day = os.date("%y-%m-%d")
	end
	
	-- Look for output directory.
	for i in lfs.dir(lfs.currentdir()) do
		if i == day then
			target = i
		end
	end

	-- If output directory does not exist, create it.
	if not target then
		target = day
		print("Creating target directory "..target)
		lfs.mkdir(target)
	else
	-- For verbosity
		print("Using target directory "..target)
	end

	assert(lfs.chdir(target))
	print("Working directory changed to "..lfs.currentdir())

	-- Here we go!
	print("Starting loop")
	while true do
		if os.time() > (last1 or 0)+29.5 then
			last1 = os.time()
			print("Downloading from camera #1")
			http.request{ 
				url = "http://cam.facepunchstudios.com/current/camera_1.jpg?"..last1,
				sink = ltn12.sink.file(io.open("C1-"..os.date("%H-%M-%S")..".jpg", "w"))
			}
		end
		if os.time() > (last2 or 0)+9.5 then
			last2 = os.time()
			print("Downloading from camera #2")
			http.request{ 
				url = "http://cam.facepunchstudios.com/current/camera_2.jpg?"..last2,
				sink = ltn12.sink.file(io.open("C2-"..os.date("%H-%M-%S")..".jpg", "w"))
			}
		end
		if day ~= os.date("%y-%m-%d") then
			print("Changing day")
			break
		end
		socket.sleep(0.5)
	end
	day = nil
end
