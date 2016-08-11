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
    
    @IBAction func didTapButton(_ sender: UIButton) {
        addAnnotation(for: mapView.centerCoordinate)
    }
    
    let geocoder = CLGeocoder()
    
    func addAnnotation(for coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Retrieving information..."
        
        mapView.addAnnotation(annotation)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                annotation.title = placemark.name
                annotation.subtitle = placemark.locality
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {

    /// show custom annotation view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let customAnnotationViewIdentifier = "MyAnnotation"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
            pin?.canShowCallout = false
        } else {
            pin?.annotation = annotation
        }
        return pin
    }
    
    /// If user selects annotation view for `CustomAnnotation`, then show callout for it.
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        guard let annotation = annotationView.annotation as? MKPointAnnotation else { return }
        
        if let calloutView = annotationView.calloutView {
            calloutView.removeFromSuperview()
        }
        
        let calloutView = ExampleCalloutView(annotation: annotation)
        calloutView.add(to: annotationView)
        annotationView.calloutView = calloutView
    }
    
    /// If user deselects annotation view, then remove any callout.
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        if let calloutView = annotationView.calloutView {
            calloutView.removeFromSuperview()
        }
    }
}

