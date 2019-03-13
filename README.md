# TaggerKit

[![Version](https://img.shields.io/cocoapods/v/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)
[![License](https://img.shields.io/cocoapods/l/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)
[![Platform](https://img.shields.io/cocoapods/p/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)


TaggerKit helps you quickly integrate tags into your iOS projects. It provides a collection view for displaying tags and a text field for adding them to another collection view. The custom layout used by TaggerKit is based on [TagCellLayout](https://github.com/riteshhgupta/TagCellLayout) by Ritesh Gupta.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

TaggerKit runs on Swift 4.2 and iOS 12.


## Installation

TaggerKit is available through [CocoaPods](https://cocoapods.org). To install
it, just add the following line to your Podfile:

```ruby
pod 'TaggerKit'
```


## Setup

### Static tags

Tags can be implemented in a couple of ways.  Let's start simple: you have a bunch of tags (Strings) that you want to show to the user. A static collection view is just what we need.

1. In Interface Builder, create a container view in your ViewController and then delete its child from the storyboard:

![Interface Builder container view](https://i.imgur.com/NIOwIMR.png)

2. Import TaggerKit into your view controller and create an outlet for the container view

	```swift
	import TaggerKit

		class ViewController: UIViewController {

			@IBOutlet var containerView: UIView!

	```

3. Instantiate and a `TKCollectionView()` and give it to the container with:

	```swift
	var tagCollection: TKCollectionView()

	override func viewDidLoad() {
		super.viewDidLoad()

		add(tagCollection, toView: containerView)
	```

4. Give the collection view some tags:

	```swift
		tagCollection.tags = ["Some", "Tag", "For", "You"]
	```

5. Done!


### Dynamic tags

*Coming soon (really soon)!*


## Customisation

`TKCollectionView` has some properties you can set to modify the tag's appearance:

```swift
// Custom font
	tagCollection.customFont = UIFont.boldSystemFont(ofSize: 14)
// Corner radius of tags	
	tagCollection.customCornerRadius = 14.0		
// Spacing between cells					
	tagCollection.customSpacing = 20.0	
// Background of cells						
	tagCollection.customBackgroundColor = UIColor.red	
```
