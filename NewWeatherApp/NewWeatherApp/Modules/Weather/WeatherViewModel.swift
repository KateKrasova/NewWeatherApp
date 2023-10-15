//
//  WeatherViewModel.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import UIKit
import RxSwift
import RxRelay

protocol IWeatherViewModel {
    var weatherObservable: Observable<WeatherResponce> { get }
    var forecastObservable: Observable<ForecastResponce> { get }
    func loadWeatherData(requestParams: WeatherRequestParams)
}

final class WeatherViewModel {

    //MARK: - Props

    private let apiService: IApiService

    private let weatherPublishRelay = PublishRelay<WeatherResponce>()
    private let forecastPublishRelay = PublishRelay<ForecastResponce>()

    //MARK: - Init

    init(apiService: IApiService) {
        self.apiService = apiService
    }
}

//MARK: - IWeatherViewModel

extension WeatherViewModel: IWeatherViewModel {
    var weatherObservable: Observable<WeatherResponce> {
        weatherPublishRelay.asObservable()
    }

    var forecastObservable: Observable<ForecastResponce> {
        forecastPublishRelay.asObservable()
    }

    func loadWeatherData(requestParams: WeatherRequestParams) {
        apiService.sendWeatherRequest(requestParams: requestParams, requestType: .GET) { [weak self] responce in
            switch responce {
            case .success(let answer):
                self?.weatherPublishRelay.accept(answer)
                UserDefaultsService.lastCity = answer.name ?? ""
            case .failure(let error):
                print(error)
            }
        }

        apiService.sendForecastRequest( requestParams: requestParams, requestType: .GET) { [weak self] responce in
            switch responce {
            case .success(let answer):
                self?.forecastPublishRelay.accept(answer)
            case .failure(let error):
                print(error)
            }
        }
    }
}
