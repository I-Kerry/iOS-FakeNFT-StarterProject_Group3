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
	private let storage = UserDefaultsService.shared
	
	private var currentSortType: SortType {
		didSet {
			storage.selectedSortType = currentSortType.rawValue
		}
	}
	
	init(service: NftService) {
		self.service = service
		
		let savedRawValue = storage.selectedSortType
		currentSortType = SortType(rawValue: savedRawValue) ?? .none
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
			let sorted = collections.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
			self.collections = sorted
		case .nftCount:
			let sorted = collections.sorted { $0.nftCount > $1.nftCount }
			self.collections = sorted
		case .none:
			break
		}
	}
	
	func fetchCatalogData() async {
		guard !isLoading else { return }
		isLoading = true
		
		do {
			let fetchedCollections = try await service.loadCollections()
			
			self.collections = fetchedCollections
			self.isLoading = false
			self.applyCurrentSort()
		} catch {
			self.alertErrorMessage = error.localizedDescription
			self.showNetworkAlert = true
			self.isLoading = false
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
