//
//  LikedStoreTests.swift
//  MacEvents
//
//  Created by Tenzin Dayoe on 10/29/25.
//

//  LikedStoreTests.swift
//  MacEventsTests

import Testing
import Foundation
@testable import MacEvents

struct LikedStoreTests {
    
    @Test func testToggleAndContains() {
        // Arrange
        let store = LikedStore()
        store.ids = []  // start clean
        
        // Act
        store.toggle("event1")
        
        // Assert
        #expect(store.contains("event1"))
        
        // Act again (toggle off)
        store.toggle("event1")
        
        // Assert
        #expect(!store.contains("event1"))
    }
    
    @Test func testRemove() {
        let store = LikedStore()
        store.ids = ["event1", "event2"]
        store.remove("event1")
        
        #expect(!store.contains("event1"))
        #expect(store.contains("event2"))
    }
    
    @Test func testPersistenceLoadAndSave() {
        let key = "liked_event_ids_v1"
        let store = LikedStore()
        store.ids = ["eventA", "eventB"]
        store.toggle("eventC") // triggers save
        
        // Manually reinitialize (simulate new launch)
        let newStore = LikedStore()
        let storedArray = UserDefaults.standard.array(forKey: key) as? [String] ?? []
        
        #expect(Set(storedArray).isSuperset(of: ["eventA", "eventB", "eventC"]))
        #expect(newStore.ids.isSuperset(of: ["eventA", "eventB", "eventC"]))
    }
}
