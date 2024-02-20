//
//  MapView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 09/12/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var mapSelection : String?
    @State private var showDetails : Bool = false
    @State private var sheetHeight: CGFloat = .zero
    @State var addSpot: Bool = false
    @State private var annotations: [Spot] = []
    
    var body: some View {
        
        if !addSpot {
            
            ZStack(alignment: .topLeading){
                
                Map(position: viewModel.$position, selection: $mapSelection) {
                    UserAnnotation()
                    ForEach(annotations) { item in
                        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.latitude), longitude: CLLocationDegrees(item.longitude))
                        Marker(item.name, coordinate: coordinates).tag(item.name).tint(Color.primary)
                    }
                }
                .accentColor(Color.primary)
                .onAppear {viewModel.checkIfLocationServicesIsEnabled();viewModel.checkLocationAuthorisation()}
                .mapControls{MapCompass()
                    MapUserLocationButton()}
                .onChange(of: mapSelection, {oldValue, newValue in
                    showDetails =  newValue != nil
                })
                .sheet(isPresented: $showDetails , content: {
                    SpotView(mapSelection: $mapSelection, show: $showDetails)
                }).onDisappear {
                    mapSelection = nil
                }
                    
                Button(action: { addSpot = !addSpot }) {
                    Image(systemName: "plus")
                        .foregroundColor(.textLight)
                        .font(.title2)
                }
                .background(Color.primary)
                .cornerRadius(10)
                .buttonStyle(.bordered)
                .padding()
                .task{
                    let result = await viewModel.fetchSpots()
                    
                    switch result {
                    case .success(let spots):
                        annotations = spots
                        for spot in spots {
                            annotationItems[spot.name] = spot
                        }
                        
                        print("Fetched Spots: \(spots)")
                        
                    case .failure(let error):
                        print("map view")
                        print("An error occurred: \(error.localizedDescription)")
                        
                    }
                }
                
            }
        }
        else {
            
            NewMapView(addSpot: $addSpot)
            
        }
        
    }
    
}


struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    @Published var region = MKCoordinateRegion()
    
    @State var position : MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -121),
                                                                         span:MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
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
            region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.810000, longitude: -122.477450),
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            position = .region(region)
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorisation()
    }
    
    func fetchSpots() async -> Result<[Spot], Error> {
        do {
            // Execute the query
            let response = try await supabase.database
                .from("Spots")
                .select()
                .execute()
            
            // Assuming the response data is in `response.data`
            // You will need to decode the JSON from the response data manually
            if let data: Data? = response.data {
                do {
                    // Decode the data into an array of Review models
                    let spots = try JSONDecoder().decode([Spot].self, from: data!)
                    return .success(spots)
                } catch {
                    // Handle JSON decoding errors
                    return .failure(error)
                }
            } else {
                // Handle the case where there's no data
                return .failure(NSError(domain: "NoData", code: 0, userInfo: nil))
            }
        } catch {
            // Handle other errors (e.g., network errors)
            return .failure(error)
        }
    }
}

