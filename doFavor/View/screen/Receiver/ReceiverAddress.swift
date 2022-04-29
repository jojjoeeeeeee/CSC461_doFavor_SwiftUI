//
//  ReceiverAddress.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI
import MapKit
import CoreLocation

struct ReceiverAddress: View {
    @ObservedObject var formData = FormDataObservedModel()
    @State var kwAddress: String = ""
    @State var isLoading: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isValidateFail: Bool = false
    @State var isAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    
    func fetchFormData() {
        isLoading.toggle()
    
        TransactionViewModel().getFormData() { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
//                print("Success",response)
                formData.landmark = response.landmark
                formData.type = response.type
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    print(msg)
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                case .NoNetworkError:
                    isAlert = true
                    isNoNetwork.toggle()
                }
            }
        }
    }
    
    
    var body: some View {
        
        doFavorMainLoadingIndicatorView(isLoading: isLoading) {
            GeometryReader{ geometry in
                ZStack{
                    
                    VStack(spacing:0){
                        doFavorMapView()
                        MapView()
                            .onTapGesture {
//                                UIApplication.shared.endEditing()
                            }
                        AddressView(formData: formData, isAlert: $isAlert, isValidateFail: $isValidateFail)
                        TabbarView()
                    }
                    .edgesIgnoringSafeArea(.bottom)

                }
                .onAppear{fetchFormData()}
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    HStack{
                    Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName:"arrow.left")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(Color.darkest)
                    }
                        TextField("ค้นหาที่อยู่...", text: self.$kwAddress)
                        .font(Font.custom("SukhumvitSet-Bold", size: 15))

                    }
    //                 .background(Color.white)

                )

            }.alert(isPresented:$isAlert) {
                if isExpired {
                    return Alert(
                        title: Text("Session Expired"),
                        message: Text("this account is signed-in from another location please sign-in again"),
                        dismissButton: .destructive(Text("Ok")) {
                            AppUtils.eraseAllUsrData()
                            doFavorApp(rootView: .LoginView)
                        }
                    )
                }
                else if isNoNetwork {
                    return Alert(
                        title: Text("Error"),
                        message: Text("No network connection please try again"),
                        dismissButton: .default(Text("Ok")) {
                            isLoading = false
                            isNoNetwork = false
                        }
                    )
                }
                else {
                    return Alert(
                        title: Text("เกิดข้อผิดพลาด"),
                        message: Text("กรุณาเลือกอาคารใกล้เคียง"),
                        dismissButton: .default(Text("Ok")) {
                            isAlert = false
                            isValidateFail = false
                        }
                    )
                }
                
            }
        }

    }
}

struct AddressView: View{
    @StateObject public var formData = FormDataObservedModel()
    @ObservedObject var ContentView = ContentViewModel()

//    @StateObject public var model = userLocationObservedModel()
    @State var address: userLocationDataModel?

    @State var lmRoom: String = "" //landmark room
    @State var lmFloor: String = ""
    @State var lmBuilding: String = ""
    @State var addNote: String = ""
    @State private var selectedLandmark = "เลือกอาคาร"
    @State private var selectionIndex : Int = -1
    @State private var pickerType = 0
    
    @Binding var isAlert: Bool
    @Binding var isValidateFail: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    private var isShowingOverlay: Bool {
        get {
            return self.pickerType != 0
        }
    }

    private var landmarkPicker: some View{
        pickerSheet(selection: $selectedLandmark, selectionIndex: $selectionIndex, data: formData.landmark!, pickerType: $pickerType)
    }

    private var pickerOverlay: some View {
        Group {
            if pickerType == 1 {
                landmarkPicker
            } else {
                EmptyView()
            }
        }
    }
    
    private func validateUserLocation() {
        
        for i in 0..<(formData.landmark?.count ?? 0) {
//            print("STATEMENT",selectedLandmark == (formData.landmark?[i].name ?? ""))
            if selectedLandmark == (formData.landmark?[i].name ?? "") {
                selectionIndex = i
                formatUserLocation()
            }
        }
        
        if selectionIndex == -1 {
            isAlert = true
            isValidateFail = true
        } else {
            formatUserLocation()
        }
    }
    
