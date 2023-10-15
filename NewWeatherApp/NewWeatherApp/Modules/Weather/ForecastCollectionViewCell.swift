//
//  ForecastCollectionViewCell.swift
//  NewWeatherApp
//
//  Created by Kate on 11.10.2023.
//

import UIKit
import SwiftBoost

final class ForecastCollectionViewCell: UICollectionViewCell {
    // MARK: - Props

    struct Props {
        let date: String
        let temperature: String
        let weather: String
    }

    // MARK: - Views

    private lazy var dateLabel = UILabel().do {
        $0.textColor = UIColor(named: "pink")
        $0.font = UIFont(name: "Optima Bold", size: Constants.font18)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private lazy var temperatureLabel = UILabel().do {
        $0.textColor = .darkGray
        $0.font = UIFont(name: "Optima Bold", size: Constants.font18)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private lazy var weatherLabel = UILabel().do {
        $0.textColor = .darkGray
        $0.font = UIFont(name: "Optima Regular", size: Constants.font15)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private lazy var weatherStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = Constants.offset4
        $0.addArrangedSubview(dateLabel)
        $0.addArrangedSubview(temperatureLabel)
        $0.addArrangedSubview(weatherLabel)
    }

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension ForecastCollectionViewCell {
    func updateViews(_ info: Props) {
        dateLabel.text = info.date
        temperatureLabel.text = info.temperature
        weatherLabel.text = info.weather
    }
}

// MARK: - Private Methods

private extension ForecastCollectionViewCell {
    func configure() {

        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        contentView.addSubviews(
            weatherStack
        )
    }

    func setupConstraints() {
        weatherStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Constants

private extension ForecastCollectionViewCell {
    enum Constants {
        static let cornerRadius: CGFloat = 8

        static let font18: CGFloat = 18
        static let font15: CGFloat = 15
        static let offset4: CGFloat = 4
    }
}
