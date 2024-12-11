//
//  PRMapView.swift
//  PrivateRide
//
//  Created by Savyo Brenner on 11/12/24.
//

import MapKit
import SwiftUI

struct PRMapView: UIViewRepresentable {
    @Binding
    var region: MKCoordinateRegion
    
    let pins: [CLLocationCoordinate2D]
    let polyline: MKPolyline?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.updateRegion(mapView: mapView, region: region)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        pins.forEach { coordinate in
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
        
        if let polyline {
            mapView.addOverlay(polyline)
        }
        
        if !pins.isEmpty || polyline != nil {
            var mapRect = pins.reduce(MKMapRect.null) { rect, coordinate in
                let point = MKMapPoint(coordinate)
                let pinRect = MKMapRect(x: point.x, y: point.y, width: 0.1, height: 0.1)
                return rect.union(pinRect)
            }
            
            if let polyline {
                mapRect = mapRect.union(polyline.boundingMapRect)
            }
            
            mapView.setVisibleMapRect(
                mapRect,
                edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                animated: true
            )
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        private var lastRegion: MKCoordinateRegion?
        
        func updateRegion(mapView: MKMapView, region: MKCoordinateRegion) {
            guard region != lastRegion else { return }
            lastRegion = region
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .primaryBrand
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
