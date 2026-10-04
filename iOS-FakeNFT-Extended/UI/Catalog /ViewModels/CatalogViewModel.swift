import Foundation
import Observation

enum SortType: String {
	case none
	case name
	case nftCount
}

@Observable
@MainActor
final class CatalogViewModel {
	private(set) var collections: [NFTCollection] = []
	var isLoading: Bool = false
	var showNetworkAlert: Bool = false
	var alertErrorMessage: String = ""
	
	private let service: NftService
	
	@ObservationIgnored
	private var currentSortType: SortType {
		didSet {
			UserDefaults.standard.set(currentSortType.rawValue, forKey: "selectedSortType")
		}
	}
	
	init(service: NftService) {
		self.service = service
		
		let savedRawValue = UserDefaults.standard.string(forKey: "selectedSortType") ?? ""
		currentSortType = SortType(rawValue: savedRawValue) ?? .none
		
		fetchCatalogData()
	}
	
	func sortByNftCount() {
		currentSortType = .nftCount
		applyCurrentSort()
	}
	
	func sortByName() {
		currentSortType = .name
		applyCurrentSort()
	}
	
	private func applyCurrentSort() {
		switch currentSortType {
		case .name:
			collections = collections.sorted { $0.name < $1.name }
		case .nftCount:
			collections = collections.sorted { $0.nftCount > $1.nftCount }
		case .none:
			break
		}
	}
	
	func fetchCatalogData() {
		guard !isLoading else { return }
		isLoading = true
		
		Task {
			do {
				try await Task.sleep(nanoseconds: 1_500_000_000)
				loadLocalMockData()
			} catch {
				alertErrorMessage = error.localizedDescription
				showNetworkAlert = true
				isLoading = false
			}
		}
	}
	
	private func loadLocalMockData() {
		guard let url = Bundle.main.url(forResource: "collections_mock", withExtension: "json") else {
			alertErrorMessage = "Не удалось найти файл данных"
			showNetworkAlert = true
			isLoading = false
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode([NFTCollection].self, from: data)
			collections = decoded
			isLoading = false
			applyCurrentSort()
		} catch {
			alertErrorMessage = error.localizedDescription
			showNetworkAlert = true
			isLoading = false
		}
	}
}
