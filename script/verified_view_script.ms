/*
 NOTE FOR THE USER:
 
- Both scripts and the csv need to be in the same folder.
- There must be only one csv in the script folder.
- the script will enable the "constant screen size"
- Always name the dummy point camera with "Camera" from csv
- You can set the specific settings in settings/settings.csv

========FILM PRESET VALUES====================
for film preset values these are the choices:

"35mm" 

"APS-C (Canon)" 

"APS-C (Nikon)"

"APS-H (Canon)" 

"Four Thirds" 

"Custom"

*/
maxscript_path = getFilenamePath (getSourceFileName())
get_all_csv = maxscript_path + "*.csv"
csv_files = getfiles(get_all_csv)

point_list = #()
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
				if findString newPoint.name "Camera" == undefined do(
					append point_list newPoint.name
				)
				
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

get_all_settings_csv = maxscript_path + "settings/*.csv"
settings_csv_files = getfiles(get_all_settings_csv)


get_all_images = maxscript_path + "images/*.*"
all_images = getFiles get_all_images
image = for f in all_images where (matchPattern f pattern:"*.png" ignoreCase:true or matchPattern f pattern:"*.jpg" ignoreCase:true) collect f

f = openFile settings_csv_files[1] mode:"rt"

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
			bmpImg.fileName = image[1]

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

			cam =  Physical name:lf[11]
			DisplaySafeFrames = true
			viewport.SetCamera cam
			cam.rotation = eulerAngles -90 22 0
			cam.pos = dummy_cam_point.pos

			--Film/Sensor
			
			cam.film_preset = lf[12]
			if cam.film_preset == "Custom" do(
				cam.film_width_mm = lf[13] as float
			)
			
			--Lens
			cam.focal_length_mm = lf[14] as float
			cam.zoom_factor = lf[15]  as float
			cam.f_number = lf[16]  as float

			--Perspective Control
			cam.horizontal_shift = lf[17] as float
			cam.vertical_shift = lf[18] as float
			cam.horizontal_tilt_correction =  lf[19] as float
			cam.vertical_tilt_correction =  lf[20] as float
			--camera direction
			point_list_count = point_list.count
			-- Create rotation list controller
			rList = Rotation_List ()
			cam.rotation.controller = rList
			lookAt_cons = LookAt_Constraint()
			rList.available.controller = lookAt_cons
			
			for point_name in point_list do(
				targetNode = getNodeByName point_name
				lookAt_cons.appendTarget targetNode 100.0
			)
			
			lookAt_cons.target_axis = 2
			lookAt_cons.target_axisFlip = true
			lookAt_cons.StoUP_axis = 1
			lookAt_cons.upnode_axis = 2
			
			cam_rot_val = cam.transform
			cam.rotation.controller = Euler_XYZ()
			cam.transform = cam_rot_val

			if cam.rotation.controller.x_rotation < 0 do(
				cam.rotation.controller.x_rotation = -90
			)
			if cam.rotation.controller.x_rotation > 0 do(
				cam.rotation.controller.x_rotation = 90
			)

			cam.rotation.controller.y_rotation = 0
			
			--Renderers
			renderer_classes = RendererClass.classes
			renderers.current = renderer_classes[1]()
			rendLockImageAspectRatio = true
			renderWidth = lf[21] as integer
			renderHeight = lf[22] as integer
			renderSceneDialog.update()
			
		)
	)
)
close f

