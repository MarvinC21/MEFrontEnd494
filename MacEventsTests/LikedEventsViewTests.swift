//
//  LikedEventsViewTests.swift
//  MacEvents
//
//  Created by Tenzin Dayoe on 10/29/25.
//

//  LikedEventsViewTests.swift
//  MacEventsTests

import Testing
import Foundation
@testable import MacEvents

struct LikedEventsViewTests {
    
    func makeEvent(id: String, dateString: String) -> Event {
        Event(id: id,
              title: "Event \(id)",
              location: "Campus",
              date: dateString,
              description: "",
              link: "")
    }
    
    @Test func testUpcomingLikedFiltersCorrectly() {
        // Arrange
        let liked = LikedStore()
        liked.ids = ["1", "3"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        
        // 1 is future, 2 is past, 3 is today
        let futureDate = formatter.string(from: Date().addingTimeInterval(86400))
        let pastDate = formatter.string(from: Date().addingTimeInterval(-86400))
        let todayDate = formatter.string(from: Date())
        
        let allEvents = [
            makeEvent(id: "1", dateString: futureDate),
            makeEvent(id: "2", dateString: pastDate),
            makeEvent(id: "3", dateString: todayDate)
        ]
        
        // Act
        let today = Calendar.current.startOfDay(for: Date())
        let upcoming = allEvents
            .filter { liked.contains($0.id) && $0.formatDate() >= today }
            .sorted(by: <)
        
        // Assert
        #expect(upcoming.count == 2)  // only "1" and "3" are liked & >= today
        #expect(upcoming.map(\.id).contains("1"))
        #expect(upcoming.map(\.id).contains("3"))
    }
    
    @Test func testAllowedDaysComponentsExtraction() {
        let liked = LikedStore()
        liked.ids = ["1"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let futureDate = formatter.string(from: Date().addingTimeInterval(86400))
        
        let ev = makeEvent(id: "1", dateString: futureDate)
        let cal = Calendar.current
        
        let allowedDays = Set([cal.dateComponents([.year, .month, .day], from: ev.formatDate())])
        #expect(!allowedDays.isEmpty)
    }
}
