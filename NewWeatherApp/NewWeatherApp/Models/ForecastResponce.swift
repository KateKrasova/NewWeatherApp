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

    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }

    public init(cod: String?, message: Int?, cnt: Int?, list: [ForecastList]?, city: ForecastCity?) {
        self.cod = cod
        self.message = message
        self.cnt = cnt
        self.list = list
        self.city = city
    }
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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case coord = "coord"
        case country = "country"
        case population = "population"
        case timezone = "timezone"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }

    public init(id: Int?, name: String?, coord: ForecastCoord?, country: String?, population: Int?, timezone: Int?, sunrise: Int?, sunset: Int?) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.population = population
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - Coord
public struct ForecastCoord: Codable, Equatable {
    public let lat: Double?
    public let lon: Double?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }

    public init(lat: Double?, lon: Double?) {
        self.lat = lat
        self.lon = lon
    }
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

    public init(dt: Int?, main: ForecastMainClass?, weather: [ForecastWeather]?, clouds: ForecastClouds?, wind: ForecastWind?, visibility: Int?, pop: Double?, sys: ForecastSys?, dtTxt: String?) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.clouds = clouds
        self.wind = wind
        self.visibility = visibility
        self.pop = pop
        self.sys = sys
        self.dtTxt = dtTxt
    }
}

// MARK: - Clouds
public struct ForecastClouds: Codable, Equatable {
    public let all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }

    public init(all: Int?) {
        self.all = all
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

    public init(temp: Double?, feelsLike: Double?, tempMin: Double?, tempMax: Double?, pressure: Int?, seaLevel: Int?, grndLevel: Int?, humidity: Int?, tempKf: Double?) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.humidity = humidity
        self.tempKf = tempKf
    }
}

// MARK: - Sys
public struct ForecastSys: Codable, Equatable {
    public let pod: Pod?

    enum CodingKeys: String, CodingKey {
        case pod = "pod"
    }

    public init(pod: Pod?) {
        self.pod = pod
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

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }

    public init(id: Int?, main: String?, description: String?, icon: String?) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}

//public enum Description: String, Codable, Equatable {
//    case brokenClouds = "broken clouds"
//    case clearSky = "clear sky"
//    case overcastClouds = "overcast clouds"
//    case scatteredClouds = "scattered clouds"
//}

//public enum Icon: String, Codable, Equatable {
//    case the01D = "01d"
//    case the01N = "01n"
//    case the03D = "03d"
//    case the03N = "03n"
//    case the04D = "04d"
//    case the04N = "04n"
//}

//public enum MainEnum: String, Codable, Equatable {
//    case clear = "Clear"
//    case clouds = "Clouds"
//}

// MARK: - Wind
public struct ForecastWind: Codable, Equatable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
        case gust = "gust"
    }

    public init(speed: Double?, deg: Int?, gust: Double?) {
        self.speed = speed
        self.deg = deg
        self.gust = gust
    }
}
