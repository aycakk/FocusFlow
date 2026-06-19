import Foundation

// Real AI service: talks to the FastAPI + Ollama backend over HTTP.
// On ANY failure it quietly falls back to MockAIService, so the app
// keeps working offline / when the Mac server is down.

struct OllamaService: AIService {

    private let fallback = MockAIService()

    // MARK: - AIService

    func planningQuestions(for goalTitle: String) async -> [PlanningQuestion] {
        do {
            let response: QuestionsResponse = try await post(
                "/planning-questions",
                body: QuestionsRequest(goalTitle: goalTitle)
            )
            return response.questions.map {
                PlanningQuestion(key: $0.key, prompt: $0.prompt, placeholder: $0.placeholder)
            }
        } catch {
            return await fallback.planningQuestions(for: goalTitle)
        }
    }

    func generatePlan(
        goalTitle: String,
        answers: [String: String],
        dailyMinutes: Int
    ) async -> [PlanTask] {
        do {
            let response: PlanResponse = try await post(
                "/generate-plan",
                body: PlanRequest(goalTitle: goalTitle, answers: answers, dailyMinutes: dailyMinutes)
            )
            return response.tasks.map {
                PlanTask(title: $0.title, theme: $0.theme,
                         estimatedMinutes: $0.estimatedMinutes, priority: $0.priority)
            }
        } catch {
            return await fallback.generatePlan(
                goalTitle: goalTitle, answers: answers, dailyMinutes: dailyMinutes
            )
        }
    }
    
    func insightNote(completedToday: Int, totalToday: Int) async -> String {
        do {
            let response: InsightResponse = try await post(
                "/insight-note",
                body: InsightRequest(completedToday: completedToday, totalToday: totalToday)
            )
            return response.note
        } catch {
            return await fallback.insightNote(completedToday: completedToday, totalToday: totalToday)
        }
    }

    // MARK: - Networking

    private func post<Body: Encodable, Response: Decodable>(
        _ path: String,
        body: Body
    ) async throws -> Response {
        guard let url = URL(string: APIConfig.baseURL + path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        request.timeoutInterval = 60

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

// MARK: - Wire types (match the backend JSON)

private struct QuestionsRequest: Encodable {
    let goalTitle: String
}

private struct QuestionsResponse: Decodable {
    let questions: [QuestionDTO]
}

private struct QuestionDTO: Decodable {
    let key: String
    let prompt: String
    let placeholder: String
}

private struct PlanRequest: Encodable {
    let goalTitle: String
    let answers: [String: String]
    let dailyMinutes: Int
}

private struct PlanResponse: Decodable {
    let tasks: [PlanTaskDTO]
}

private struct PlanTaskDTO: Decodable {
    let title: String
    let theme: String
    let estimatedMinutes: Int
    let priority: Int
}
private struct InsightRequest: Encodable {
    let completedToday: Int
    let totalToday: Int
}

private struct InsightResponse: Decodable {
    let note: String
}
