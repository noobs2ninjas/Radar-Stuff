//
//  ViewController.swift
//  RadarStuff
//
//  Created by Nathan Kellert on 7/8/17.
//  Copyright © 2017 Nathan Kellert. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    var mapView: MKMapView!
    var parser: KMLParser!
    var overlays: [MKOverlay]!
    var annotations: [MKAnnotation]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let location = CLLocationCoordinate2D(latitude: 35.4676, longitude: -97.5164)
        let mapViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        mapView = MKMapView(frame: mapViewFrame)
        mapView.region = MKCoordinateRegionMake(location, MKCoordinateSpanMake(1.0, 1.0))
        mapView.centerCoordinate = location

        if let path = Bundle.main.path(forResource: "example3", ofType: "kml"){
            let url = URL(fileURLWithPath: path)
            parser = KMLParser(url: url)
            parser.parseKML()

            overlays = parser.overlays
            annotations = parser.points

        } else {
            print("not found")
        }
        mapView.delegate = self
        self.view.addSubview(mapView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return parser.viewForAnnotation(annotation)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return parser.rendererForOverlay(overlay)!
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapView.addOverlays(overlays)
        mapView.addAnnotations(annotations)
    }
}

