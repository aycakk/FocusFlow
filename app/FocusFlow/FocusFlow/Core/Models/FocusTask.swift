

import Foundation
import SwiftData

@Model
final class FocusTask {

    var id: UUID
    var title: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
    }
}
