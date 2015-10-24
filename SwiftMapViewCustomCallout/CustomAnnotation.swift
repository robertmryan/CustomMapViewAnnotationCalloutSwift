//
//  CustomAnnotation.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 6/15/15.
//  Copyright (c) 2015 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

import UIKit
import MapKit
import CoreLocation

/// Custom Annotation
///
/// This is a simple `MKPointAnnotation` subclass, which updates its `title` using reverse geocoding.

class CustomAnnotation : MKPointAnnotation {
    static let geocoder: CLGeocoder = CLGeocoder()
    
    // if we set the coordinate, geocode it
    
    override var coordinate: CLLocationCoordinate2D {
        didSet {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CustomAnnotation.geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    self.title = placemark.name
                }
            }
        }
    }
}


