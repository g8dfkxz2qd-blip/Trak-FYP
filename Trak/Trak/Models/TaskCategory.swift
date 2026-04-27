//
//  CategoryModel.swift
//  Trak
//
//
//

import Foundation

enum TaskCategory: String, CaseIterable, Identifiable, Codable { // enum is fixed list raw values
    case education
    case work
    case personal
    case social
    case home
    case miscellaneous
    
    var id : String {
        return rawValue // string value of enum case
    }
    
    var displayName: String { // converts enum cases into user friendly labels
        switch self {
        case .education: return "Education"
        case .work: return "Work"
        case .personal: return "Personal"
        case .social: return "Social"
        case .home: return "Home"
        case .miscellaneous: return "Miscellaneous"
        }
    }
}
