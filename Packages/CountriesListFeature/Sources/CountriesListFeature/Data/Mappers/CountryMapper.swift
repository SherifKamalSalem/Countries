//
//  CountryMapper.swift
//  CountriesListFeature
//
//  Created by Sherif Kamal on 02/12/2025.
//


import Foundation
import Core
import Networking

enum CountryMapper {
    
    static func map(_ dto: CountryDTO) -> Country {
        Country(
            id: dto.name,
            name: dto.name,
            capital: dto.capital,
            flagURL: URL(string: dto.flags.png),
            currencies: dto.currencies?.compactMap { currency in
                guard let code = currency.code,
                      let name = currency.name else { return nil }
                return Country.Currency(
                    code: code,
                    name: name,
                    symbol: currency.symbol ?? ""
                )
            } ?? []
        )
    }
    
    static func mapDetail(_ dto: CountryDetailDTO) -> Country {
        Country(
            id: dto.alpha2Code,
            name: dto.name,
            capital: dto.capital,
            flagURL: URL(string: dto.flags.png),
            currencies: dto.currencies?.compactMap { currency in
                guard let code = currency.code,
                      let name = currency.name else { return nil }
                return Country.Currency(
                    code: code,
                    name: name,
                    symbol: currency.symbol ?? ""
                )
            } ?? []
        )
    }
    
    static func mapToDetail(_ dto: CountryDetailDTO) -> CountryDetail {
        CountryDetail(
            id: dto.alpha2Code,
            name: dto.name,
            nativeName: dto.nativeName,
            capital: dto.capital,
            region: dto.region,
            subregion: dto.subregion,
            population: dto.population,
            area: dto.area,
            flagURL: URL(string: dto.flags.png),
            currencies: dto.currencies?.compactMap { currency in
                guard let code = currency.code,
                      let name = currency.name else { return nil }
                return CountryDetail.Currency(
                    code: code,
                    name: name,
                    symbol: currency.symbol ?? ""
                )
            } ?? [],
            languages: dto.languages?.compactMap { language in
                guard let name = language.name else { return nil }
                return CountryDetail.Language(
                    name: name,
                    nativeName: language.nativeName
                )
            } ?? [],
            borders: dto.borders ?? [],
            timezones: dto.timezones ?? []
        )
    }
}