    private func formatUserLocation(){
        let model = userLocationDataModel(room: lmRoom, floor: lmFloor, building: selectedLandmark, optional: addNote, latitude: Double(ContentView.region.center.latitude), longitude: Double(ContentView.region.center.longitude))
        do {

            try AppUtils.saveUsrAddress(model: model)
            self.presentationMode.wrappedValue.dismiss()

        }catch{
            print("Unable to Encode Note (\(error))")
        }
        
        
    }


    var body: some View{
        VStack(spacing:20){
            HStack{
                Text("ห้อง")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("หมายเลขห้อง..",text: $lmRoom)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )
                
                Text("ชั้น")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("ชั้น..",text: $lmFloor)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )

            }
            
            //Picker
            HStack{
                Text("อาคารใกล้เคียง")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))
                Button(action: {
                    UIApplication.shared.endEditing()
                    
                    if (formData.landmark?.count ?? 0) > 0 {
                        self.pickerType = 1
                    }
                }){
                    Text("\(self.selectedLandmark)")
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .semibold))
                        .padding()
                }
                .frame(height:36)
                .foregroundColor(Color.darkred.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                )
            }
            
            HStack{
                Text("อื่นๆ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("หมายเหตุ  ระบุตำแหน่งเพิ่มเติม",text: $addNote)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )
            }
            

            //button
            Button(action: {
                validateUserLocation()
            }){
                Text("ยืนยัน")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                    .frame(width:UIScreen.main.bounds.width-40, height: 50)
                    .background(Color.darkred)
                    .cornerRadius(15)

            }
            .padding(.bottom)
            .keyboardAware(multiplier: 0.4)

        }
        .padding(.top,20)
        .padding(.horizontal,20)
        .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))
        .onAppear{
            address = AppUtils.getUsrAddress()
            lmRoom = address?.room ?? ""
            lmFloor = address?.floor ?? ""
            selectedLandmark = address?.building ?? ""
            addNote = address?.optional ?? ""
        }
        

        if isShowingOverlay {
            pickerOverlay
                .frame(alignment: .bottomTrailing)
                .transition(AnyTransition.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5))

        }


    }
}

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct MapView: View{
    @StateObject private var viewModel = ContentViewModel()
//    @StateObject var managerDelegate = locationDelegate()

    let markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), tint: .red))]

    var body: some View{
        ZStack(alignment: .bottomTrailing){
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true,annotationItems: markers){
                marker in
                marker.location
            }
            .onAppear{
                viewModel.requestLocationPermission()
            }
            
            Button(action: {
                viewModel.getCurrentLocation()
            }){
                Image(systemName: "location.fill")
                    .font(.system(size: 27, weight: .light))
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.darkred)
            }
            .cornerRadius(50)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .padding()
        }
    }
}

struct ReceiverAddress_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate{
    var map = MKMapView()
    
    let locationManager = CLLocationManager()
    private var mapChangedFromUserInteraction = false
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.74486, longitude: 100.56472), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

        override init(){
        super.init()
        locationManager.delegate = self
        map.delegate = self
    }
    
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool){
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()

        if mapChangedFromUserInteraction{
            print("user WILL change map.")
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let mapLatitude = mapView.centerCoordinate.latitude
        let mapLongitude = mapView.centerCoordinate.longitude
        var center = "Latitude: \(mapLatitude) Longitude: \(mapLongitude)"
        print(center)
        
        if mapChangedFromUserInteraction{
            print("user CHANGED map.")
            print(mapLatitude)
            print(mapLongitude)
        }
    }
    
    func requestLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    //mapView didchange
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        let view = map.subviews[0]
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
    
    
    //Real-time update location
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if manager.authorizationStatus == .authorizedWhenInUse {
//            print("Authorized...")
//            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            manager.startUpdatingLocation()
//        } else {
//            print("Not Authorized...")
//            manager.requestWhenInUseAuthorization()
//        }
//    }
    
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
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.map.setRegion(self.region, animated: true)
            print("region",self.region.center)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription )")
    }
    
}
