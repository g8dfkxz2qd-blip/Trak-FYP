//
//  EffortPoint.swift
//  Trak
//
//  Created by James Price on 09/04/2026.
//

import Foundation

struct EffortPoint: Identifiable {      // helps to draw graph data
    let id = UUID()
    let index: Int
    let score: Double
}
