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

--sun_pos = $SunPositioner001

sun_mode = sun_pos.mode -- Sun positioner mode

--Time
sun_pos.hours = 14
sun_pos.minutes = 6
--sun_pos.time_in_seconds

--Date
sun_pos.day = 20
sun_pos.month = 2
sun_pos.year = 2024

--Daylight Saving Time
sun_pos.dst = false
--sun_pos.dst_use_date_range
--sun_pos.dst_start_day
--sun_pos.dst_start_month
--sun_pos.dst_end_day
--sun_pos.dst_end_month

--Location
--sun_pos.location
sun_pos.time_zone = 0.0
sun_pos.latitude_deg = 51.5
sun_pos.longitude_deg = -0.117

--Compass Rose
--sun_pos.show_compass
--sun_pos.compass_radius
sun_pos.north_direction_deg = 347.078
--sun_pos.sun_distance

--Horizontal Coordinates
--sun_pos.azimuth_deg
--sun_pos.altitude_deg

--Viewport
bmpImg = bitmapTexture()
bmpImg.fileName = "C:\\Verified ViewsTutorial\\New Verified View Script\\V6\\View 06_20mm_Shift_ROT_CW_0_12.jpg"

-- Set it as the viewport background
setAsBackground bmpImg.bitmap

viewport.DispBkgImage = true
-- Now display it in the viewport

-- Force viewport to update
completeRedraw()

actionMan.executeAction 0 "620"
setBkgImageAspect #output

--Camera

find_dummy_cam_point = for o in objects where findString o.name "Camera" != undefined collect o
dummy_cam_point = find_dummy_cam_point[1]

cam =  Physical name:"V6_6016x4016"
DisplaySafeFrames = true
viewport.SetCamera cam
cam.rotation = eulerAngles -90 22 0
cam.pos = dummy_cam_point.pos

--Renderers
renderer_classes = RendererClass.classes
renderers.current = renderer_classes[1]()
rendLockImageAspectRatio = true
renderWidth = 6016
renderHeight = 4016
--rendImageAspectRatio 
renderSceneDialog.update()











