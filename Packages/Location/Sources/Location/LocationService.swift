//
//  LocationService.swift
//  Location
//
//  Created by Sherif Kamal on 02/12/2025.
//

import Foundation
import CoreLocation

public protocol LocationServiceProtocol: Sendable {
    func getCurrentCountryCode() async throws -> String
}

public let defaultCountryCode = "EG" // Egypt

public final class LocationService: NSObject, LocationServiceProtocol, @unchecked Sendable {
    
    private let locationManager: CLLocationManager
    private let geocoder: CLGeocoder
    
    private var authorizationContinuation: CheckedContinuation<CLAuthorizationStatus, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    public override init() {
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        super.init()
    }
    
    public func getCurrentCountryCode() async throws -> String {
        try await self.getCurrentCountryCodeInternal()
    }
    
    @MainActor
    private func getCurrentCountryCodeInternal() async throws -> String {
        if locationManager.delegate == nil {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        let currentStatus = locationManager.authorizationStatus
        
        let finalStatus: CLAuthorizationStatus
        switch currentStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            finalStatus = currentStatus
        case .notDetermined:
            finalStatus = await requestAuthorization()
        case .denied, .restricted:
            return defaultCountryCode
        @unknown default:
            return defaultCountryCode
        }
        
        guard finalStatus == .authorizedWhenInUse || finalStatus == .authorizedAlways else {
            return defaultCountryCode
        }
        
        do {
            let location = try await getCurrentLocation()
            let countryCode = try await reverseGeocode(location)
            return countryCode
        } catch {
            return defaultCountryCode
        }
    }
    
    @MainActor
    private func requestAuthorization() async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            authorizationContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    @MainActor
    private func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    private func reverseGeocode(_ location: CLLocation) async throws -> String {
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        return placemarks.first?.isoCountryCode ?? defaultCountryCode
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: @preconcurrency CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        guard let continuation = authorizationContinuation else { return }
        
        switch status {
        case .notDetermined:
            return
        default:
            authorizationContinuation = nil
            continuation.resume(returning: status)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let continuation = locationContinuation,
              let location = locations.first else { return }
        
        locationContinuation = nil
        continuation.resume(returning: location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}
