//  EventDetail.swift
//  MacEvents
//
//  Created by Iren Sanchez on 4/23/25.
//  Updated: share Macalester URL only + system share sheet

import SwiftUI
import CoreLocation
import MapKit
import UIKit

struct EventDetail: View {
    let event: Event
    
    
    var body: some View {
        VStack{
            if event.coord != nil {
                let defaultTime = "None Specified"
                
                LocationMap(event: event)
                    .frame(height:550)
                    .padding(.top,-100)
                
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

// MARK: - Small helpers

private struct ZstackFallback: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.thinMaterial)
            Image(systemName: "map")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Subviews

private struct PillIconButton: View {
    var title: String?
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            if let title {
                Label(title, systemImage: systemImage)
                    .labelStyle(.titleAndIcon)
            } else {
                Image(systemName: systemImage)
            }
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
    }
}

private struct CopiedToast: View {
    var body: some View {
        Label("Link copied", systemImage: "checkmark.circle.fill")
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.top, 4)
    }
}

private struct InfoSheet: View {
    let event: Event
    let url: URL?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(event.title).font(.title2.bold())

                    if !event.location.isEmpty {
                        Label(event.location, systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 8) {
                        Label(event.date, systemImage: "calendar")
                        if let time = event.time, !time.isEmpty {
                            Label(time, systemImage: "clock")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Divider()

                    if !event.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(event.description)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let url {
                        Link(destination: url) {
                            Label("Open website", systemImage: "safari")
                                .font(.body.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.blue.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("More info")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - UIKit share sheet wrapper

private struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) { }
}

// MARK: - Preview

#Preview {
    let sampleEvent = Event(
        id: "abc123",
        title: "Sample Event",
        location: "Macalester College",
        date: "Sunday, March 13, 2025",
        time: "2:00–4:00 PM",
        description: "A friendly example of an event with a longer description. Bring snacks!",
        link: "https://www.macalester.edu/calendar/event/?id=16018",
        starttime: "1400",
        endtime: "1600",
        coord: [44.93749, -93.16959]
    )
    NavigationStack { EventDetail(event: sampleEvent) }
}
