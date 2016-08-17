//
//  ViewController.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 6/15/15.
//  Copyright © 2015-2016 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func didTapButton(sender: UIButton) {
        addAnnotation(for: mapView.centerCoordinate)
    }
    
    let geocoder = CLGeocoder()
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = placemark.name
                annotation.subtitle = placemark.locality
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {

    /// show custom annotation view
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let customAnnotationViewIdentifier = "MyAnnotation"
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(customAnnotationViewIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
            pin?.canShowCallout = false
        } else {
            pin?.annotation = annotation
        }
        return pin
    }
    
}

