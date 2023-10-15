//
//  UserDefaultsService.swift
//  NewWeatherApp
//
//  Created by Kate on 15.10.2023.
//

import Foundation

struct UserDefaultsService {
    enum Keys: String {
        case lastCity
    }

    static var lastCity: String {
        get { UserDefaults.standard.value(forKey: Keys.lastCity.rawValue) as? String ?? "" }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.lastCity.rawValue) }
    }
}
