//
//  CalloutAnnotation.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 6/15/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

import UIKit
import MapKit

/// Callout annotation
///
/// This is the annotation that is for the callout. When we instantiate, supply
/// annotation for which this is the callout. The actual `UIView` that represents
/// the callout is actually the `MKAnnotationView` for this annotation class.

class CalloutAnnotation : MKPointAnnotation {
    let underlyingAnnotation: CustomAnnotation      // this is the annotation for which this object is acting as callout
    
    init(annotation: CustomAnnotation) {
        self.underlyingAnnotation = annotation
        super.init()
    }
    
    /// Override `coordinate` so that it returns the same coordinate of the annotation for which this serves as callout
    
    override var coordinate: CLLocationCoordinate2D {
        get { return underlyingAnnotation.coordinate }
        set { underlyingAnnotation.coordinate = newValue }
    }
    
    /// Override `title` so that it simply the title of the annotation for which this serves as callout
    
    override var title: String! {
        get { return underlyingAnnotation.title }
        set { underlyingAnnotation.title = newValue }
    }
}

