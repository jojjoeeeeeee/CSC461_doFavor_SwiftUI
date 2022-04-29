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
        centerAnnotation.coordinate = map.centerCoordinate
        self.map.addAnnotation(centerAnnotation)
        
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
        //            if AppUtils.getUsrAddress()?.latitude == nil{
        //                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74719, longitude: 100.56559), latitudinalMeters: 200, longitudinalMeters: 200)
        //                uiView.setRegion(region,animated: true)
        //            }else{
        //                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (AppUtils.getUsrAddress()?.latitude)!, longitude: (AppUtils.getUsrAddress()?.longitude)!), latitudinalMeters: 200, longitudinalMeters: 200)
        //                uiView.setRegion(region,animated: true)
        //            }
        
    }
    
}

final class ContentViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    var myMapView = doFavorMapView().map
    
    let locationManager = CLLocationManager()
    
    static let shared = ContentViewModel()
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74719, longitude: 100.56559), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    @Published var isGetNewLocation:Bool = false
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let mapLatitude = mapView.centerCoordinate.latitude
        let mapLongitude = mapView.centerCoordinate.longitude
        var center = "Latitude: \(mapLatitude) Longitude: \(mapLongitude)"
        
        //        self.myMapView.setRegion(self.region, animated: true)
        myMapView.region.center.latitude = mapView.centerCoordinate.latitude
        //        myMapView.setRegion(mapView.region, animated: true)
        
        //        print("",myMapView.region.center.latitude)
        print(center)
        
    }
    
    
    func requestLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
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
        guard let latestLocation = locations.first else {
            return
        }
        
        
        if isGetNewLocation {
            //update location
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                print("pen pai dai",self.region)
            }
            
        } else {
            if AppUtils.getUsrAddress()?.latitude == nil{
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74719, longitude: 100.56559), latitudinalMeters: 200, longitudinalMeters: 200)
            }else{
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (AppUtils.getUsrAddress()?.latitude)!, longitude: (AppUtils.getUsrAddress()?.longitude)!), latitudinalMeters: 200, longitudinalMeters: 200)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription )")
    }
    
    
}


struct doFavorMapView_Previews: PreviewProvider {
    static var previews: some View {
        doFavorMapView()
    }
}
