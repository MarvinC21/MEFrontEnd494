import SwiftUI
import MapKit

struct LocationMap: View {
    let event: Event

    init(event: Event) { self.event = event }

    var body: some View {
        // Safely read lat/lon
        let lat = event.coord?[0] ?? 44.937913
        let lon = event.coord?[1] ?? -93.168521
        let eventCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)

        let region = MKCoordinateRegion(
            center: eventCoord,
            latitudinalMeters: 600,
            longitudinalMeters: 600
        )

        ZStack(alignment: .bottomTrailing) {
            Map(initialPosition: .region(region), interactionModes: [.zoom, .pan]) {
                Marker(event.location, coordinate: eventCoord)
                UserAnnotation()
            }
            .mapStyle(.hybrid)
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
}
