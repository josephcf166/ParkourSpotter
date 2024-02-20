//
//  MapView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import SwiftUI
import MapKit

class NewContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    var locationManager: CLLocationManager?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        locationManager?.stopUpdatingLocation() // Stop updating to save battery
    }

    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("location services off")
        }
    }
    
    func checkLocationAuthorisation () {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location restricted")
        case .denied:
            print("location denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorisation()
    }
}

struct CustomMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var showingAlert: Bool
    @Binding var coordinates: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView(frame: .zero)
        mapView.setRegion(region, animated: true)
        mapView.delegate = context.coordinator
        
        // Adding Tap Gesture Recognizer
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped(_:)))
        mapView.addGestureRecognizer(tapRecognizer)
        
        mapView.showsUserLocation = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        @objc func mapTapped(_ sender: UITapGestureRecognizer) {
            if let mapView = sender.view as? MKMapView {
                let locationInView = sender.location(in: mapView)
                parent.coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
                print("Tapped at coordinates: \(parent.coordinates)")
                parent.showingAlert.toggle()
            }
        }
    }
    
}

struct NewMapView: View {
    @Binding var addSpot: Bool
    @StateObject private var viewModel = NewContentViewModel()
    @State private var mapSelection : String?
    @State private var showDetails : Bool = false
    @State private var sheetHeight : CGFloat = .zero
    @State private var showingAlert = false
    @State private var name : String = ""
    @State private var description : String = ""
    @State private var coordinates : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.810000, longitude: -122.477450)
    @State private var lowerValue : Double = 1
    @State private var upperValue : Double = 9
    
    var body: some View {
            ZStack(alignment: .topLeading){
                
                CustomMapView(region: $viewModel.region, showingAlert: $showingAlert, coordinates: $coordinates)
                    .edgesIgnoringSafeArea(.top)
                HStack{
                    Button(action: { addSpot = !addSpot }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.textLight)
                            .font(.title2)
                    }
                    .background(Color.primary)
                    .cornerRadius(10)
                    .buttonStyle(.bordered)
                    .padding()
                    
                    VStack{
                        Text("Press on map to add spot.")
                            .padding()
                            .foregroundColor(Color.textLight)
                    }
                    .background(Color.primary)
                    .cornerRadius(10)
                    .padding()
                }
                
            }
            .sheet(isPresented: $showingAlert, content: { addNewSpot })
            .background(Color.background)
    }
    
    func submit() {
        print("You entered name:\(name)\nCoordinates:\(coordinates)\n")
        //annotationItems[name] = MyAnnotationItem(name: name, coordinate: coordinates, difficulty: "\(Int(lowerValue))-\(Int(upperValue))", rating: 0, noOfRatings: 0, description: description, creatorUsername: "joemama")
        let annotation = Spot(name: name, latitude: Float(coordinates.latitude), longitude: Float(coordinates.longitude), difficulty: "\(Int(lowerValue))-\(Int(upperValue))", description: description, creatorUsername: "joemama")
        name=""
        description=""
        showingAlert = !showingAlert
        Task{
            await insertSpot(spot: annotation)
        }
    }
    
    func cancel() {
        print("Add spot cancelled")
        name=""
        description=""
        showingAlert = !showingAlert
    }
    
    func insertSpot(spot: Spot) async {
        do {
            // Try the asynchronous operation and wait for it to complete
            let result = try await supabase.database
                .from("Spots")
                .insert(spot)
                .execute()
            
            // Process the result if successful
            print("Spot inserted successfully: \(result)")
        } catch {
            // Handle any errors
            print("new map view")
            print("An error occurred: \(error)")
        }
    }
        
    var addNewSpot : some View {
        VStack(alignment: .center) {
            Text("Create new spot")
                .fontWeight(Font.Weight.bold)
                .padding(.top)
                .font(.system(size: 26))
            Divider().padding([.leading,.trailing,.bottom])
            Spacer()
            VStack{
                Text("Spot's name")
                    .foregroundColor(Color.textLight)
                TextField("", text: $name)
                    .padding([.bottom,.leading,.trailing])
                    .textFieldStyle(.roundedBorder)
                Text("Spot's description")
                    .foregroundColor(Color.textLight)
                TextEditor(text: $description)
                    .cornerRadius(10)
                    .frame(height: 150)
                    .padding([.leading,.trailing,.bottom])
            }
            .background(Color.primary)
            .cornerRadius(10)
            .padding()
            VStack{
                Text("Select the spot's difficulty range (1-10)")
                    .padding(.top)
                HStack{
                    Slider(value: $lowerValue,
                           in:1...10,
                           step:1,
                           minimumValueLabel: Text("1"),
                           maximumValueLabel: Text("10"),
                           label: {
                        Text("Values from 1 to 10")
                    }
                    )
                    .onChange(of: lowerValue) {
                        if lowerValue > upperValue - 1 {
                            lowerValue = upperValue - 1
                        }
                    }
                    Slider(value: $upperValue,
                           in:1...10,
                           step:1,
                           minimumValueLabel: Text("1"),
                           maximumValueLabel: Text("10"),
                           label: {
                        Text("Values from 1 to 10")
                    }
                    )
                    .onChange(of: upperValue) {
                        if upperValue < lowerValue + 1 {
                            upperValue = lowerValue + 1
                        }
                    }
                }
                .padding([.leading,.trailing])
                
                Text("\(Int(lowerValue))-\(Int(upperValue))")
                    .padding(.bottom)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primary, lineWidth: 5)
            )
            .padding()
            Spacer()
            HStack {
                Spacer()
                Button("Cancel", action: {cancel()})
                    .buttonStyle(.bordered)
                Spacer()
                Button("Add", action: {submit()})
                    .buttonStyle(.bordered)
                Spacer()
            }
        }
    }
    
}

