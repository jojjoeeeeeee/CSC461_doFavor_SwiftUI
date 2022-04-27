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
    @State var isFieldError: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    
    func fetchFormData() {
        isLoading.toggle()
        
        TransactionViewModel().getFormData() { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
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
        
        GeometryReader{ geometry in
            ZStack{
                
                VStack(spacing:0){
                    MapView()
//                    AddressView(formData: formData)
//                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)

            }
//            .onAppear{fetchFormData()}
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

        }

    }
}

struct AddressView: View{
    @StateObject public var formData = FormDataObservedModel()

    @State var lmRoom: String = "" //landmark room
    @State var lmFloor: String = ""
    @State var lmBuilding: String = ""
    @State var addNote: String = ""
    @State private var selectedLandmark = "เลือกอาคาร"
    @State private var selectionIndex : Int = -1
    @State private var pickerType = 0
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
//                    if detail.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace} == "" {
//                        detail = detailPlaceholder
//                    }
                    
                    self.pickerType = 1
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
            }){
                Text("ยืนยัน")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)
            .padding(.bottom)

        }
        .padding(.top,20)
        .padding(.horizontal,20)
        .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))

        if isShowingOverlay {
            pickerOverlay
                .frame(alignment: .bottomTrailing)
                .transition(AnyTransition.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5))

        }


    }
}

struct MapView: View{
    @StateObject private var viewModel = ContentViewModel()

    var body: some View{
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true).onAppear{
                viewModel.requestLocationPermission()
            }
            
            Button(action: {
                viewModel.getCurrentLocation()
            }){
                Text("Current Location")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.grey)
            }
            .cornerRadius(10)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .padding()
        }
    }
}

struct ReceiverAddress_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverAddress()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
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
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription )")
    }
    
//
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
}
