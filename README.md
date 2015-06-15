## Custom MapView Annotation Callouts in Swift 

This is an demonstration of a custom map view annotation callouts in Swift.

The map view doesn't offer a nice way to customize the callout for an annotation view. So, the pattern illustrated in this example is to show how one can (a) turn off the callout; (b) and when user selects annotation view, add our own callout. The trick is that this custom callout is created by creating a second type of annotation, a `CalloutAnnotation` which will have its own `CalloutAnnotationView`, and its this `CalloutAnnotationView` which will manifest the views associated with the original annotation's annotation view.

This is not intended as an end-user library, but just a quick and dirty example of how one might create custom callouts. This is for illustrative purposes only.

See http://stackoverflow.com/a/30824051/1271826.

Developed in Swift on Xcode 6.3.2 for iOS 8.3 using Swift 1.2. Also, the basic ideas are equally applicable for both Swift and Objective-C. 

## License

Copyright &copy; 2015 Robert Ryan. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

--

15 June 2015
