//
//  Region.swift
//  TrailforksKit
//
//  Created by Arthur Dexter on 7/16/20.
//

import Foundation

// PB code
// https://www.pinkbike.com/u/bentomas/blog/pinkbike-blog-code.html

public struct Region: Decodable {

    public let rid: String? // "rid": "35629"
    public let alias: String? // "alias": "arbor-hills-nature-preserve"
    public let title: String? // "title": "Arbor Hills Nature Preserve Off Road Bike Trail"
    public let description: String? // "description": "[B]Trail Steward:…"
    public let searchTerms: String? // "search_terms": "DORBA Trails"
    public let isRidingArea: Bool? // "isridingarea": "0"

    public let latitude: Double? // "latitude": "33.046090"
    public let longitude: Double? // "longitude": "-96.849163"
    public let countryTitle: String? // "country_title": "United States"
    public let provinceTitle: String? // "prov_title": "Texas"
    public let cityTitle: String? // "city_title": "Plano"

    public let condition: Condition? // condition": "0"
    public let status: Status? // "status": "1"
    public let statusTimestamp: Date? // "status_ts": "1594560530"

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        rid = try container.decodeIfPresent(String.self, forKey: .rid)
        alias = try container.decodeIfPresent(String.self, forKey: .alias)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        searchTerms = try container.decodeIfPresent(String.self, forKey: .searchTerms)
        isRidingArea = try container.decodeIfPresent(String.self, forKey: .isRidingArea) == "1"

        latitude = try container.decodeFromStringIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeFromStringIfPresent(Double.self, forKey: .longitude)
        countryTitle = try container.decodeIfPresent(String.self, forKey: .countryTitle)
        provinceTitle = try container.decodeIfPresent(String.self, forKey: .provinceTitle)
        cityTitle = try container.decodeIfPresent(String.self, forKey: .cityTitle)

        condition = try container.decodeIfPresent(Condition.self, forKey: .condition)
        status = try container.decodeIfPresent(Status.self, forKey: .status)

        let statusTimestampValue = try container.decodeFromStringIfPresent(
            TimeInterval.self,
            forKey: .statusTimestamp)
        statusTimestamp = statusTimestampValue.map(Date.init(timeIntervalSince1970:))
    }

    private enum CodingKeys: String, CodingKey {
        case alias
        case cityTitle = "city_title"
        case condition
        case countryTitle = "country_title"
        case description
        case isRidingArea = "isridingarea"
        case latitude
        case longitude
        case provinceTitle = "prov_title"
        case searchTerms = "search_terms"
        case status
        case statusTimestamp = "status_ts"
        case title
        case rid
    }
}
