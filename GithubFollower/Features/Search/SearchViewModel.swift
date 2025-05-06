import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isUsernameValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $username
            .map { !$0.isEmpty }
            .assign(to: \.isUsernameValid, on: self)
            .store(in: &cancellables)
    }
    
    func testTaskGroup() async {
        await withTaskGroup(of: String.self) { group in
            group.addTask {
                try? await Task.sleep(nanoseconds: 1_000_000)
                return "First task"
            }
            
            group.addTask {
                try? await Task.sleep(nanoseconds: 2_000_000)
                return "Second task"
            }
            
            for await result in group {
                print(result)
            }
        }
    }
}
