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

    @StateObject public var viewModel = ContentViewModel()
    
    func makeUIView(context: Context) -> MKMapView {
        map.addSubview(homebtn)
        map.showsUserLocation = true
        map.delegate = context.coordinator
//        map.setUserTrackingMode(.followWithHeading, animated: true)
        centerAnnotation.coordinate = map.centerCoordinate
        self.map.addAnnotation(centerAnnotation)
        
        viewModel.requestLocationPermission()
        viewModel.getCurrentLocation()
        
        return map
    }
    
    private let homebtn: UIButton = {
        let button = UIButton()
        button.setTitle("หน้าหลัก", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor(red: 114/255, green: 75/255, blue: 255/255, alpha: 1), for: .normal)
        button.setImage(UIImage(named: "home-btn.png"), for: .normal)
        return button
    }()
    
    func makeCoordinator() -> ContentViewModel {
        ContentViewModel()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
    
}

final class ContentViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    var myMapView = doFavorMapView().map
    
    let locationManager = CLLocationManager()
    private var mapChangedFromUserInteraction = false
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74486, longitude: 100.56472), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

    override init(){
        super.init()
        locationManager.delegate = self
//        myMapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        
        if mapChangedFromUserInteraction{
            print("user WILL change map.")
        }

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
        
        if mapChangedFromUserInteraction{
            print("user CHANGED map.")
            print(mapLatitude)
            print(mapLongitude)
        }
    }
    
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//
//            UIView.animate(withDuration: 0.1){
//                mapView.setRegion(self.region, animated: true)
//            }
//
//            print("Location update",region.center.latitude,region.center.longitude)
//
//        }
    
    func requestLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
        print("get current")
    }

    //mapView didchange
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        let view = myMapView.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers{
            for recognizer in gestureRecognizers{
                if (recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended){
                    print("HI TRUE")
                    return true
                }
            }
        }
        print("HI FALSE")
        return false
    }
    
    //load location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }

        //update location
        DispatchQueue.main.async {
//            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//            self.myMapView.setRegion(self.region, animated: true)
//            print("region2",self.region.center)
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


struct PillButton: UIViewRepresentable {
    let title: String
    let action: () -> ()

    var ntPillButton = UIButton()//NTPillButton(type: .filled, title: "Start Test")

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        var parent: PillButton

        init(_ pillButton: PillButton) {
            self.parent = pillButton
            super.init()
        }

        @objc func doAction(_ sender: Any) {
            self.parent.action()
        }
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(self.title, for: .normal)
        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)
        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) {}
}
