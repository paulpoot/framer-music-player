CarouselComponent = require "@blackpixel/framer-carouselcomponent"
{ Icon } = require "Icon"

Utils.insertCSS('@import url(https://fonts.googleapis.com/css?family=Source+Sans+Pro);')

if not Framer.Device
    # From framer.generated.js
    Framer.Defaults.DeviceView = {"deviceScale":-1,"deviceType":"iphone-6-silver","contentScale":1,"orientation":0};
    Framer.Defaults.DeviceComponent = {"deviceScale":-1,"deviceType":"iphone-6-silver","contentScale":1,"orientation":0};
    Framer.Device = new Framer.DeviceComponent();
    Framer.Device.setupContext();
    # End from framer.generated.js 

screenWidth = Framer.Device.screen.width
screenHeight = Framer.Device.screen.height

primaryGradient = "-webkit-linear-gradient(right, #00adb5 0%, #2cc390 100%)"
nowPlaying = false

bg = new BackgroundLayer
    image: "images/bg.png"

#####################################################
#   Appbar
#####################################################
appBar = new Layer
    width: screenWidth
    height: 125
    backgroundColor: "transparent"

menuIcon = new Icon
    icon: "menu"
    width: 60
    height: 60
    x: 30
    y: Align.center
    color: "#fff"
    superLayer: appBar

appTitle = new TextLayer
    width: screenWidth
    text: "Now Playing"
    textAlign: "center"
    fontFamily: "'Source Sans Pro', sans-serif"
    color: "#fff"
    x: Align.center
    y: Align.center(-10)
    superLayer: appBar

heartOutlineButton = new Icon
    icon: "heart-outline"
    index: 1
    width: 50
    height: 50
    x: screenWidth - 80
    y: Align.center
    color: "#fff"
    superLayer: appBar

heartButton = new Icon
    icon: "heart"
    index: -1
    opacity: 0
    width: 50
    height: 50
    x: screenWidth - 80
    y: Align.center(-20)
    color: "#00adb5"
    superLayer: appBar

heartOutlineOut = new Animation heartOutlineButton,
    index: -1
    opacity: 0
    y: Align.center(-20)
    options:
        time: .5
        curve: Spring

heartOutlineIn = heartOutlineOut.reverse()
    
heartIn = new Animation heartButton,
    index: 1
    opacity: 1
    y: Align.center
    options:
        time: .5
        curve: Spring

heartOut = heartIn.reverse()

favourite = ->
    heartOutlineIn.stop()
    heartOut.stop()
    heartOutlineOut.start()
    heartIn.start()

unfavourite = ->
    heartOutlineOut.stop()
    heartIn.stop()
    heartOutlineIn.start()
    heartOut.start()

heartOutlineButton.onClick ->
    favourite()

heartButton.onClick ->
    unfavourite()

#####################################################
#   Carousel
#####################################################
carouselItemCount = 3
carouselMargin = screenWidth / 7.5
carouselItemSize = (screenWidth / 7.5) * 5
carouselItemMarginR = screenWidth / 7.5 / 4
carouselItemMarginL = screenWidth / 7.5 + carouselItemMarginR
carouselImgPrefix = "album/"
carouselImgSuffix = ".png"

carousel = new CarouselComponent
    itemCount: carouselItemCount
    itemWidth: carouselItemSize
    itemHeight: carouselItemSize
    itemMargin: carouselMargin
    itemBorderRadius: 25
    fontFamily: "'Source Sans Pro', sans-serif"
    title: ""
    captions: ["Destrier", "Ghost", "Malina"]
    subcaptions: ["Agent Fresco", "The Devin Townsend Project", "Leprous"]
    captionFontSize: 60
    subcaptionFontSize: 40
    captionColor: "#fff"
    subcaptionColor: "#00adb5"
    captionAlign: "center"
    captionMargin: 100
    subcaptionMargin: 40
    margins: [appBar.height + 75, carouselItemMarginR, 60, carouselItemMarginL]
    imagePrefix: carouselImgPrefix
	imageSuffix: carouselImgSuffix

blurredArt = new Layer
    width: screenWidth
    height: screenHeight
    blur: 50
    opacity: .2
    index: -1

updateBlurArt = ->
    blurredArt.image = "images/" + carouselImgPrefix + (carousel.row.currentPage.index - 1) + carouselImgSuffix

#####################################################
#   Progress Bar
#####################################################
progressBar = new Layer
    width: 0
    height: 8
    y: Align.bottom(-165)
    shadowY: -1
    shadowBlur: 15
    shadowColor: "#00adb5"

progressBar.style.background = primaryGradient

progressBarPlay = new Animation progressBar,
    width: screenWidth
    options:
        time: 30
        curve: Bezier.linear

progressBarReset = new Animation progressBar,
    width: 0
    options:
        time: .2
        curve: Bezier.easeInOut

resetProgress = ->
    progressBar.width = 0

    if nowPlaying
        progressBarPlay.start()

#####################################################
#   Controls
#####################################################
controls = new Layer
    width: screenWidth
    height: 165
    y: Align.bottom
    backgroundColor: "transparent"

playButton = new Icon
    icon: 'play'
    opacity: 1
    width: 60
    height: 60
    color: "#00adb5"
    superLayer: controls
    x: Align.center
    y: Align.center

forwardButton = new Icon
    icon: 'skip-next'
    width: 60
    height: 60
    color: "#fff"
    superLayer: controls
    x: Align.center(120)
    y: Align.center

previousButton = new Icon
    icon: 'skip-previous'
    width: 60
    height: 60
    color: "#fff"
    superLayer: controls
    x: Align.center(-120)
    y: Align.center

playButton.states = 
    inactive:
        opacity: 0

playButton.states.animationOptions =
    curve: Spring

pauseButton = new Icon
    icon: 'pause'
    opacity: 0
    width: 60
    height: 60
    color: "#00adb5"
    superLayer: controls
    x: Align.center
    y: Align.center

pauseButton.states = 
    active:
        opacity: 1

pauseButton.states.animationOptions =
    curve: Spring

cyclePlay = ->
    if nowPlaying is true
        progressBarPlay.stop()
        playButton.animate('default')
        pauseButton.animate('default')
        nowPlaying = false
    else
        progressBarPlay.start()
        playButton.animate('inactive')
        pauseButton.animate('active')
        nowPlaying = true

nextSong = -> 
    carousel.row.snapToNextPage()
    resetProgress()
    updateBlurArt()
    unfavourite()

previousSong = ->
    carousel.row.snapToPreviousPage()
    resetProgress()
    updateBlurArt()
    unfavourite()

updateBlurArt()

playButton.onClick ->
    cyclePlay()

pauseButton.onClick ->
    cyclePlay()

forwardButton.onClick ->
    nextSong()

previousButton.onClick ->
    previousSong()

carousel.row.content.on "change:x", ->
    resetProgress()
    updateBlurArt()
    unfavourite()

progressBarPlay.on Events.AnimationEnd, ->
    progressBarReset.start()

progressBarReset.on Events.AnimationEnd, ->
    if (nowPlaying && carousel.row.currentPage.index != carouselItemCount)
        nextSong()
    else
        if nowPlaying
            cyclePlay()