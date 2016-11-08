## Custom MapView Annotation Callouts in Swift 

This is an demonstration of a custom map view annotation callouts in Swift.

The easiest way to customize callouts is to implement the `leftAccessoryView` and `rightAccessoryView`. If you want more considerable changes for what appears below the title in the callout (e.g. add some custom imagery or whatever), you can also implement the `detailAccessoryView`.

But sometimes, even that is insufficient. For example, if you want to change the background color of the callout, or change the shape of the callout bubble, or whatever, adjusting the various accessory views is insufficient. In those cases, you can disable the standard the MapKit callout, and generate your own. You simply have to identify when the callout is selected, and then add a subview to the annotation view.

When you go down this road, though, you're signing up for the manual rendering of the callout yourself. It gives you the ultimate level of control, but takes considerably more work.

In this project, I have an abstract `CalloutView` class that renders a custom callout bubble, and has a `contentView` associated with it. In my concrete subclass of this, `ExampleCalloutView`, I add two text labels. Clearly you can do something more substantial than that, but I wanted to do enough here so that you could see that you have fine-grained control over the appearance (in this case, changing the background color and the `UIBezierPath` shape around the callout).

I have also expanded this to detect taps on the callout, namely (a) adding a `hitTest` to the annotation view to included the callout, if present; and (b) added `hitTest` to callout base class to detect taps within the bubble. Then you can do things like adding a tap gesture recognizer to the callout. 

This is not intended as an end-user library, but just a "simple" example of how one might create custom callouts. This is for illustrative purposes only.

See http://stackoverflow.com/a/30824051/1271826.

Developed in Swift on Xcode 8.1 for iOS 10 using Swift 3. See the `swift2` branch for Swift 2 on iOS 9. But, the basic ideas are equally applicable for different versions of Swift and Objective-C. 

## License

Copyright &copy; 2015-2016 Robert Ryan. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

--

15 June 2015
