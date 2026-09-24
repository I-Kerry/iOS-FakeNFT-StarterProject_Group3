//
//  UserDefaultsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Kirill Maidanovich on 24.09.2026.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Key {
        static let cartSort = "cartSort"
    }
    
    var cartSort: String {
        get { defaults.string(forKey: Key.cartSort) ?? "byName" }
        set { defaults.set(newValue, forKey: Key.cartSort) }
    }
}
