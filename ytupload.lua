require"lfs"
require"socket"

-- this doesn't work for some reason
-- T.T

local uph = [[POST /feeds/api/users/default/uploads HTTP/1.1
Host: uploads.gdata.youtube.com
Authorization: GoogleLogin auth=%s
GData-Version: 2
X-GData-Key: key=%s
Slug: %s
Content-Type: multipart/related; boundary="dwh8d7agwd7gwag7"
Content-Length: %d
Connection: close
]]
--[[ FYI
 1: Google Auth key.
 2: API key.
 3: Video filename.
 4: Size of content.
--]]
local upc = [[

--dwh8d7agwd7gwag7
Content-Type: application/atom+xml; charset=UTF-8

<?xml version="1.0"?>
<entry xmlns="http://www.w3.org/2005/Atom"
  xmlns:media="http://search.yahoo.com/mrss/"
  xmlns:yt="http://gdata.youtube.com/schemas/2007">
  <media:group>
    <media:title type="plain">Facepunch Studios: Camera %d on %s.</media:title>
    <media:description type="plain">
      Generated by the FP stalking suite.
    </media:description>
    <media:category
      scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Entertainment
    </media:category>
    <media:keywords>facepunch, facepunch studios, camera %d, garry, garrys mod, gmod, botch</media:keywords>
  </media:group>
</entry>
--dwh8d7agwd7gwag7
Content-Type: video/jpeg
Content-Transfer-Encoding: binary

%s
--dwh8d7agwd7gwag7--]]
--[[ FYI
 1: Camera number.
 2: Date.
 3: Camera number.
 4: Video data.
--]]

loadfile(os.getenv("HOME").."/.ytupload")()

fname = arg and arg[1]
if not lfs.attributes(fname) then
	print('Could not find the file "'..fname..'"!')
	error()
end

fhand = io.open(fname)
fcont = fhand:read("*all")

cam = fname:match("C(.)")
day = fname:match("C.%-(.+)%.avi"):gsub("-", "/")

ups = string.format(upc, cam, day, cam, fcont)
pushs = string.format(uph, GoogleLogin, GDataKey, fname, #ups)..ups

if arg[2] and arg[2] == "out" then
	io.stdout:write(pushs)
else
	pusher = socket.connect(socket.dns.toip("uploads.gdata.youtube.com"), 80)
	io.write("Transmitting...") io.flush()
	pusher:send(pushs)
	print("done!")
	print(pusher:receive("*a"))
end
