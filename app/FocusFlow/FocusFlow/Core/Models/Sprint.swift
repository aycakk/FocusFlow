import Foundation
import SwiftData

enum SprintStatus: String, Codable {
    case active
    case completed
    case archived
}

@Model
final class Sprint {

    var id: UUID
    var title: String
    var createdAt: Date

    var startDate: Date
    var endDate: Date
    var statusRawValue: String

    @Relationship(deleteRule: .cascade) //Bir Sprint silinirse, ona bağlı task’lar da silinsin.
    var tasks: [FocusTask]

    var status: SprintStatus {
        get {
            SprintStatus(rawValue: statusRawValue) ?? .active
        }
        set {
            statusRawValue = newValue.rawValue
        }
    }

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        startDate: Date = Date(),
        endDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
        status: SprintStatus = .active,
        tasks: [FocusTask] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.startDate = startDate
        self.endDate = endDate
        self.statusRawValue = status.rawValue
        self.tasks = tasks
    }
}
