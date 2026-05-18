import Foundation
import SwiftData

@Model
final class Goal {

    var id: UUID
    var title: String
    var createdAt: Date
    var isActive: Bool

    @Relationship(deleteRule: .cascade)
    var sprints: [Sprint]

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date(),
        isActive: Bool = true,
        sprints: [Sprint] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.isActive = isActive
        self.sprints = sprints
    }
}
