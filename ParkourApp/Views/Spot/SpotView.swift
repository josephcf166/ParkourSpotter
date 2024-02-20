//
//  SpotView.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 23/01/2024.
//

import Foundation
import SwiftUI
import MapKit

struct SpotView: View {
    @Binding var mapSelection: String?
    @Binding var show: Bool
    @State var spotViewState: Int = 1
    //@State var spot: Spot
    
    var body: some View {
        var item : Spot = annotationItems[mapSelection!]!
        VStack{
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if (spotViewState != 2) {
                        Button(action: {
                            spotViewState = 2
                        }) {
                            Text("Add Review")
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print("Bookmark button tapped")
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(.secondary)
                            .font(.title2)
                    }
                    
                    Button(action: {
                        print("Directions button tapped")
                    }) {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                }.background(Color.background)
                
                HStack{
                    Spacer()
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        //.foregroundColor(Color.red)
                    Spacer()
                }
                
            }
            .padding([.leading,.top,.trailing])
            
            
            HStack() {
                Button("Details", action: {spotViewState = 1})
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(spotViewState==1 ? Color.primary : Color.secondary)
                    .buttonStyle(.bordered)
                Button("Reviews", action: {spotViewState = 3})
                    .frame(maxWidth: .infinity)
                    .foregroundColor(spotViewState==3 ? Color.primary : Color.secondary)
                    .buttonStyle(.bordered)
                Button("Media", action: {spotViewState = 4})
                    .padding(.trailing)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(spotViewState==4 ? Color.primary : Color.secondary)
                    .buttonStyle(.bordered)
            }
            
            Divider()
                .background(Color.gray)
        
    
            switch spotViewState {
            case 1:
                SpotDetailsView(mapSelection: $mapSelection, show: $show, spotViewState: $spotViewState, item: item)
            case 2:
                AddSpotReview(spotViewState: $spotViewState, spotName: item.name, mapSelection: $mapSelection)
            case 3:
                SpotReviewsView(mapSelection: $mapSelection, show: $show, spotViewState: $spotViewState, item: item)
            default:
                SpotMediaView(mapSelection: $mapSelection, show: $show, spotViewState: $spotViewState, item: item)
            }

        }.background(Color.background)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task{
                let result = await fetchSpotDetails(name: mapSelection!)
                
                switch result {
                case .success(let spots):
                    item = spots[0]
                    print("Fetched spot: \(spots)")
                    
                case .failure(let error):
                    print("spot view")
                    print("An error occurred: \(error.localizedDescription)")
                
            }
        }
            
    }
    
}

func fetchSpotDetails(name: String) async -> Result<[Spot], Error> {
    do {
        // Execute the query
        let response = try await supabase.database
            .from("Spots")
            .select()
            .eq("name", value: name)
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
