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

enum CustomError: Error {
    case badStatusCode
}

enum WeatherRequestParams {
    case byCityName(cityName: String)
    case byCoordinates(lat: Double, lon: Double)
}

protocol IApiService {
   func sendWeatherRequest(
    requestParams: WeatherRequestParams,
    requestType: RequestType,
    completion: @escaping (Result<WeatherResponce, Error>) -> Void
   )

    func sendForecastRequest(
        requestParams: WeatherRequestParams,
        requestType: RequestType,
        completion: @escaping (Result<ForecastResponce, Error>) -> Void
    )
}

struct ApiService: IApiService {

    private let baseURL = "https://api.openweathermap.org"
    private let apiKey = "ba4f434450c83f44645470b61ee14800"

    func sendWeatherRequest(requestParams: WeatherRequestParams, requestType: RequestType, completion: @escaping (Result<WeatherResponce, Error>) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/data/2.5/weather")

        switch requestParams {
        case .byCityName(let cityName):
            urlComponents?.queryItems = [
                .init(name: "q", value: "\(cityName)"),
                .init(name: "appid", value: apiKey),
                .init(name: "units", value: "metric")
            ]
        case let .byCoordinates(lat, lon):
            urlComponents?.queryItems = [
                .init(name: "lat", value: "\(lat)"),
                .init(name: "lon", value: "\(lon)"),
                .init(name: "appid", value: apiKey),
                .init(name: "units", value: "metric")
            ]
        }

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let response, let castedResponse = response as? HTTPURLResponse, !(200..<300).contains(castedResponse.statusCode) {
                completion(.failure(CustomError.badStatusCode))
                return
            }
            
            if let data {
                do {
                    let response = try JSONDecoder().decode(WeatherResponce.self, from: data)
                    completion(.success(response))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }

    func sendForecastRequest(requestParams: WeatherRequestParams, requestType: RequestType, completion: @escaping (Result<ForecastResponce, Error>) -> Void) {
        var urlComponents = URLComponents(string: "\(baseURL)/data/2.5/forecast")

        switch requestParams {
        case .byCityName(let cityName):
            urlComponents?.queryItems = [
                .init(name: "q", value: "\(cityName)"),
                .init(name: "appid", value: apiKey),
                .init(name: "units", value: "metric")
            ]
        case let .byCoordinates(lat, lon):
            urlComponents?.queryItems = [
                .init(name: "lat", value: "\(lat)"),
                .init(name: "lon", value: "\(lon)"),
                .init(name: "appid", value: apiKey),
                .init(name: "units", value: "metric")
            ]
        }

        guard let url = urlComponents?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        let task = URLSession.shared.dataTask (with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let response, let castedResponse = response as? HTTPURLResponse, !(200..<300).contains(castedResponse.statusCode) {
                completion(.failure(CustomError.badStatusCode))
                return
            }

            if let data {
                do {
                    let response = try JSONDecoder().decode(ForecastResponce.self, from: data)
                    completion(.success(response))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
