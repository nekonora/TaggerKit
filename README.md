# TaggerKit

[![Version](https://img.shields.io/cocoapods/v/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)
[![License](https://img.shields.io/cocoapods/l/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)
[![Platform](https://img.shields.io/cocoapods/p/TaggerKit.svg?style=flat)](https://cocoapods.org/pods/TaggerKit)

![](https://media.giphy.com/media/ReBiPS298yk3MlXqTg/giphy.gif)

TaggerKit helps you quickly integrate tags into your iOS projects. It provides a collection view for displaying tags and a text field for adding them to another collection view. The custom layout used by TaggerKit is based on [TagCellLayout](https://github.com/riteshhgupta/TagCellLayout) by Ritesh Gupta.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

TaggerKit is writtern is compatible with Swift 4.2/5 and runs on iOS 11+.


## Installation

TaggerKit is available through [CocoaPods](https://cocoapods.org). To install the latest version (updated for Swift 5)
, just add the following line to your Podfile:

```ruby
pod 'TaggerKit'
```

If you are experiencing any problem with that version in your project, either set in Xcode: `File > Workspace Settings > Build System` to `Legacy`, or install this version:

```ruby
pod 'TaggerKit', '~> 0.4.1'
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

Do this if you want what you saw in the preview GIF.

1. Follow the instructions above and create two collection views, putting them into two different containers

2. For both collection views set their `.action` property accordingly. For example: if you are in a view displaying a product to which your user has already added some tags, these tags should be removable, hence that collection's action should be `.removeAction` (more on how to be notified of tags events later).

	```swift
	productTagsCollection.action 	= .removeTag
	```

3. Create a Text Field outlet and set its custom class to `TKTextField`

4. Set the text field's `.sender ` and  `.receiver` properties. This enables the text field to add tags to a collection. The sender is a collection view that is displaying tags from the textfield (tags that should be filtered), while the receiver is the collection receiving the tags:

	```swift
	textField.sender = allTagsCollection
	textField.receiver = productTagsCollection
	```

5. If you want the "filter" collection to be able to add tags, set these properties:

	```swift
	allTagsCollection.action = .addTag
	allTagsCollection.receiver = productTagsCollection
	```
	
6. Lastly, you probably want to be notified and act upon tags being added or removed from a collection. For this purpose, TaggerKit lets you override these two methods in order to add your functionality (your controller must the delegate of the collections):

	```swift
	allTagsCollection.delegate 	= self
	productTagsCollection.delegate 	= self
	
	
	override func tagIsBeingAdded(name: String?) {
		// Example: save testCollection.tags to UserDefault
		print("added \(name!)")
	}
	
	override func tagIsBeingRemoved(name: String?) {
		print("removed \(name!)")
	}
	```


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
