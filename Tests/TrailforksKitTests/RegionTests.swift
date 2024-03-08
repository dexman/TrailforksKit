@testable import TrailforksKit
import XCTest

final class RegionTests: XCTestCase {
    func testDecoding() throws {
        let region = try decodeRegion(from: Self.regionJsonObject)
        XCTAssertEqual(region.rid, "5024")
        XCTAssertEqual(region.title, "Arbor Hills Nature Preserve")
        XCTAssertEqual(region.alias, "arbor-hills-nature-preserve")
        XCTAssertEqual(region.searchTerms, "DORBA")
        XCTAssertEqual(region.status, .clear)
        XCTAssertEqual(region.statusTimestamp, Date(timeIntervalSince1970: 1587514373))
        XCTAssertEqual(region.condition, .unknown)
        XCTAssertEqual(region.description, "[B]Trail Steward: Steven Jasewicz[/B]\r\n\r\nLocated on the western border of Plano…")
        XCTAssertEqual(region.countryTitle, "United States")
        XCTAssertEqual(region.provinceTitle, "Texas")
        XCTAssertEqual(region.cityTitle, "Plano")
        XCTAssertEqual(region.latitude, 33.047603)
        XCTAssertEqual(region.longitude, -96.851867)
    }

    func testDecodingRidString() throws {
        var regionJsonObject = Self.regionJsonObject
        regionJsonObject["rid"] = "5024"
        let region = try decodeRegion(from: regionJsonObject)
        XCTAssert(regionJsonObject["rid"] is String)
        XCTAssertEqual(region.rid, "5024")
    }

    func testDecodingRidNumber() throws {
        let region = try decodeRegion(from: Self.regionJsonObject)
        XCTAssert(Self.regionJsonObject["rid"] is Int)
        XCTAssertEqual(region.rid, "5024")
    }

    private static let regionJsonObject: [String: Any] = [
        "rid": 5024,
        "title": "Arbor Hills Nature Preserve",
        "alias": "arbor-hills-nature-preserve",
        "search_terms": "DORBA",
        "status": "1",
        "status_ts": "1587514373",
        "condition": "0",
        "description": "[B]Trail Steward: Steven Jasewicz[/B]\r\n\r\nLocated on the western border of Plano…",
        "country_title": "United States",
        "prov_title": "Texas",
        "city_title": "Plano",
        "latitude": "33.047603",
        "longitude": "-96.851867"
    ]

    private func decodeRegion(from jsonObject: [String: Any]) throws -> Region {
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
        let decoder = JSONDecoder()
        return try decoder.decode(Region.self, from: jsonData)
    }
}
