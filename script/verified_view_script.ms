/*
 NOTE FOR THE USER:
 
- Both scripts and the csv need to be in the same folder.
- There must be only one csv in the script folder.
- the script will enable the "constant screen size"
- Always name the dummy point camera with "Camera" from csv
- You can set the specific settings in settings/settings.csv

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

sun_pos = Sun_Positioner()
sun_mode = sun_pos.mode

find_dummy_cam_point = for o in objects where findString o.name "Camera" != undefined collect o
dummy_cam_point = find_dummy_cam_point[1]

settings_csv = maxscript_path + "settings/settings.csv"

f = openFile settings_csv mode:"rt"

if f != undefined do
(
	readLine f
	while not eof f do
	(
		l = readline f
		lf = filterString l ","
		if (lf[1] != undefined ) do
		(
			--Time
			sun_pos.hours = lf[1] as integer
			sun_pos.minutes = lf[2] as integer
			
			--Date
			sun_pos.day = lf[3] as integer
			sun_pos.month = lf[4] as integer
			sun_pos.year = lf[5] as integer
			
			--Daylight Saving Time
			sun_pos.dst = lf[6] as booleanclass
			
			--Location
			sun_pos.time_zone = lf[7] as float
			sun_pos.latitude_deg = lf[8] as float
			sun_pos.longitude_deg =lf[9] as float
			
			--Compass Rose
			sun_pos.north_direction_deg = lf[10] as float
			
			--Viewport
			bmpImg = bitmapTexture()
			bmpImg.fileName = lf[11]

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

			cam =  Physical name:lf[12]
			DisplaySafeFrames = true
			viewport.SetCamera cam
			cam.rotation = eulerAngles -90 22 0
			cam.pos = dummy_cam_point.pos

			--Film/Sensor
			cam.film_preset = lf[13]

			--Lens
			cam.focal_length_mm = lf[14] as float
			cam.zoom_factor = lf[15]  as float
			cam.f_number = lf[16]  as float

			--Perspective Control
			cam.horizontal_shift = lf[17] as float
			cam.vertical_shift = lf[18] as float
			
			--Renderers
			renderer_classes = RendererClass.classes
			renderers.current = renderer_classes[1]()
			rendLockImageAspectRatio = true
			renderWidth = lf[19] as integer
			renderHeight = lf[20] as integer
			renderSceneDialog.update()
			
		)
	)
)
close f

