runGame = true

Friction = 0
Velocity = 0

currentPosY =0 
currentPosX = 0
currentMountainPosY =
currentTime = 1

rotationTarget = 30

gsw = 10;

hitCount = 0

lifes = 6

Avatar = "images/piq_244298_400x400.png"
background = "images/63b688f58fee9d0f27a300c492e8484c.jpg"
heart = "images/heart.png"

bg = new BackgroundLayer
	backgroundColor: "black"

mountains = new Layer
	width: 800
	height: 600
	image: background
	
mountains.center()

timer = new Layer
	backgroundColor: "blue"
	x: 30
	y: 30	
	html: "0"
currentTime = timer.html
# print currentPosY
Utils.interval 0.5, ->	
	if runGame
		shooter()

	for i in 100
		timer.html = currentTime + i	
	print timer.html


element = new Layer
	width: 60
	height: 70
	x: Align.center
	y: Align.bottom(-10)
	#image: "images/3peser75e64e.png"	
	parent: mountains
	#clip: false
	backgroundColor: "transparent"
	
allLifes = []

giveLifes = ->
	for i in [0...lifes]
		
		heart = new Layer
			width: 568
			height: 506
	
			image: "images/heart.png"

			scale: 0.07
			x: i * 50 - 220
			y: -200
			parent: mountains
			
		allLifes.push(heart)	
		
giveLifes()
	
#--------------------------------------------- Key Press
# 37 left, 38 up, 39 right, 40 down

ninjaRotation = 360

Events.wrap(window).addEventListener "keydown", (event) ->
	
	if runGame
	
		if event.keyCode is 37 #Left
			currentPosX = element.x
			
			element.animate
				x: currentPosX - 100
				rotation: -ninjaRotation
				options:
					curve: Bezier(0.010, 0.870, 0.495, 1.005)
					time: 0.5		
	
		if event.keyCode is 39 #Right
			currentPosX = element.x
			
			element.animate
				x: currentPosX + 100
				rotation: ninjaRotation
				options:
					curve: Bezier(0.010, 0.870, 0.495, 1.005)
					time: 0.5	
					
		if event.keyCode is 38 #Up
			
			currentPosY = element.y
			element.animate
				y: currentPosY-180
				rotation: rotationTarget
				options:
					curve: Bezier(0.010, 0.870, 0.495, 1.005)
					time: 0.5
					
			rotationTarget = rotationTarget * -1
			
			element.on Events.AnimationEnd, (animation, layer) ->			
				element.rotation = 0
				element.animate
					y: Align.bottom(-10)
					rotation: 0
					options:
						curve: Bezier(0.050, 0.055, 1.000, -0.035)
						time: 0.4
			
	
		if event.keyCode is 40 #Down
				element.rotation = 0
				element.animate
					y: Align.bottom(-10)
					rotation: 0
					options:
						curve: Bezier(0.050, 0.055, 1.000, -0.035)
						time: 0.1
		
	else
		if event.keyCode is 38 #Up
			lifes = 5
			giveLifes()
			shooter()
			runGame = true
			for gameOver in allGameOvers
				gameOver.destroy()


#---------------------------------------------

allBullets = []

shooter = ->
	
	bullet = new Layer
		size: 20
		backgroundColor: "rgba(235,118,119,1)"
		x: 0
		y: Utils.randomNumber(100,mountains.height - 100)
		parent: mountains
		borderWidth: 4
		borderColor: "rgba(0,0,0,1)"
	
	allBullets.push(bullet)
	
	bullet.animate
		x: Screen.width + 100	
		options:
			time: 2
			curve: Spring(tension: 10, mass: 0.1)
			
	
	bullet.onAnimationEnd ->
		this.destroy()

Utils.interval 0.5, ->	
	if runGame
		shooter()
	#collider()


	

Utils.interval 0.03, ->		
	
	if runGame
		collider()

	



collider = ->
	for l in allBullets
		if l.maxX >= element.x && l.x <= element.maxX && l.maxY >= element.y && l.y <= element.maxY
			hit()
			

	
hit = ->
	hitCount++
	lifes -= 1
	
	if lifes <= 0
		runGame = false
		showGameOver()
		
	
	if lifes >= 0
		if allLifes[lifes]?
			allLifes[lifes].destroy()
	
	bam = new Layer
		backgroundColor: "transparent"
		parent: element
		scale: 0
		x: Align.center
		y: Align.center
		
	for i in [0...lifes]
		
		bam2 = new Layer
			backgroundColor: "rgba(255,38,0,1)"
			originX: 0.5
			originY: 0.5
			size: 80
			scale: 1
			parent: bam
			opacity: 0.4
			rotation: 60 * i
			
		bam2.center()
	
	bam.sendToBack()
	
	
	bam.animate
		scale: 1
		options:
			time: 0.63
			curve: Spring(damping: 0.29)
			
	
	bam.onAnimationEnd ->
		bam.destroy()
		
		
hero = new Layer
	width: element.width
	height: element.height
	image: Avatar
	scale: 1.6
	parent: element
	clip: false
	

allGameOvers = []
	
showGameOver = ->
	
	gameOver = new Layer
		width: 300
		height: 76
		image: "images/Joshua-8-bit-avatar_whbg_400x400.png"
		parent: mountains
		scale: 0.3
		
	allGameOvers.push(gameOver)
	
	gameOver.center()
	
	gameOver.animate
		scale: 1
		options:
			time: 0.84
			curve: Spring(damping: 0.40)
			
	element.animate
		rotation: -360
		y: Screen.height









