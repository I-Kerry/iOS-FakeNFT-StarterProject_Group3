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
	
	private let storage = UserDefaultsService.shared
	
	@ObservationIgnored
	private var currentSortType: SortType {
		didSet {
			storage.selectedSortType = currentSortType.rawValue
		}
	}
	
	init() {
		let savedRawValue = storage.selectedSortType
		currentSortType = SortType(rawValue: savedRawValue) ?? .none
		
		loadLocalMockData()
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
	
	private func loadLocalMockData() {
		guard let url = Bundle.main.url(forResource: "collections_mock", withExtension: "json") else {
			return
		}
		
		do {
			let data = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode([NFTCollection].self, from: data)
			collections = decoded
			applyCurrentSort()
		} catch {
			print(error)
		}
	}
}
