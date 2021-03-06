Local Weather
===========

![App Image](./Images/02d.png)

Sample Objective-C app that displays location based weather. Leverages [LocalWeatherKit](https://github.com/AnthonyArzola/LocalWeatherKit "LocalWeatherKit on GitHub") CocoaPod. Additionally, makes use of [Local Weather images](https://github.com/AnthonyArzola/LocalWeatherImages "Local Weather Images on GitHub").

## Getting Started

1. Get API key from [OpenWeatherMap](https://openweathermap.org/appid)

2. Clone this repo

3. Open workspace, replace `KEY_ID` constant value in `LWConstants.h` with your API key from Step 1

4. Clone [LocalWeatherKit](https://github.com/AnthonyArzola/LocalWeatherKit "LocalWeatherKit on GitHub"). LocalWeather app references LocalWeatherKit CocoaPod, a local and unpublished pod

5. That's it! Run app and enjoy the local weather. Well, the weather app at least :-)

## Leverages

* Core Location - `CLLocationManager`
* MapKit - `MKAnnotation`
* UIKit
  * 3D Touch
    * `UIApplicationShortcutItem`
  * Peek and Pop
    * `UIViewControllerPreviewingDelegate`
    * `UIPreviewActionItem`

## App Screenshots
![3D Touch](./Screenshots/3D-Touch.png) ![Loading](./Screenshots/Loading.png)


![Refresh](./Screenshots/Refresh.png) ![List](./Screenshots/List.png)


![Map](./Screenshots/Map.png) ![City Weather Details](./Screenshots/Details.png)
