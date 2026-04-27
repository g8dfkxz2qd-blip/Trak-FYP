//
//  LoadPageViewModel.swift
//  Trak
//
//  Created by James Price on 10/04/2026.
//
import Foundation
import Combine

@MainActor
final class LoadPageViewModel: ObservableObject {
    @Published var nickname: String = ""
    
    var cleanedName: String {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
                                                // validateiong to chek if name is empty 
    var valid: Bool {
        !cleanedName.isEmpty
    }
    
    
    
}
