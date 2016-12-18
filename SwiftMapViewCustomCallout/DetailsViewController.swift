//
//  DetailsViewController.swift
//  SwiftMapViewCustomCallout
//
//  Created by Robert Ryan on 12/18/16.
//  Copyright © 2016 Robert Ryan. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var annotation: MKPointAnnotation?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = annotation?.title
    }

}
