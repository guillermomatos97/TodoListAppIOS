//
//  UserDefaultsHelper.swift
//  TodolistApp
//
//  Created by Gullermo Antonio Matos Uc on 09/04/24.
//

import Foundation

final class UserDefaultsHelper {
    func save<T: Encodable>(customObject object: T, for key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }

    func get<T: Decodable>(type: T.Type, for key: String) -> T? {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            } else {
                print("Couldnt decode object")
                return nil
            }
        } else {
            print("Couldnt find key")
            return nil
        }
    }
}
