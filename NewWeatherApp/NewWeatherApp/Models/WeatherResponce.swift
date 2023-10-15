//
//  WeatherResponce.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import Foundation

// MARK: - WeatherResponce

public struct WeatherResponce: Codable, Equatable {
    public let coord: Coord?
    public let weather: [Weather]?
    public let base: String?
    public let main: Main?
    public let visibility: Int?
    public let wind: Wind?
    public let clouds: Clouds?
    public let dt: Int?
    public let sys: Sys?
    public let timezone: Int?
    public let id: Int?
    public let name: String?
    public let cod: Int?
}

// MARK: - Clouds

public struct Clouds: Codable, Equatable {
    public let all: Int?
}

// MARK: - Coord

public struct Coord: Codable, Equatable {
    public let lon: Double?
    public let lat: Double?
}

// MARK: - Main
public struct Main: Codable, Equatable {
    public let temp: Double?
    public let feelsLike: Double?
    public let tempMin: Double?
    public let tempMax: Double?
    public let pressure: Int?
    public let humidity: Int?
    public let seaLevel: Int?
    public let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys

public struct Sys: Codable, Equatable {
    public let country: String?
    public let sunrise: Int?
    public let sunset: Int?
}

// MARK: - Weather

public struct Weather: Codable, Equatable {
    public let id: Int?
    public let main: String?
    public let description: String?
    public let icon: String?
}

// MARK: - Wind

public struct Wind: Codable, Equatable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?
}
