import Foundation

protocol EventService {
    func fetchEvents() async throws -> [Event]
}

struct RemoteEventService: EventService {
    var session: URLSession
    let url: URL

    init(url: URL = URL(string: "https://mac-events-494-e4c3b3cxfhdca5fh.centralus-01.azurewebsites.net/events")!,
         session: URLSession = .shared) {
        self.url = url
        self.session = session
    }

    func fetchEvents() async throws -> [Event] {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Event].self, from: data)
    }
}

enum EventServiceFactory {
    static func make(arguments: [String] = ProcessInfo.processInfo.arguments) -> any EventService {
        if arguments.contains("UITestSampleData") {
            return SampleEventService()
        }
        return RemoteEventService()
    }
}

struct SampleEventService: EventService {
    let events: [Event]

    init(events: [Event] = SampleEventService.defaultEvents) {
        self.events = events
    }

    func fetchEvents() async throws -> [Event] {
        events
    }

    static let defaultEvents: [Event] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let baseDate = Date()
        let makeEvent: (String, Int) -> Event = { title, offset in
            Event(id: title.lowercased().replacingOccurrences(of: " ", with: "-"),
                  title: title,
                  location: "Campus Center",
                  date: formatter.string(from: Calendar.current.date(byAdding: .day, value: offset, to: baseDate) ?? baseDate),
                  time: "3:00 PM",
                  description: "UITest description for \(title)",
                  link: "https://www.macalester.edu",
                  starttime: nil,
                  endtime: nil,
                  coord: [44.937, -93.172])
        }
        return [
            makeEvent("Sample Event 1", 0),
            makeEvent("Sample Event 2", 1)
        ]
    }()
}
