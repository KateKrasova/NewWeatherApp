//
//  ApiService.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import Foundation

enum RequestType: String {
    case GET
    case POST
}

struct ApiService {
    static let shared = ApiService()

    private init() {}

    let baseURL = "https://api.openweathermap.org"
    let apiKey = "ba4f434450c83f44645470b61ee14800"

    func parse(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [Any] {
            print (json)
        }
    }

    func sendWeatherRequest(cityName: String, endpoint: String, requestType: RequestType, parser: @escaping (Data) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/data/2.5/weather")

        urlComponents?.queryItems = [
            .init(name: "q", value: "\(cityName)"),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            guard error == nil else { return }
            if let data {
                parse(data: data)
            }
        }
        task.resume()
    }

    func sendForecastRequest(cityName: String, requestType: RequestType, parser: @escaping (Data) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/data/2.5/forecast")

        urlComponents?.queryItems = [
            .init(name: "q", value: "\(cityName)"),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric")
        ]

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            guard error == nil else { return }
            if let data {
                parse(data: data)
            }
        }
        task.resume()
    }

}
