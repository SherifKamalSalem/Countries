import Foundation
import Core

@Observable
@MainActor
public final class CountriesViewModel {
    
    public private(set) var savedCountries: [Country] = []
    public private(set) var isLoading = false
    public private(set) var error: Error?
    public var showError = false
    
    private let loadSavedCountriesUseCase: LoadSavedCountriesUseCase
    private let addCountryUseCase: AddCountryUseCase
    private let removeCountryUseCase: RemoveCountryUseCase
    private let getCurrentLocationCountryUseCase: GetCurrentLocationCountryUseCase
    
    public init(
        loadSavedCountriesUseCase: LoadSavedCountriesUseCase,
        addCountryUseCase: AddCountryUseCase,
        removeCountryUseCase: RemoveCountryUseCase,
        getCurrentLocationCountryUseCase: GetCurrentLocationCountryUseCase
    ) {
        self.loadSavedCountriesUseCase = loadSavedCountriesUseCase
        self.addCountryUseCase = addCountryUseCase
        self.removeCountryUseCase = removeCountryUseCase
        self.getCurrentLocationCountryUseCase = getCurrentLocationCountryUseCase
    }
    
    // MARK: - Public Methods
    
    public func loadSavedCountries() async {
        savedCountries = await loadSavedCountriesUseCase.execute()
        
        if savedCountries.isEmpty {
            await addCurrentLocationCountry()
        }
    }
    
    public func addCountry(_ country: Country) async -> Bool {
        let result = await addCountryUseCase.execute(country: country)
        
        switch result {
        case .added, .alreadyExists:
            savedCountries = await loadSavedCountriesUseCase.execute()
            return true
            
        case .limitReached:
            error = CountriesError.limitReached
            showError = true
            return false
        }
    }
    
    public func removeCountry(_ country: Country) async {
        await removeCountryUseCase.execute(countryId: country.id)
        savedCountries = await loadSavedCountriesUseCase.execute()
    }
    
    public func removeCountry(at offsets: IndexSet) {
        Task {
            for index in offsets {
                if let country = savedCountries[safe: index] {
                    await removeCountry(country)
                }
            }
        }
    }
    
    private func addCurrentLocationCountry() async {
        let result = await getCurrentLocationCountryUseCase.execute()
        
        switch result {
        case .success(let country):
            _ = await addCountryUseCase.execute(country: country)
            savedCountries = await loadSavedCountriesUseCase.execute()
            
        case .locationDenied, .countryNotFound, .error:
            #if DEBUG
            debugPrint("Failed to add current location country: \(result)")
            #endif
        }
    }
    
    public func dismissError() {
        showError = false
        error = nil
    }
}
