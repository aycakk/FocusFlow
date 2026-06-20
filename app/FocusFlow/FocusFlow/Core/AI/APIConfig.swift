import Foundation

// Where the FocusFlow AI backend lives.
//
// Simulator shares the Mac's network → localhost works directly.
// Real device must reach the Mac over the LAN, so it needs the Mac's IP
// (both on the same Wi-Fi/hotspot). Update the device IP when the network
// changes — find it with: ipconfig getifaddr en0
enum APIConfig {
    #if targetEnvironment(simulator)
    static let baseURL = "http://localhost:8000"
    #else
    static let baseURL = "http://172.20.10.12:8000"   // Mac's LAN IP for a real device
    #endif
}
