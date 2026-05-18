//
//  Item.swift
//  FocusFlow
//
//  Created by Ayça Kaycalı on 16.05.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
