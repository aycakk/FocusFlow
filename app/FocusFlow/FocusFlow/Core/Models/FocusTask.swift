
import Foundation
import SwiftData



enum FocusTaskStatus:String,Codable{
    case pending
        case done
        case deferred
}
@Model
final class FocusTask {

    var id: UUID
    var title: String
    var createdAt: Date
    
    var priority: Int
    var estimatedMinutes: Int
    var statusRawValue: String
    var completedAt: Date?
    
    var status: FocusTaskStatus {
           get {
               FocusTaskStatus(rawValue: statusRawValue) ?? .pending
           }
           set {
               statusRawValue = newValue.rawValue
           }
       }

    
        

    init(
            id: UUID = UUID(),
            title: String,
            createdAt: Date = Date(),
            priority: Int,
            estimatedMinutes: Int,
            status: FocusTaskStatus = .pending,
            completedAt: Date? = nil
        ) {
            self.id = id
            self.title = title
            self.createdAt = createdAt
            self.priority = priority
            self.estimatedMinutes = estimatedMinutes
            self.statusRawValue = status.rawValue
            self.completedAt = completedAt
        }
}
