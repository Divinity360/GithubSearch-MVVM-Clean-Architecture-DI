import XCTest
import Combine
@testable import GithubFollower

final class SearchViewModelTests: XCTestCase {
    
    var sut: SearchViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = SearchViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInitialState() {
        // Verify initial state
        XCTAssertEqual(sut.username, "", "Username should be empty initially")
        XCTAssertFalse(sut.isUsernameValid, "Username should not be valid initially")
    }
    
    func testUsernameValidity_WhenEmpty_ShouldBeInvalid() {
        // Given
        let expectation = self.expectation(description: "Username validity updated")
        var isValid = true
        
        sut.$isUsernameValid
            .dropFirst() // Skip initial value
            .sink { value in
                isValid = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.username = ""
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertFalse(isValid, "Empty username should be invalid")
    }
    
    func testUsernameValidity_WhenNonEmpty_ShouldBeValid() {
        // Given
        let expectation = self.expectation(description: "Username validity updated")
        var isValid = false
        
        sut.$isUsernameValid
            .dropFirst() // Skip initial value
            .sink { value in
                isValid = value
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.username = "testuser"
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertTrue(isValid, "Non-empty username should be valid")
    }
    
    func testUsernameValidity_WhenChangedFromValidToInvalid_ShouldUpdateValidity() {
        // Given
        var validityChanges: [Bool] = []
        let expectation = expectation(description: "Username validity changed twice")
        expectation.expectedFulfillmentCount = 2
        
        sut.$isUsernameValid
            .dropFirst() // Skip initial value
            .sink { value in
                validityChanges.append(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.username = "testuser" // Should be valid
        sut.username = "" // Should be invalid
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertEqual(validityChanges, [true, false], "Validity should change from true to false")
    }
    
    func testAsyncTaskGroup() async {
        // This is a simple test to ensure the task group implementation works
        // In real-world scenarios, you'd test more meaningful async functionality
        
        // When
        await sut.testTaskGroup()
        
        // Then - we just verify it doesn't crash
        XCTAssertTrue(true)
    }
}