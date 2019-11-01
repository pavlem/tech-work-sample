# testDaresayInstructions:
There is no special stuff required, just start the project and build since there are no third party libs. Add your bundle ID to build on real iPhone device. 

I spent on the assignment about 11 hours (every working day about 2h), but I implemented much more than required by the task. Additional 1-2h I spent on XCode 11 problems, but that is not related to this assignment (arbitrary XCode crashing etc but it happens on other projects).

# User Interface:
Since this was an interesting task, I wanted to play little bit and I implemented maps as well besides location for weather info. Now you can get the weather based on the location and map tap.

First screen is a MAP which can be dragged/zoomed
- On map if you tap, the weather screen is opened with weather information
- Top bar has two buttons, one opens weather data for current location and the other opens based on the city name user types
- There is a blocking screen when network fetch is ongoing
- In case there is no city found a custom feedback component is shown 
- Portrait and landscape mode work fine
- Weather screen has various data, the upper part and bottom (table view list)
- On scrolling up the upper part is dragged as well (nice visual effect), something I was inspired by native iOS weather app
- There is metric and imperial option for the weather data
- There is English and Swedish localisation which is depended on phone settings choice. Swedish is google translate so excuse me for the mistakes :)

# Application architecture:
- File organisation:
- App - App related data
- Models - models
- ViewModels - view models 
- Components - varius components 
- Lib - various helpers and libs I wrote and the whole networking module under “Networking”
- Sections - all screens view controllers
- Resources - storyboards, strings, images

# Other Architecture:
- MMVM used as an app design pattern
- Base view controller has common stuff for all VCs 
- Networking module is independent and can be implemented anywhere. It is based on apple’s “URLSession”
- Delegates, protocols and callbacks used
- Extensions used for common behaviours
- Engine classes used for non UI related stuff
- There are Unit tests with json file that has a server response for testing the network layer