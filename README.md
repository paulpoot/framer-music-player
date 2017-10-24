# framer-music-player
This is an interactive high fidelity prototype for the "Now Playing" section of a music player app built with framer.js for the workshop "High Fidelity Prototyping with Framer".

View a video of the prototype on [youtube](https://www.youtube.com/watch?v=I2G7T-rfgnU)

## Features
- Carousel component for displaying album art
- Material Design icons (pardon me for using them in this context)
- Favourite button micro-interaction
- Animated progress bar
- Working music player controls to control the carousel and progress bar

## Requirements

To view this prototype, you will first need to install NodeJS. You can do it from [the official website](https://nodejs.org/en/download/). 

## Get started

- Run `npm install` from the project folder. This will install all the required dependencies
- Run `gulp`. If you have not installed it: `npm install -g gulp`
- Open `http://localhost:3000` on your preferred web browser. Firefox performed the best in my experience, but Webkit browsers should work just fine.

## Exporting to Framer Studio

If you want to use this prototype with Framer Studio, you can follow the following steps

- Run `gulp export`
- Open the `framer-boilerplate.framer` in the `exports` folder with Framer Studio
- Update the project if asked