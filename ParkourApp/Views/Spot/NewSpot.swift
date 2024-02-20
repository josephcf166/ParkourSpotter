//
//  NewSpot.swift
//  ParkourApp
//
//  Created by joseph cauvy-foster on 04/02/2024.
//

import SwiftUI
import MapKit

struct NewSpot: View {
    var body: some View {
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
        .background(Color.background)
}

func submit() {
    print("You entered name:\(name)\nCoordinates:\(coordinates)\n")
    annotationItems[name] = MyAnnotationItem(name: name, coordinate: coordinates, difficulty: "\(Int(lowerValue))-\(Int(upperValue))", rating: 0, noOfRatings: 0, description: description, creatorUsername: "joemama")
    name=""
    description=""
    showingAlert = !showingAlert
}

func cancel() {
    print("Add spot cancelled")
    name=""
    description=""
    showingAlert = !showingAlert
}
