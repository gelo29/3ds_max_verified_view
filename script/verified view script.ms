/*

- Both scripts and the csv need to be in the same folder.
- There must be only one csv in the script folder.
- the script will enable the "constant screen size"

*/
maxscript_path = getFilenamePath (getSourceFileName())
get_all_csv = maxscript_path + "*.csv"
csv_files = getfiles(get_all_csv)

for csv_file in csv_files do(
	f = openFile csv_file mode:"rt"

	prefabPoint = point name:"dummy"
	prefabPoint.constantScreenSize = true --enable constant screen size
		
	-- if it opened successfully (exists, etc)...
	if f != undefined do
	(
		readLine f
		while not eof f do
		(
			-- Read a line from the file
			l = readline f
			
			-- turn that line into an array of strings using commas as delimiters
			lf = filterString l ","
			
			if (lf[1] != undefined ) do
			(
				newPoint = instance prefabPoint
				newPoint.name = lf[1]
				
				x = lf[2] as float
				y = lf[3] as float
				z = lf[4] as float
				newPoint.pos = [x,y,z]
			)
		)
		
		delete prefabPoint
	)
	close f
)

/* Sun Positioner */

sun_pos = Sun_Positioner()
sun_pos.mode = 1

--Time
sun_pos.hours = 14
sun_pos.minutes = 6

--Date
sun_pos.day = 20
sun_pos.month = 2
sun_pos.year = 2024

--Daylight Saving Time
sun_pos.dst = false

--Location
sun_pos.time_zone = 0
sun_pos.latitude_deg = 51.5
sun_pos.longitude_deg = -0.17

sun_pos.north_direction_deg = 347.078

--Viewport
bmpImg = bitmapTexture()
bmpImg.fileName = "D:\\Angelo\\Freelance\\jamiecardoso\\assets\\View 06_20mm_Shift_ROT_CW_0_12.jpg"

-- Set it as the viewport background
setAsBackground bmpImg.bitmap

viewport.DispBkgImage = true
-- Now display it in the viewport


-- Force viewport to update
completeRedraw()

actionMan.executeAction 0 "620"
setBkgImageAspect #output

cam =  Physical name:"V6_6016x4016"












