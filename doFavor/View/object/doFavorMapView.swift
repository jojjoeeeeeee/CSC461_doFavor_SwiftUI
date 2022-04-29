//
//  doFavorMapView.swift
//  doFavor
//
//  Created by Khing Thananut on 29/4/2565 BE.
//

import SwiftUI
import MapKit

struct doFavorMapView: UIViewRepresentable {
    let manager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.setUserTrackingMode(.followWithHeading, animated: true)
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
    
    class Coordinator: NSObject, MKMapViewDelegate{
        var myMapView: doFavorMapView
        
        init(_ map:doFavorMapView){
            self.myMapView = map
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            UIView.animate(withDuration: 0.1){
                mapView.setRegion(region, animated: true)
            }
            
            print("Location update")
            
        }
    }
    
}

struct doFavorMapView_Previews: PreviewProvider {
    static var previews: some View {
        doFavorMapView()
    }
}
