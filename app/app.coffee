CarouselComponent = require "@blackpixel/framer-carouselcomponent"

if not Framer.Device
    # From framer.generated.js
    Framer.Defaults.DeviceView = {"deviceScale":-1,"deviceType":"iphone-6-silver","contentScale":1,"orientation":0};
    Framer.Defaults.DeviceComponent = {"deviceScale":-1,"deviceType":"iphone-6-silver","contentScale":1,"orientation":0};
    Framer.Device = new Framer.DeviceComponent();
    Framer.Device.setupContext();
    # End from framer.generated.js 

bg = new BackgroundLayer
    image: "images/bg.png"

carousel = new CarouselComponent
    itemCount: 3
    itemWidth: 500
    itemHeight: 500
    itemMargin: 100
    margins: [0, 25, 0, 125]
    imagePrefix: "album/"
	imageSuffix: ".png"