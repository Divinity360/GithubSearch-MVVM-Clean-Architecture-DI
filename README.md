# GitHub Followers

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A Swift iOS application that leverages the GitHub API to search for users and display their followers. Built with a clean MVVM architecture, dependency injection, and comprehensive testing.
<p>
<img src="https://github.com/user-attachments/assets/9551418c-df8b-47d3-b1eb-446f25bffec0" width="250" alt="Simulator Screenshot 1">
<img src="https://github.com/user-attachments/assets/36752a09-1646-4e5b-9671-357a7865449a" width="250" alt="Simulator Screenshot 2">
<img src="https://github.com/user-attachments/assets/ddc0eac6-95ae-4ad2-a74b-0d9d8d26ff86" width="250" alt="Simulator Screenshot 3">
</p>

## Features

- **GitHub User Search**: Search for any GitHub user by username
- **Follower List**: View a paginated list of followers for any user
- **User Details**: Detailed profile information including:
  - Avatar image
  - Name and username
  - Bio and location
  - Repository, gist, follower, and following counts
  - Link to GitHub profile
- **Favorites System**: 
  - Add users to favorites for quick access
  - Remove users from favorites with swipe actions
  - Persistent storage of favorites
- **UI Features**:
  - Clean, modern interface with intuitive navigation
  - Support for light and dark mode
  - Empty state views with helpful messages
  - Loading indicators for network operations
  - Search functionality within follower lists
- **Offline Support**: Saved favorites accessible without internet connection

## Technical Highlights

### Architecture
- **MVVM Pattern**: Clear separation between View, ViewModel, and Model layers
- **Clean Architecture**: Well-defined boundaries between presentation, domain, and data layers
- **Dependency Injection**: Services and repositories injected via DIContainer

### Technologies & Frameworks
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for handling asynchronous events
- **Swift Concurrency**: Use of async/await and task groups for concurrent operations
- **URLSession**: Network layer for API communication
- **UserDefaults**: Local persistence of favorite users

### Testing
- **Unit Tests**: Comprehensive test coverage for models, services, and view models
- **UI Tests**: Automated tests for critical user flows using XCTest
- **Mock Services**: Test doubles for network and persistence layers
- **Screen Page Objects**: Abstraction of UI elements for better test readability

## Project Structure

```
GithubFollower/
├── Core/
│   ├── DI/
│   │   └── DIContainer.swift
│   ├── Extensions/
│   │   ├── UIImage+Ext.swift
│   │   └── View+Ext.swift
│   ├── TabBarView.swift
│   └── ColorSchemeManager.swift
├── Common/
│   └── Views/
│       ├── GFButton.swift
│       ├── GFTextField.swift
│       ├── GFAvatarImageView.swift
│       └── GFEmptyStateView.swift
├── Features/
│   ├── Search/
│   │   ├── SearchView.swift
│   │   ├── SearchViewModel.swift
│   │   └── SettingsView.swift
│   ├── FollowerList/
│   │   ├── FollowerListView.swift
│   │   ├── FollowerListViewModel.swift
│   │   └── FollowerCell.swift
│   ├── UserDetail/
│   │   ├── UserDetailView.swift
│   │   ├── UserDetailViewModel.swift
│   │   └── UserInfoHeaderView.swift
│   └── Favorites/
│       ├── FavoritesView.swift
│       └── FavoritesViewModel.swift
├── Models/
│   ├── Follower.swift
│   └── User.swift
├── Network/
│   ├── NetworkService.swift
│   └── NetworkManager.swift
└── Utilities/
    └── PersistenceService.swift
```

## Test Structure

```
GithubFollowerTests/
├── TestHelpers/
│   ├── TestData.swift
│   ├── MockNetworkService.swift
│   ├── MockPersistenceService.swift
│   └── XCTestCase+Extension.swift
├── Services/
│   ├── NetworkServiceTests.swift
│   └── PersistenceServiceTests.swift
└── ViewModels/
    ├── SearchViewModelTests.swift
    ├── FollowerListViewModelTests.swift
    ├── UserDetailViewModelTests.swift
    └── FavoritesViewModelTests.swift

GithubFollowerUITests/
├── Helpers/
│   └── XCUIElement+Extensions.swift
├── Screens/
│   ├── SearchScreen.swift
│   ├── FollowerListScreen.swift
│   ├── UserDetailScreen.swift
│   └── FavoritesScreen.swift
└── Flows/
    ├── SearchFlowUITests.swift
    └── FavoritesFlowUITests.swift
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/GithubFollower.git
```

2. Open the project in Xcode:
```bash
cd GithubFollower
open GithubFollower.xcodeproj
```

3. Build and run the project in Xcode using the iOS Simulator or a connected device.

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.0+

## Testing

The project includes both unit tests and UI tests:

- To run unit tests: `⌘+U` or select Product > Test from Xcode
- To run individual test classes: Right-click a test class and select "Run TestClassName"

## Contributing

1. Fork the project
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add some amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [GitHub API](https://docs.github.com/en/rest) for providing the data
- Icons from [SF Symbols](https://developer.apple.com/sf-symbols/)
