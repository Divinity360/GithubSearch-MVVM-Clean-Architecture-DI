import XCTest
import Combine
@testable import GithubFollower

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 1,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = expectation(description: "Awaiting publisher")
        
        let cancellable = publisher
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        result = .failure(error)
                    case .finished:
                        break
                    }
                    expectation.fulfill()
                },
                receiveValue: { value in
                    result = .success(value)
                }
            )
        
        // Add teardown to ensure cancellation even on test failure
        addTeardownBlock {
            cancellable.cancel()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        let unwrappedResult = try XCTUnwrap(
            result,
            "Empty result received from publisher",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
    
    /// Creates a test DIContainer with mock services
    func makeTestContainer(
        networkService: NetworkServiceProtocol = MockNetworkService(),
        persistenceService: PersistenceServiceProtocol = MockPersistenceService()
    ) -> DIContainer {
        return DIContainer(
            networkService: networkService,
            persistenceService: persistenceService
        )
    }
}