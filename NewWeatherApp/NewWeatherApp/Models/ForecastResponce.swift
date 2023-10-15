//
//  ForecastResponce.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import Foundation

// MARK: - ForecastResponce

public struct ForecastResponce: Codable, Equatable {
    public let cod: String?
    public let message: Int?
    public let cnt: Int?
    public let list: [ForecastList]?
    public let city: ForecastCity?
}

// MARK: - City

public struct ForecastCity: Codable, Equatable {
    public let id: Int?
    public let name: String?
    public let coord: ForecastCoord?
    public let country: String?
    public let population: Int?
    public let timezone: Int?
    public let sunrise: Int?
    public let sunset: Int?
}

// MARK: - Coord

public struct ForecastCoord: Codable, Equatable {
    public let lat: Double?
    public let lon: Double?
}

// MARK: - List

public struct ForecastList: Codable, Equatable {
    public let dt: Int?
    public let main: ForecastMainClass?
    public let weather: [ForecastWeather]?
    public let clouds: ForecastClouds?
    public let wind: ForecastWind?
    public let visibility: Int?
    public let pop: Double?
    public let sys: ForecastSys?
    public let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case visibility = "visibility"
        case pop = "pop"
        case sys = "sys"
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds

public struct ForecastClouds: Codable, Equatable {
    public let all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

// MARK: - MainClass

public struct ForecastMainClass: Codable, Equatable {
    public let temp: Double?
    public let feelsLike: Double?
    public let tempMin: Double?
    public let tempMax: Double?
    public let pressure: Int?
    public let seaLevel: Int?
    public let grndLevel: Int?
    public let humidity: Int?
    public let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys

public struct ForecastSys: Codable, Equatable {
    public let pod: Pod?

    enum CodingKeys: String, CodingKey {
        case pod = "pod"
    }
}

public enum Pod: String, Codable, Equatable {
    case d = "d"
    case n = "n"
}


// MARK: - Weather

public struct ForecastWeather: Codable, Equatable {
    public let id: Int?
    public let main: String?
    public let description: String?
    public let icon: String?
}

// MARK: - Wind

public struct ForecastWind: Codable, Equatable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?
}
