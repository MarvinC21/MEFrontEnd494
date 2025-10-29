// LikedStore.swift
import SwiftUI

final class LikedStore: ObservableObject {
    @Published var ids: Set<String> = []
    private let key = "liked_event_ids_v1"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    func contains(_ id: String) -> Bool { ids.contains(id) }

    func toggle(_ id: String) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        save()
    }

    func remove(_ id: String) {
        ids.remove(id)
        save()
    }

    private func load() {
        if let arr = defaults.array(forKey: key) as? [String] {
            ids = Set(arr)
        }
    }

    private func save() {
        defaults.set(Array(ids), forKey: key)
    }
}
