# CBTabBarController

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Cuberto/cb-tabbar/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/v/CBTabBarController.svg)](http://cocoapods.org/pods/CBTabBarController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Cuberto/cb-tabbar)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.2-green.svg?style=flat)](https://developer.apple.com/swift/)

![Animation](https://raw.githubusercontent.com/Cuberto/cb-tabbar/master/Screenshots/gooey.gif)

## Example

To run the example project, clone the repo, and run `ExampleApp`  scheme from CBTabBar.xcodeproj

## Requirements

- iOS 10.0+
- Xcode 9

## Installation

### CocoaPods
To install CBTabBarController add the following line to your Podfile:
```ruby
pod 'CBTabBarController'
```
Then run `pod install`.

### Carthage

Make the following entry in your Cartfile:

```
github "Cuberto/cb-tabbar"
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Manual

Add CBTabBarController folder to your project

## Usage

### With Storyboard

1. Create a new UITabBarController in your storyboard or nib.

2. Set the class of the UITabBarController to `CBTabBarController` in your Storyboard or nib.

3. Add a custom image icon and title for UITabBarItem of each child ViewContrroller


### Without Storyboard

1. Import CBTabBarController
2. Instantiate `CBTabBarController`
3. Add some child controllers and don't forget to set them tabBar items with title and image

## Styling

Set appropriate style for tab bar using `style` property of `CBTabbarController` instance.
You can subclass `UITabBarItem` and conform to `CBExtendedTabItem` protocol to define custom title style and tint for tab buttons. 

Styles supported at the moment:

#### Gooey with menu:

 ![Animation](https://raw.githubusercontent.com/Cuberto/cb-tabbar/master/Screenshots/gooey.gif)

 Requies configured `CBTabMenu` instance as paramenter (see example). Any object conforming to `CBTabMenuItem` can be used as menu item

#### Flashy: 

![Animation](https://raw.githubusercontent.com/Cuberto/cb-tabbar/master/Screenshots/flashy.gif)

#### Fade (default):

Same as gooey but without menu button

## Author

Cuberto Design, info@cuberto.com

## License

CB
TabBarController is available under the MIT license. See the LICENSE file for more info.
