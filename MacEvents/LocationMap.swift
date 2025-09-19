//
//  LocationMap.swift
//  MacEvents
//
//  Created by Marvin Swift on 4/30/25.
//

import SwiftUI
import MapKit

///
/// A map view on which event location and user
/// location (if permitted) are displayed
///
public struct LocationMap: View {
    var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    public var body: some View {
        let eventCoord = CLLocationCoordinate2D(
            latitude: event.coord![0],
            longitude: event.coord![1]
        )
        
        let campusCenter = CLLocationCoordinate2D(
            latitude: 44.937913,
            longitude: -93.168521
        )
        
        let region = MKCoordinateRegion(
            center: campusCenter,
            latitudinalMeters: 450,
            longitudinalMeters: 60
        )
        
        ZStack(alignment: .bottomTrailing) {
            // Main map
            Map(
                initialPosition: .region(region),
                bounds: MapCameraBounds(
                    centerCoordinateBounds: region,
                    maximumDistance: 1100
                ),
                interactionModes: [.zoom, .pan]
            ) {
                // Event marker
                Marker(coordinate: eventCoord) {
                    Text(event.location)
                }
                // User location
                UserAnnotation()
            }
            .mapStyle(.hybrid)
            
            // 🚶 Walking Directions Button
            Button(action: {
                openWalkingDirections(to: eventCoord, placeName: event.location)
            }) {
                Label("Walk", systemImage: "figure.walk")
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
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
    let event = Event(
        id: "10",
        title: "FreakCon",
        location: "Janet Wallace Fine Arts Center",
        date: "Saturday, May 10, 2025",
        description: "FreakCon 2025 2nd Bicentennial Anniversary",
        link: "google.com",
        coord: [44.93749, -93.16959]
    )
    
    LocationMap(event: event)
}
