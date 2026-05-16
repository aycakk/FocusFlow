import Foundation
import Observation

@Observable
final class DailyFocusViewModel {

    var tasks: [FocusTask] = []

    init() {
        tasks = MockSprintFactory.makeTasks()
    }
}
