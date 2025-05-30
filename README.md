




Country Lookup

Overview

This project provides a Swift-based implementation for fetching country data from an API, processing the results, and filtering them based on user input. It is designed using a modular and testable architecture, following the Model-View-ViewModel (MVVM) pattern to ensure a clear separation of concerns. The UI is built using UIKit, providing a responsive and intuitive experience. Additionally, the project leverages Swift Concurrency (async/await) for efficient asynchronous operations and follows a protocol-oriented programming approach to enhance flexibility and testability.

⸻

Key Features
	•	Fetch country data from a remote JSON source using URLSession and async/await.
	•	Decode the received JSON response into a strongly typed Swift Country model.
	•	Filter the list of countries dynamically based on user input (name, code, capital, or region).
	•	Clean, modular architecture that promotes separation of concerns and testability.
	•	Dynamic layout using UIStackView for better flexibility and accessibility.
	•	Integrated UISearchController for live filtering.
	•	Custom UITableViewCell to present country details (name, region, capital, ISO code).
	•	Localization support using NSLocalizedString.
	•	Unit tests for networking, ViewModel logic, and UI behavior using XCTest.

⸻

App Demo

iPhone with orientations
	•	Portrait and landscape support
	•	Search-enabled UI
	•	Clean country list layout
https://github.com/user-attachments/assets/8bdfcfd5-99f0-4585-8f7c-c1975101804e


⸻

Project Structure

⸻

1. Networking

BaseDomain

Defines the base domain for API requests.

enum BaseDomain {
    case countries
}

HttpMethodType

Defines HTTP request methods.

enum HttpMethodType {
    case get
    case post
}

RequestType

Protocol that defines a generic API request.

protocol RequestType {
    var baseDomain: BaseDomain { get }
    var endpoint: String { get }
    var httpMethod: HttpMethodType { get }
}

DataRequestType

An enumeration that implements RequestType for specific data requests.

enum DataRequestType: RequestType {
    case countries
}

RequestBuilder

Builds URLRequest objects from a given RequestType.

struct RequestBuilder {
    func buildRequest(for requestType: RequestType) throws -> URLRequest
}

NetworkClient

Handles executing network requests and returning raw data.

struct NetworkClient: NetworkClientProtocol {
    func performRequest(for requestType: DataRequestType) async throws -> Data
}


⸻

2. ViewModel

CountriesViewModel

Manages country data, performs network calls, and filters results.

class CountriesViewModel {
    var countries: [Country]
    var filteredCountries: [Country]
    
    func fetchCountries() async
    func filterCountries(searchText: String)
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
}


⸻

3. Unit Testing

NetworkClientTests

Tests the networking layer using a mock client. Covers:
	•	Successful responses
	•	JSON decoding errors
	•	Simulated network errors

CountriesViewModelTests

Verifies ViewModel logic:
	•	Correct country data parsing
	•	Real-time filtering logic for various search terms

CountriesViewControllerTests

Ensures:
	•	Proper UI updates when data is fetched
	•	Handling of empty search results
	•	Layout integrity across devices

⸻

How to run the App
	1.	Clone the repository.
	2.	Open the .xcodeproj or .xcworkspace file in Xcode.
	3.	Select a simulator or connected iOS device.
	4.	Press Run (⌘ + R) to launch the app.

⸻

How to run the Tests
	1.	Open the project in Xcode.
	2.	Select the appropriate test target.
	3.	Go to Product > Test, or press ⌘ + U.
	4.	Unit tests for networking, view model, and view controller will run with results displayed in the Test Navigator.

⸻


