//
//  WeatherViewController.swift
//  NewWeatherApp
//
//  Created by Kate on 10.10.2023.
//

import UIKit
import SnapKit
import SwiftBoost

final class WeatherViewController: UIViewController {
    //MARK: - Views

    private lazy var searchBar = UISearchBar().do {
        $0.placeholder = "Search location"
        $0.searchBarStyle = .minimal
    }

    private lazy var cityNameLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: 32)
        $0.textColor = UIColor(named: "pink")
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "Moscow"
    }
    
    private lazy var temperatureLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: 35)
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.text = "3°"
    }

    private lazy var weatherLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Regular", size: 20)
        $0.textColor = .darkGray
        $0.textAlignment = .center
        $0.text = "Rain"
    }

    private lazy var topView = UIView().do {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.addSubview(weatherInfoStack)
    }

    private lazy var weatherInfoStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
        $0.addArrangedSubview(cityNameLabel)
        $0.addArrangedSubview(temperatureLabel)
        $0.addArrangedSubview(weatherLabel)
    }

    private lazy var windSpeedLabel = makeWeatherStateLabel("Wind speed")
    private lazy var windSpeedNumberLabel = makeWeatherStateNumberLabel()
    private lazy var windSpeedStack = makeWeatherStateStack(windSpeedLabel, windSpeedNumberLabel)

    private lazy var visabilityLabel = makeWeatherStateLabel("Visability")
    private lazy var visabilityNumberLabel = makeWeatherStateNumberLabel()
    private lazy var visabilityStack = makeWeatherStateStack(visabilityLabel, visabilityNumberLabel)

    private lazy var humidityLabel = makeWeatherStateLabel("Humidity")
    private lazy var humidityNumberLabel = makeWeatherStateNumberLabel()
    private lazy var humidityStack = makeWeatherStateStack(humidityLabel, humidityNumberLabel)

    private lazy var airLabel = makeWeatherStateLabel("Air")
    private lazy var airNumberLabel = makeWeatherStateNumberLabel()
    private lazy var airStack = makeWeatherStateStack(airLabel, airNumberLabel)

    private lazy var leftWeatherStateStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.addArrangedSubview(windSpeedStack)
        $0.addArrangedSubview(humidityStack)
    }

    private lazy var rightWeatherStateStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.addArrangedSubview(visabilityStack)
        $0.addArrangedSubview(airStack)
    }

    private lazy var forecastLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: 32)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.text = "Forecast"
    }

    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().do {
            $0.scrollDirection = .horizontal
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).do {
            $0.register(ForecastCollectionViewCell.self)
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
        }

        return collectionView
    }()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        makeConstraints()
    }
}

//MARK: - Private methods

private extension WeatherViewController {
    func configure() {
        view.backgroundColor = UIColor(named: "background")

        view.addSubviews(
            searchBar,
            topView,
            leftWeatherStateStack,
            rightWeatherStateStack,
            forecastLabel,
            forecastCollectionView
        )
    }

    func makeConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.offset16)
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
        }

        topView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(Constants.offset16)
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
        }

        weatherInfoStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.offset16)
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
        }

        cityNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        leftWeatherStateStack.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Constants.offset16)
            $0.centerX.equalToSuperview().offset(-70)
        }

        rightWeatherStateStack.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Constants.offset16)
            $0.centerX.equalToSuperview().offset(70)
        }

        forecastLabel.snp.makeConstraints {
            $0.top.equalTo(leftWeatherStateStack.snp.bottom).offset(Constants.offset32)
            $0.leading.equalToSuperview().inset(Constants.offset16)
        }

        forecastCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
            $0.top.equalTo(forecastLabel.snp.bottom).offset(Constants.offset8)
            $0.height.equalTo(90)
        }

    }

    func makeWeatherStateLabel(_ labelText: String) -> UILabel {
        lazy var label = UILabel().do {
            $0.font = UIFont(name: "Optima Bold", size: Constants.fontSize16)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = labelText
        }

        return label
    }

    func makeWeatherStateNumberLabel() -> UILabel {
        lazy var label = UILabel().do {
            $0.font = UIFont(name: "Optima Regular", size: Constants.fontSize13)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = "n/n"
        }

        return label
    }

    func makeWeatherStateStack(_ nameLabel: UILabel, _ numberLabel: UILabel) -> UIStackView {
        lazy var stack = UIStackView().do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .center
            $0.addArrangedSubview(nameLabel)
            $0.addArrangedSubview(numberLabel)
        }

        return stack
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: ForecastCollectionViewCell.self, for: indexPath)


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.frame.height)
    }
}

// MARK: - Constants

private extension WeatherViewController {
    enum Constants {
        static let offset8: CGFloat = 8
        static let offset16: CGFloat = 16
        static let offset32: CGFloat = 32

        static let fontSize13: CGFloat = 13
        static let fontSize16: CGFloat = 16
    }
}

