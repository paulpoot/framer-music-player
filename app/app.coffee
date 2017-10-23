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
    opacity: .5
    index: -1

#####################################################
#   Carousel
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
        time: 5
        curve: Bezier.linear

progressBarReset = new Animation progressBar,
    width: 0
    options:
        time: .2
        curve: Bezier.easeInOut

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

nowPlaying = false

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

resetProgress = ->
    progressBar.width = 0

    if nowPlaying
        progressBarPlay.start()

updateBlurArt = ->
    blurredArt.image = "images/" + carouselImgPrefix + (carousel.row.currentPage.index - 1) + carouselImgSuffix

nextSong = -> 
    carousel.row.snapToNextPage()
    resetProgress()
    updateBlurArt()

previousSong = ->
    reachedEnd = false
    print "end? " + reachedEnd
    carousel.row.snapToPreviousPage()
    resetProgress()
    updateBlurArt()

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
    reachedEnd = false
    resetProgress()
    updateBlurArt()

reachedEnd = false

progressBarPlay.on Events.AnimationEnd, ->
    print carousel.row.currentPage.index
    print "----------"
    progressBarReset.start()

progressBarReset.on Events.AnimationEnd, ->
    if (nowPlaying && carousel.row.currentPage.index != carouselItemCount)
        nextSong()
    else
        if nowPlaying
            cyclePlay()