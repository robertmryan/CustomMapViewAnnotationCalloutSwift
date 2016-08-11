//
//  CustomAnnotationView.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 8/7/16.
//  Copyright © 2015-2016 Robert Ryan. All rights reserved.
//

import UIKit
import MapKit

/// This is simple subclass of `MKPinAnnotationView` which includes reference for any currently
/// visible callout bubble (if any).

class CustomAnnotationView: MKPinAnnotationView {
    
    weak var calloutView: CalloutView?
    
    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.annotation = nil
        }
        didSet {
            calloutView?.annotation = annotation as? MKPointAnnotation
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
        animatesDrop = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

