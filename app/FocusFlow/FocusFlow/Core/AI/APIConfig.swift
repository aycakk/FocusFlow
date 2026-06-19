import Foundation

// Where the FocusFlow AI backend lives.
// Real device: your Mac's LAN IP (both must be on the same Wi-Fi).
// Find it with: ipconfig getifaddr en0
enum APIConfig {
    static let baseURL = "http://192.168.1.106:8000"
}
