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
	var collections: [NFTCollection] = []
	var isLoading: Bool = false
	
	private var currentSortType: SortType {
		get {
			let savedValue = UserDefaults.standard.string(forKey: "selectedSortType") ?? ""
			return SortType(rawValue: savedValue) ?? .none
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: "selectedSortType")
		}
	}
	
	init() {
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
			self.collections = collections.sorted { $0.name < $1.name }
		case .nftCount:
			self.collections = collections.sorted { $0.nftCount > $1.nftCount }
		case .none:
			break
		}
	}
	
	private func loadLocalMockData() {
		guard let url = Bundle.main.url(forResource: "collections_mock", withExtension: "json"),
			  let data = try? Data(contentsOf: url),
			  let decoded = try? JSONDecoder().decode([NFTCollection].self, from: data) else {
			return
		}
		self.collections = decoded
		
		applyCurrentSort()
	}
}
