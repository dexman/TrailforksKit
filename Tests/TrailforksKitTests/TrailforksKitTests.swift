import XCTest
@testable import TrailforksKit

final class TrailforksKitTests: XCTestCase {

    func testRegionsRequestSuccess() throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/regions")),
            fixtureNamed: "regions_detailed.json")

        let request = RegionsRequest.make(parameters: [])
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)
        let result = trailforksService.test_synchronouslySend(request: request, in: self)

        XCTAssertEqual(try result.get().count, 92)
    }

    func testRegionsRequestFailure() throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/regions")),
            statusCode: 401,
            fixtureNamed: "regions_error.json")

        let request = RegionsRequest.make(parameters: [])
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)
        let result = trailforksService.test_synchronouslySend(request: request, in: self)

        XCTAssertThrowsError(try result.get()) {
            if let error = $0 as? TrailforksServiceError {
                XCTAssertEqual(error.message, "Your API access is region restricted, no valid RID specified!")
            } else {
                XCTFail("Expected an \(TrailforksServiceError.self)")
            }
        }
    }

    func testReportSuccess() throws {
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
        let result = trailforksService.test_synchronouslySend(
            request: request,
            token: Token(
                tokenPublic: "testtoken",
                tokenSecret: "testsecret",
                userId: "testuser",
                username: "testusername",
                expiresOn: Date(timeIntervalSince1970: 777)
            ),
            in: self
        )
        NSLog(try result.get().description)
    }

    func testTokenRequestSuccess() throws {
        let networkClient = NetworkClientForTests()
        try networkClient.expect(
            url: XCTUnwrap(URL(string: "https://www.trailforks.com/api/1/token?code=testcode")),
            fixtureNamed: "token.json")

        let request = TokenRequest.make(code: "testcode")
        let trailforksService = TrailforksService(
            networkClient: networkClient,
            appCredential: nil)
        let result = trailforksService.test_synchronouslySend(request: request, in: self)
        let token = try result.get()

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

extension TrailforksService {

    @discardableResult
    public func test_synchronouslySend<R>(
        request: TrailforksServiceRequest<R>,
        token: Token? = nil,
        in testCase: XCTestCase
    ) -> Result<R, Error> {
        var asyncResult: Result<R, Error>?
        let exc = testCase.expectation(description: "asyncResult")
        send(request: request, token: token) { (result: Result<R, Error>) in
            asyncResult = result
            exc.fulfill()
        }
        testCase.wait(for: [exc], timeout: 10.0)
        return asyncResult!
    }
}
