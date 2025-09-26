//  EventDetail.swift
//  MacEvents
//
//  Created by Iren Sanchez on 4/23/25.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

///
/// The navigation view page where all event details
/// are available after clicking on corresponding event widget
/// Return different view depending on whether there are event coordinates or not
///
struct EventDetail: View {
    let event: Event
    
    
    var body: some View {
        VStack{
            if event.coord != nil {
                let defaultTime = "None Specified"
                
                LocationMap(event: event)
                    .frame(height:550)
                    .padding(.top,-100)
                //                    .offset(y: 20)
                
                CircleImage(image:event.circleImage)
                    .offset(y: -130)
                    .padding(.bottom,-130)
                
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(event.date)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Time: \(event.time ?? defaultTime)")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack{
                        Link("More Info", destination: URL(string: event.link)!)
                            .frame(height: 30)
                            .buttonStyle(.borderedProminent)
                        
                        
                        if let coords = event.coord {
                            let eventCoord = CLLocationCoordinate2D(
                                latitude: coords[0],
                                longitude: coords[1]
                            )
                            
                            Button(action: {
                                openWalkingDirections(to: eventCoord, placeName: event.location)
                            }) {
                                Label("Location", systemImage: "mappin.and.ellipse")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                        .padding(.vertical, 38)
                    
                    Divider()
                    
                    ScrollView {
                        VStack{
                            Text(event.description)
                            Spacer()
                        }.frame(width: 410)
                    }
                }
                .padding(.leading)
            } else {
                let defaultTime = "None Specified"
                
                CircleImage(image:Image("MacLogoTextless"))
                    .offset(y: -130)
                    .padding(.bottom,-130)
                    .padding(.top, 140)
                
                VStack(alignment:.leading) {
                    Text(event.title)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(event.date)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Time: \(event.time ?? defaultTime)")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Divider()
                    
                    ScrollView {
                        VStack{
                            Text(event.description)
                            Spacer()
                        }
                        .frame(width: 380)
                    }
                    Link("More Info", destination: URL(string: event.link)!)
                        .frame(height: 30)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading)
                }
                
            }
        }
    }
    /// Opens Apple Maps with walking directions
    private func openWalkingDirections(to coordinate: CLLocationCoordinate2D, placeName: String) {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        destination.name = placeName
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}

#Preview {
    let sampleEvent = Event(
            id: "hi",
            title: "Sample Event",
            location:"Macalester",
            date: "Sunday, March 13th, 2025",
            time: nil,
            description: "test description",
            link: "google.com",
            starttime: "1400",
            endtime: "1600",
            coord: [44.93749, -93.16959]
            )
    EventDetail(event: sampleEvent)
}
