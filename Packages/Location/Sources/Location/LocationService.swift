//
//  LocationServiceProtocol.swift
//  Location
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import CoreLocation
import Combine

public protocol LocationServiceProtocol: Sendable {
    func requestAuthorization() async -> Bool
    func getCurrentCountryCode() async throws -> String
}

public let defaultCountryCode = "EG" // Egypt

public final class LocationService: NSObject, LocationServiceProtocol, @unchecked Sendable {
    
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder
    
    private var authorizationContinuation: CheckedContinuation<Bool, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    public override init() {
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // We just need country
    }
    
    public func requestAuthorization() async -> Bool {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .denied, .restricted:
            return false
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                self.authorizationContinuation = continuation
                locationManager.requestWhenInUseAuthorization()
            }
        @unknown default:
            return false
        }
    }
    
    public func getCurrentCountryCode() async throws -> String {
        let authorized = await requestAuthorization()
        
        guard authorized else {
            return defaultCountryCode
        }
        
        let location = try await getCurrentLocation()
        return try await reverseGeocode(location)
    }
    
    private func getCurrentLocation() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    private func reverseGeocode(_ location: CLLocation) async throws -> String {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let countryCode = placemarks.first?.isoCountryCode else {
            return defaultCountryCode
        }
        
        return countryCode
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let continuation = authorizationContinuation else { return }
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            continuation.resume(returning: true)
        case .denied, .restricted:
            continuation.resume(returning: false)
        case .notDetermined:
            return
        @unknown default:
            continuation.resume(returning: false)
        }
        
        authorizationContinuation = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}

