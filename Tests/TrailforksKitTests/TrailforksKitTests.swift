import Combine
import CoreLocation
import XCTest
@testable import TrailforksKit

final class TrailforksKitTests: XCTestCase {

    func testRegionsRequestSuccess() async throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/regions")),
            fixtureNamed: "regions_detailed.json")

        let request = RegionsRequest.make(parameters: [])
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)
        let result = try await trailforksService.send(request: request)

        XCTAssertEqual(result.count, 92)
    }

    func testRegionsRequestFailure() async throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/regions")),
            statusCode: 401,
            fixtureNamed: "regions_error.json")

        let request = RegionsRequest.make(parameters: [])
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)

        do {
            _ = try await trailforksService.send(request: request)
            XCTFail("Expected an \(TrailforksServiceError.self)")
        } catch {
            if let error = error as? TrailforksServiceError {
                XCTAssertEqual(error.message, "Your API access is region restricted, no valid RID specified!")
            } else {
                XCTFail("Expected an \(TrailforksServiceError.self)")
            }
        }
    }

    func testReportSuccess() async throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            method: "POST",
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/report")),
            fixtureNamed: "report.json")

        let request = ReportRequest.make(
            userId: "testuser",
            trailId: "15720",
            status: .minorIssue,
            condition: .prevalentMud,
            description: "MuddyMudBud",
            marker: CLLocationCoordinate2D(latitude: 1, longitude: 2)
        )
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil
        )
        let result = try await trailforksService.send(
            request: request,
            token: Token(
                tokenPublic: "testtoken",
                tokenSecret: "testsecret",
                userId: "testuser",
                username: "testusername",
                expiresOn: Date(timeIntervalSince1970: 777)
            )
        )
        NSLog(result.description)
    }

    func testTokenRequestSuccess() async throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/token?code=testcode")),
            fixtureNamed: "token.json")

        let request = TokenRequest.make(code: "testcode")
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)
        let token = try await trailforksService.send(request: request)

        XCTAssertEqual(
            token,
            Token(
                tokenPublic: "testtoken",
                tokenSecret: "testsecret",
                userId: "777",
                username: "luckyrider",
                expiresOn: Date(timeIntervalSince1970: 3243971896)
            )
        )
    }

    static var allTests = [
        ("testRegionsRequestSuccess", testRegionsRequestSuccess),
        ("testRegionsRequestFailure", testRegionsRequestFailure),
        ("testTokenRequestSuccess", testTokenRequestSuccess),
        ("testReportSuccess", testReportSuccess),
    ]
}
