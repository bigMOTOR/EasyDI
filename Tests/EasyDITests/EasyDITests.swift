import XCTest
@testable import EasyDI

final class EasyDITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EasyDI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
