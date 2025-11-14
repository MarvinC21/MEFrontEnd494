import Testing
import Foundation
@testable import MacEvents

struct LikedStoreTests {

    @Test
    func toggleAndContains() {
        let store = LikedStore()
        store.toggle("abc")
        #expect(store.contains("abc"))
        store.toggle("abc")
        #expect(!store.contains("abc"))
    }

    @Test
    func removeOnlyTargetsSpecifiedID() {
        let store = LikedStore()
        store.ids = ["abc", "def"]
        store.remove("abc")
        #expect(!store.contains("abc"))
        #expect(store.contains("def"))
    }
    
    

   
}
