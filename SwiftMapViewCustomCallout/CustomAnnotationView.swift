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
    
    weak var calloutView: ExampleCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    let animationDuration: NSTimeInterval = 0.25
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            let calloutView = ExampleCalloutView(annotation: annotation as! MKShape)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animateWithDuration(animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            if animated {
                UIView.animateWithDuration(animationDuration, animations: { 
                    self.calloutView?.alpha = 0
                }, completion: { finished in
                    self.calloutView?.removeFromSuperview()
                })
            } else {
                calloutView?.removeFromSuperview()
            }
        }
    }
    
}

