//
//  WeatherViewController.swift
//  NewWeatherApp
//
//  Created by Kate on 10.10.2023.
//

import UIKit
import SnapKit
import SwiftBoost
import RxSwift
import RxCocoa
import CoreLocation

final class WeatherViewController: UIViewController {
    //MARK: - Props

    private let viewModel: IWeatherViewModel
    private let disposeBag = DisposeBag()

    private lazy var locationManager = CLLocationManager().do {
        $0.delegate = self
    }

    private var cellItems: [ForecastCollectionViewCell.Props] = []

    //MARK: - Views

    private lazy var searchBar = UISearchBar().do {
        $0.placeholder = "Search location"
        $0.searchBarStyle = .minimal
    }

    private lazy var cityNameLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: Constants.fontSize32)
        $0.textColor = UIColor(named: "pink")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var temperatureLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: Constants.fontSize35)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private lazy var weatherLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Regular", size: Constants.fontSize20)
        $0.textColor = .darkGray
        $0.textAlignment = .center
    }

    private lazy var topView = UIView().do {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
        $0.addSubview(weatherInfoStack)
    }

    private lazy var weatherInfoStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = Constants.offset8
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

    private lazy var airLabel = makeWeatherStateLabel("Air Pressure")
    private lazy var airNumberLabel = makeWeatherStateNumberLabel()
    private lazy var airStack = makeWeatherStateStack(airLabel, airNumberLabel)

    private lazy var leftWeatherStateStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = Constants.offset16
        $0.alignment = .center
        $0.addArrangedSubview(windSpeedStack)
        $0.addArrangedSubview(humidityStack)
    }

    private lazy var rightWeatherStateStack = UIStackView().do {
        $0.axis = .vertical
        $0.spacing = Constants.offset16
        $0.alignment = .center
        $0.addArrangedSubview(visabilityStack)
        $0.addArrangedSubview(airStack)
    }

    private lazy var forecastLabel = UILabel().do {
        $0.font = UIFont(name: "Optima Bold", size: Constants.fontSize32)
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

    private lazy var locationButton = UIButton(type: .system).do {
        $0.setImage(UIImage(systemName: "location.fill"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
    }

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        makeConstraints()
        
        if UserDefaultsService.lastCity.isEmpty {
            locationManager.requestAlwaysAuthorization()
        } else {
            viewModel.loadWeatherData(requestParams: .byCityName(cityName: UserDefaultsService.lastCity))
        }

        binding()
    }

    //MARK: - Init

    init(apiService: IApiService) {
        viewModel = WeatherViewModel(apiService: apiService)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            forecastCollectionView,
            locationButton
        )

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touchOnScreen))

        view.addGestureRecognizer(recognizer)
    }

    func binding() {
        viewModel.weatherObservable
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] responce in
                guard let self else {return}

                cityNameLabel.text = responce.name ?? ""
                temperatureLabel.text = "\(String(format: "%.1f", responce.main?.temp ?? 0))°"
                weatherLabel.text = "\(responce.weather?.first?.main ?? "")"
                windSpeedNumberLabel.text = "\(responce.wind?.speed ?? 0)"
                humidityNumberLabel.text = "\(responce.main?.humidity ?? 0)"
                visabilityNumberLabel.text = "\(responce.visibility ?? 0)"
                airNumberLabel.text =  "\(responce.main?.pressure ?? 0)"
            })
            .disposed(by: disposeBag)

        viewModel.forecastObservable
            .observe(on: MainScheduler())
            .subscribe(onNext: {[weak self] result in
                let items = result.list?.map { responce in
                    let date = Date(timeIntervalSince1970: Double(responce.dt ?? -1))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM HH:mm"
                    let formattedDate = dateFormatter.string(from: date)

                    return ForecastCollectionViewCell.Props(
                        date: formattedDate,
                        temperature: " \(String(format: "%.1f", responce.main?.temp ?? 0))°",
                        weather: "\(responce.weather?.first?.main ?? "")"
                    )
                }
                self?.cellItems = items ?? []
                self?.forecastCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

        searchBar.rx.text
            .orEmpty
            .skip(1)
            .filter{ [weak self] in
                guard $0.isEmpty else { return true }
                self?.locationManager.requestLocation()
                return false
            }
            .debounce(.milliseconds(1000), scheduler: MainScheduler())
            .distinctUntilChanged()
            .subscribe {[weak self] text in
                self?.viewModel.loadWeatherData(requestParams: .byCityName(cityName: text))
            }
            .disposed(by: disposeBag)
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
            $0.centerX.equalToSuperview().offset(-Constants.offset70)
        }

        rightWeatherStateStack.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(Constants.offset16)
            $0.centerX.equalToSuperview().offset(Constants.offset70)
        }

        forecastLabel.snp.makeConstraints {
            $0.top.equalTo(leftWeatherStateStack.snp.bottom).offset(Constants.offset32)
            $0.leading.equalToSuperview().inset(Constants.offset16)
        }

        forecastCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset16)
            $0.top.equalTo(forecastLabel.snp.bottom).offset(Constants.offset8)
            $0.height.equalTo(Constants.collectionHeight)
        }

        locationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.trailing.equalToSuperview().inset(Constants.offset16)
        }
    }

    func makeWeatherStateLabel(_ labelText: String) -> UILabel {
         let label = UILabel().do {
            $0.font = UIFont(name: "Optima Bold", size: Constants.fontSize16)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = labelText
        }

        return label
    }

    func makeWeatherStateNumberLabel() -> UILabel {
         let label = UILabel().do {
            $0.font = UIFont(name: "Optima Regular", size: Constants.fontSize13)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.text = "n/n"
        }

        return label
    }

    func makeWeatherStateStack(_ nameLabel: UILabel, _ numberLabel: UILabel) -> UIStackView {
         let stack = UIStackView().do {
            $0.axis = .vertical
            $0.spacing = Constants.offset4
            $0.alignment = .center
            $0.addArrangedSubview(nameLabel)
            $0.addArrangedSubview(numberLabel)
        }

        return stack
    }

    @objc
    func locationTapped() {
        locationManager.requestLocation()
    }

    @objc
    func touchOnScreen() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cellItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: ForecastCollectionViewCell.self, for: indexPath).do {
            $0.updateViews(item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.collectionCellWidth, height: collectionView.frame.height)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {

        case .notDetermined:
            print("When user did not yet determined")
        case .denied:
            print("When user select option Dont't Allow")
        default:
            print("default")
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        viewModel.loadWeatherData(requestParams: .byCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}

// MARK: - Constants

private extension WeatherViewController {
    enum Constants {
        static let offset8: CGFloat = 8
        static let offset4: CGFloat = 4
        static let offset16: CGFloat = 16
        static let offset32: CGFloat = 32
        static let offset70: CGFloat = 70

        static let fontSize13: CGFloat = 13
        static let fontSize16: CGFloat = 16
        static let fontSize20: CGFloat = 20
        static let fontSize32: CGFloat = 32
        static let fontSize35: CGFloat = 35

        static let cornerRadius: CGFloat = 12

        static let collectionHeight: CGFloat = 90
        static let collectionCellWidth: CGFloat = 120
    }
}

