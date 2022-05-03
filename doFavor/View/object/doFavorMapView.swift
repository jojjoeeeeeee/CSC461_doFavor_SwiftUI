//
//  doFavorMapView.swift
//  doFavor
//
//  Created by Khing Thananut on 29/4/2565 BE.
//

import SwiftUI
import MapKit
import CoreLocation

struct doFavorMapView: UIViewRepresentable {
    
    let map = MKMapView()
    var centerAnnotation = MKPointAnnotation()
    
    @StateObject public var viewModel = ContentViewModel.shared
    
    func makeUIView(context: Context) -> MKMapView {
        map.showsUserLocation = true
        map.delegate = context.coordinator
        //        map.setUserTrackingMode(.followWithHeading, animated: true)
        
        
        viewModel.requestLocationPermission()
        //        viewModel.getCurrentLocation()
        
        
        return map
    }
    
    func makeCoordinator() -> ContentViewModel {
        ContentViewModel()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let region = self.viewModel.region
        uiView.setRegion(region,animated: true)
        
    }
    
}

final class ContentViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    var myMapView = doFavorMapView().map
    
    let locationManager = CLLocationManager()
    
    static let shared = ContentViewModel()
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74719, longitude: 100.56559), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    @Published var addressLat = 13.74719
    @Published var addressLon = 100.56559
    
//    @Published var scrollRegion = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var isGetNewLocation:Bool = false

    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapLatitude = mapView.centerCoordinate.latitude
        let mapLongitude = mapView.centerCoordinate.longitude
        let center = "Latitude: \(mapLatitude) Longitude: \(mapLongitude)"
        DispatchQueue.main.async {
            UserDefaults.standard.set(Double(mapLatitude), forKey: "scrollRegionLatitude")
            UserDefaults.standard.set(Double(mapLongitude), forKey: "scrollRegionLongitude")
        }
    }
    
    
    func requestLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func setLocation() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: addressLat, longitude: addressLon), latitudinalMeters: 200, longitudinalMeters: 200)
    }
    
    //load location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            print("Please allow")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if isGetNewLocation {
            guard let latestLocation = locations.first else {
                return
            } 
            //update location
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription )")
    }
    
    
}

struct PlaceAnnotationView: View {
  var body: some View {
    VStack(spacing: 0) {
      Image(systemName: "mappin.circle.fill")
        .font(.title)
        .foregroundColor(.red)
      
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
        .foregroundColor(.red)
        .offset(x: 0, y: -5)
    }
  }
}
