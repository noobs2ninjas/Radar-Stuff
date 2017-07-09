//
//  GoogleMapViewController.swift
//  RadarStuff
//
//  Created by Nathan Kellert on 7/9/17.
//  Copyright © 2017 Nathan Kellert. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class GoogleMapViewController: UIViewController {

    var mapView: GMSMapView!
    var parser: KMLParser!
    var overlays: [GMSOverlay]!
    var annotations: [MKAnnotation]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let location = CLLocationCoordinate2D(latitude: 35.4676, longitude: -97.5164)
        let mapViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: 8)

        mapView = GMSMapView(frame: mapViewFrame)
        mapView.camera = camera


        if let path = Bundle.main.path(forResource: "example3", ofType: "kml"){
            let url = URL(fileURLWithPath: path)
            parser = KMLParser(url: url)
            parser.parseKML()

            overlays = parser.googleOverlays
            annotations = parser.points

        } else {
            print("not found")
        }
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        
    }
    
    func addMarkers(){
        for annotation in annotations{
            if let title = annotation.title{
                let marker = GMSMarker(position: annotation.coordinate)
                marker.title = title
                marker.map = mapView
            }
        }
    }

    func addOverlays(){
        for overlay in overlays{
            overlay.map = mapView
        }
    }
}

extension GoogleMapViewController: GMSMapViewDelegate{
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        addOverlays()
        addMarkers()
    }
}
