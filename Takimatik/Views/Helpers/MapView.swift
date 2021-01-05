//
//  MapView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 26.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView : UIViewRepresentable {
    
    @Binding var selectedLocation : SelectedLocation?
    
    var mapView : MKMapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
        mapView.addGestureRecognizer(gesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapView : MKMapView { parent.mapView }
        
        private var cameraZoomRangeInMeters : Double = 100000
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            mapView.showsUserLocation = true
            mapView.userLocation.title = "Konumum"
            mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: cameraZoomRangeInMeters), animated: true)
        }
        
        
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            
            if let addedAnnotation = views.first?.annotation {
                                
                mapView.annotations.forEach {
                    if ($0 is MKPointAnnotation) && $0.coordinate.latitude != addedAnnotation.coordinate.latitude && $0.coordinate.longitude != addedAnnotation.coordinate.longitude{
                        mapView.removeAnnotation($0)
                    }
                }
                
            }
        }
        
        
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            if mapView.camera.altitude > cameraZoomRangeInMeters, let currentLocationCoordinate = DataManager.shared.locationManager.location?.coordinate  {
                var span = mapView.region.span

                if span.latitudeDelta > 0.2 {
                    span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                }

                let region = MKCoordinateRegion(center: currentLocationCoordinate, span: span)
                mapView.setRegion(region, animated:true)
            }
        }
        
        @objc func tapped(_ gesture: UITapGestureRecognizer) {

            if gesture.state == .ended {
                let point = gesture.location(in: gesture.view)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                
                lookUpSelectedLocation(location: coordinate) { (landmark) in
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = landmark?.name
                    annotation.subtitle = "\(landmark?.subLocality ?? "") / \(landmark?.locality ?? "") "
                    annotation.coordinate = coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    DispatchQueue.main.async {
                      self.parent.selectedLocation = SelectedLocation(coordinate: coordinate, address: "\(annotation.title ?? ""), \(annotation.subtitle ?? "")")
                    }

                }
            }

        }
        
        private func lookUpSelectedLocation(location: CLLocationCoordinate2D?, completionHandler: @escaping (CLPlacemark?)
                        -> Void ) {
            // Use the last reported location.
            if let selectedLocation = location {
                let geocoder = CLGeocoder()
                    
                // Look up the location and pass it to the completion handler
                geocoder.reverseGeocodeLocation(CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude),
                            completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                    } else {
                     // An error occurred during geocoding.
                        completionHandler(nil)
                    }
                })
            }
            else {
                // No location was available.
                completionHandler(nil)
            }
        }
    }
}
