//
//  MapViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 25.09.2022.
//
import CoreLocation
import UIKit
import MapKit
import SwiftUI

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var actionPin = false

    private let userLocationButtom: UIButton = {
        $0.toAutoLayout()
        $0.setImage(UIImage(systemName: "location"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .blue
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(userButtomTaped), for: .touchUpInside)
        return $0
    }(UIButton())

    private let mapTypeButton: UIButton = {
        $0.toAutoLayout()
        $0.setImage(UIImage(systemName: "map"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .blue
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(changeType), for: .touchUpInside)
        return $0
    }(UIButton())

    private let removeAllPinsButton: UIButton = {
        $0.toAutoLayout()
        $0.setImage(UIImage(systemName: "trash.circle.fill"), for: .normal)
        $0.backgroundColor = .white
        $0.contentVerticalAlignment = .fill
        $0.contentHorizontalAlignment = .fill
        $0.tintColor = .red
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(removeAllPins), for: .touchUpInside)
        return $0
    }(UIButton())

    lazy var mapKitView: MKMapView = {
        $0.mapType = .hybrid
        $0.showsCompass = true
        $0.delegate = self
        $0.toAutoLayout()
        return $0
    }(MKMapView())

    deinit {
        locationManager.stopUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        checkLocationAutorization()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        layout()
        locationManager.delegate = self
    }

    private func addGesture() {
        let mapGesture = UILongPressGestureRecognizer(target: self, action: #selector(newPin(LongGesture:)))
        mapGesture.delegate = self
        mapKitView.addGestureRecognizer(mapGesture)
    }
    @objc private func newPin(LongGesture: UIGestureRecognizer) {

        if LongGesture.state == UIGestureRecognizer.State.began {
            let touchPoint: CGPoint = LongGesture.location(in: mapKitView)
            let newCoordinate: CLLocationCoordinate2D = mapKitView.convert(touchPoint, toCoordinateFrom: mapKitView)
            addNewPin(pointedCoordinate: newCoordinate)
        }
    }

    private  func addNewPin(pointedCoordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "Add pin".localized, message: "Enter the title".localized, preferredStyle: .alert)
        alert.addTextField()
        let deleteAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {_ in })
        alert.addAction(deleteAction)
        let ok = UIAlertAction(title: "Ok".localized, style: .default, handler: {_ in
            var name = alert.textFields![0].text!
            if name == "" {
                name = String(self.mapKitView.annotations.count)
            }
            self.displayBranchLocation(location: pointedCoordinate, name: name)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    private func layout() {
        view.addSubviews(mapKitView, userLocationButtom,  mapTypeButton, removeAllPinsButton) //addPinButtom,
        NSLayoutConstraint.activate([
            mapKitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapKitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            userLocationButtom.widthAnchor.constraint(equalToConstant: 50),
            userLocationButtom.heightAnchor.constraint(equalToConstant: 50),
            userLocationButtom.trailingAnchor.constraint(equalTo: mapKitView.trailingAnchor, constant: -16),
            userLocationButtom.bottomAnchor.constraint(equalTo: mapKitView.bottomAnchor, constant: -50)
        ])

        NSLayoutConstraint.activate([
            mapTypeButton.widthAnchor.constraint(equalToConstant: 50),
            mapTypeButton.heightAnchor.constraint(equalToConstant: 50),
            mapTypeButton.leadingAnchor.constraint(equalTo: mapKitView.leadingAnchor, constant: 16),
            mapTypeButton.topAnchor.constraint(equalTo: mapKitView.topAnchor, constant: 50)
        ])

        NSLayoutConstraint.activate([
            removeAllPinsButton.widthAnchor.constraint(equalToConstant: 50),
            removeAllPinsButton.heightAnchor.constraint(equalToConstant: 50),
            removeAllPinsButton.leadingAnchor.constraint(equalTo: mapKitView.leadingAnchor, constant: 16),
            removeAllPinsButton.bottomAnchor.constraint(equalTo: mapKitView.bottomAnchor, constant: -50)
        ])
    }

    @objc private  func userButtomTaped () {
        guard let location = location else {
            return
        }
        centrAndZoomInMapToLocation(location.coordinate)
    }

    @objc private  func changeType () {
        switch mapKitView.mapType {
        case .hybrid:
            self.mapKitView.mapType = .satellite
        case .satellite:
            self.mapKitView.mapType = .standard
        case .standard:
            self.mapKitView.mapType = .hybrid
        @unknown default:
            fatalError()
        }
    }

    @objc private  func removeAllPins () {
        let alert = UIAlertController(title: "RemoveAllPins".localized, message: "DeletePinMassege".localized, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {_ in })
        alert.addAction(deleteAction)
        let ok = UIAlertAction(title: "Ok".localized, style: .destructive, handler: {_ in
            self.mapKitView.removeAnnotations(self.mapKitView.annotations)
            self.mapKitView.overlays.forEach {self.mapKitView.removeOverlay($0)}
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    private func displayBranchLocation (location: CLLocationCoordinate2D, name: String ) {
        let pin = MKPointAnnotation(__coordinate: location, title: name, subtitle: nil)
        mapKitView.addAnnotation(pin)
        centrAndZoomInMapToLocation(location)
    }

    private func showNavigationRouteToBrinch(withLocation location: CLLocationCoordinate2D) {
        mapKitView.overlays.forEach {mapKitView.removeOverlay($0)}
        let directionRequest = MKDirections.Request()
        let soursePlacemark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 49, longitude: 49))
        let sourseMapItem = MKMapItem(placemark: soursePlacemark)
        let destinationPlacemark = MKPlacemark(coordinate: location)
        let destinationSourseMapItem = MKMapItem(placemark: destinationPlacemark)
        directionRequest.source = sourseMapItem
        directionRequest.destination = destinationSourseMapItem
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            if error != nil {
                print("ERROR 1")
            }
            guard let response = response, let route = response.routes.first else {
                print("ERROR 2")
                return}
            self.mapKitView.addOverlay(route.polyline, level: .aboveRoads)
            let routeRect = route.polyline.boundingMapRect
            self.mapKitView.setRegion(MKCoordinateRegion(routeRect), animated: true)

        }
    }

    private func checkLocationAutorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            mapKitView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Error".localized, message: "NoAccessAclocationMaassege".localized, preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {_ in })
            alert.addAction(deleteAction)
            let ok = UIAlertAction(title: "Settings".localized, style: .destructive) {_ in
                if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            break
        case .authorizedAlways:
            break
        @unknown default:
            assertionFailure("Not supported mode")
            break
        }
    }
    private func centrAndZoomInMapToLocation (_ location: CLLocationCoordinate2D) {
        mapKitView.setCenter(location, animated: true)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapKitView.setRegion(region, animated: true)
        mapKitView.showsUserLocation = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        centrAndZoomInMapToLocation(location.coordinate)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .cyan
        render.lineWidth = 2
        return render
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let marker: MKMarkerAnnotationView = {
                let getDirectionsButtom: UIButton = {
                    $0.setImage(UIImage(systemName: "location.north.line.fill"), for: .normal)
                    $0.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    $0.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
                    return $0
                }(UIButton())

                let deletePinButtom: UIButton = {
                    $0.setImage(UIImage(systemName: "trash"), for: .normal)
                    $0.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                    $0.addTarget(self, action: #selector(deletePin), for: .touchUpInside)
                    return $0
                }(UIButton())
                $0.annotation = annotation
                $0.canShowCallout = true
                $0.calloutOffset = CGPoint(x: 0, y: 6)
                $0.rightCalloutAccessoryView = getDirectionsButtom
                $0.leftCalloutAccessoryView = deletePinButtom
                return $0
            }(MKMarkerAnnotationView())
            return marker
        }
        return nil
    }

    @objc private  func getDirections() {
        self.actionPin = false
    }

    @objc private  func deletePin () {
        self.actionPin = true
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        if actionPin {
            mapKitView.removeAnnotation(annotation)
            mapKitView.overlays.forEach {mapKitView.removeOverlay($0)}
        } else {
            showNavigationRouteToBrinch(withLocation: annotation.coordinate)
        }
    }
}
