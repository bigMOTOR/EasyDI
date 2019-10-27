import XCTest
@testable import EasyDI

private let _helloWorld = "Hello, World!"

final class EasyDITests: XCTestCase {
  private var container: Container!

  override func setUp() {
    super.setUp()
    container = Container()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testRegisterAndResolveObject() {
    container.register(factory: { TestClass() })
    container.object(TestClass.self, implements: ProtocolA.self)
    let object: ProtocolA = try! container.resolve()
    XCTAssertTrue(object is TestClass)
    XCTAssertEqual(object.someValue, _helloWorld)
  }
  
  func testRegisterAndResolveObjectForConcatenateType() {
    container.register(factory: { TestClass() })
    container.object(TestClass.self, implements: ProtocolA.self)
    container.object(TestClass.self, implements: ProtocolB.self)
    let object: ProtocolA & ProtocolB = try! container.resolve()
    XCTAssertTrue(object is TestClass)
    XCTAssertEqual(object.someValue, _helloWorld)
    XCTAssertEqual(object.someValue2, "ProtocolB")
  }
  
  func testUniqueScope() {
    container.register(factory: { TestClass() })
    let object1: TestClass = try! container.resolve()
    object1.someValue = _helloWorld + _helloWorld
    let object2: TestClass = try! container.resolve()
    XCTAssertEqual(object1.someValue, _helloWorld + _helloWorld)
    XCTAssertEqual(object2.someValue, _helloWorld )
    XCTAssertFalse(object1 === object2)
  }
  
  func testWeakSingletonScope() {
    container.register(factory: { TestClass() }, scope: .weakSingleton)
    container.object(TestClass.self, implements: ProtocolA.self)
    let object1: TestClass = try! container.resolve()
    object1.someValue = _helloWorld + _helloWorld
    let object2: TestClass = try! container.resolve()
    XCTAssertEqual(object1.someValue, _helloWorld + _helloWorld)
    XCTAssertEqual(object2.someValue, _helloWorld + _helloWorld )
    XCTAssertTrue(object1 === object2)
  }
  
  static var allTests = [
    ("testRegisterAndResolveObject", testRegisterAndResolveObject),
    ("testRegisterAndResolveObjectForConcatenateType", testRegisterAndResolveObjectForConcatenateType),
    ("testUniqueScope", testUniqueScope),
    ("testWeakSingletonScope", testWeakSingletonScope)
  ]
}

private protocol ProtocolA {
  var someValue: String { get set }
}

private class TestClass: ProtocolA {
  var someValue: String = "Hello, World!"
}

private protocol ProtocolB {
  var someValue2: String { get }
}

extension ProtocolB where Self: TestClass {
  var someValue2: String {
    return "ProtocolB"
  }
}

extension TestClass: ProtocolB {}
