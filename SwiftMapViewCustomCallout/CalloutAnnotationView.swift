//
//  CalloutAnnotationView.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 6/15/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

import UIKit
import MapKit

/// Annotation view for the callout
///
/// This is the annotation view for the callout annotation.

class CalloutAnnotationView : MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        // if the annotation is a callout annotation (and that's the only thing that this should ever
        // be used for!), then add an observer for its title.
        
        if let calloutAnnotation = annotation as? CalloutAnnotation {
            calloutAnnotation.underlyingAnnotation.addObserver(self, forKeyPath: "title", options: [], context: nil)
        } else {
            assert(false, "this annotation view class should only be used with CalloutAnnotation objects")
        }
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // if we (re)set the annotation, remove old observer for title, if any and add new one
    
    override var annotation: MKAnnotation? {
        willSet {
            if let calloutAnnotation = annotation as? CalloutAnnotation {
                calloutAnnotation.underlyingAnnotation.removeObserver(self, forKeyPath: "title")
            }
        }
        didSet {
            updateCallout()
            if let calloutAnnotation = annotation as? CalloutAnnotation {
                calloutAnnotation.underlyingAnnotation.addObserver(self, forKeyPath: "title", options: [], context: nil)
            }
        }
    }

    // if this gets deallocated, remove any observer of the title
    
    deinit {
        if let calloutAnnotation = annotation as? CalloutAnnotation {
            calloutAnnotation.underlyingAnnotation.removeObserver(self, forKeyPath: "title")
        }
    }
    
    // if the title changes, update the callout accordingly
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        updateCallout()
    }
    
    let bubbleView = BubbleView()           // the view that actually represents the callout bubble
    let label = UILabel()                   // the label we'll add as subview to the bubble's contentView
    let font = UIFont.systemFontOfSize(10)  // the font we'll use
    
    /// Update size and layout of callout view
    
    func updateCallout() {
        if annotation == nil {
            return
        }
        
        var size = CGSizeZero
        if let string = annotation?.title where string != nil {
            let attributes = [NSFontAttributeName : font]
            print(string)
            size = string!.sizeWithAttributes(attributes)
            label.text = (annotation?.title)!
        }
        if size.width < 30 {
            size.width = 30
        }
        bubbleView.setContentViewSize(size)
        frame = bubbleView.bounds
        centerOffset = CGPoint(x: 0, y: -50)
    }
    
    /// Perform the initial configuration of the subviews
    
    func configure() {
        backgroundColor = UIColor.clearColor()
        
        addSubview(bubbleView)
        
        label.frame = CGRectInset(bubbleView.contentView.bounds, -1, -1)
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.textAlignment = .Center
        label.font = font
        label.textColor = UIColor.whiteColor()
        
        bubbleView.contentView.addSubview(label)
        
        updateCallout()
    }
}

