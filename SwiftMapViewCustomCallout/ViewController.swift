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
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        if #available(iOS 11.0, *) {
            if annotation is MKClusterAnnotation { return nil }
        }

        let customAnnotationViewIdentifier = "MyAnnotation"

        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewIdentifier)
        if pin == nil {
            pin = CustomAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier)
        } else {
            pin?.annotation = annotation
        }
        return pin
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("mapView(_:annotationView:calloutAccessoryControlTapped)")
    }
}

// If you want view controller to be able to do something when you tap button in callout, conform to this protocol
// and implement this method.

extension ViewController: ExampleCalloutViewDelegate {
    func mapView(_ mapView: MKMapView, didTapDetailsButton button: UIButton, for annotation: MKAnnotation) {
        print("mapView(_:didTapDetailsButton:for:)")
    }
}
