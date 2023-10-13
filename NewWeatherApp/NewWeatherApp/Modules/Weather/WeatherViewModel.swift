//
//  WeatherViewModel.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import UIKit
import RxSwift
import RxRelay

final class WeatherViewModel {
    //MARK: Props

    let apiService: ApiService
    let disposeBag = DisposeBag()

    let weatherPublishRelay = PublishRelay<WeatherResponce>()
    let forecastPublishRelay = PublishRelay<ForecastResponce>()

    //MARK: Init

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    //MARK: Methods

    func loadWeatherData(cityName: String) {
        apiService.sendWeatherRequest(cityName: cityName, requestType: .GET) { [weak self] responce in
            switch responce {
            case .success(let answer):
                self?.weatherPublishRelay.accept(answer)
            case .failure(let error):
                print(error)
            }
        }

        apiService.sendForecastRequest(cityName: cityName, requestType: .GET) { [weak self] responce in
            switch responce {
            case .success(let answer):
                self?.forecastPublishRelay.accept(answer)
            case .failure(let error):
                print(error)
            }
        }
    }
}

