import Foundation
import SwiftData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    init(inMemory: Bool = false) {
        do {
            let schema = Schema([
                Goal.self,
                Sprint.self,
                FocusTask.self,
                DailySnapshot.self
            ])

            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: inMemory
            )

            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Could not create SwiftData container: \(error)")
        }
    }

    static let preview = PersistenceController(inMemory: true)
}
