import Foundation
import Observation

@Observable
@MainActor
final class CatalogViewModel {
	var collections: [NFTCollection] = []
	var isLoading: Bool = false
	
	init() {
		loadLocalMockData()
	}
	
	func sortByNftCount() {
		let sorted = collections.sorted { $0.nftCount > $1.nftCount }
		self.collections = sorted
	}
	
	func sortByName() {
		let sorted = collections.sorted { $0.name < $1.name }
		self.collections = sorted
	}
	
	private func loadLocalMockData() {
		guard let url = Bundle.main.url(forResource: "collections_mock", withExtension: "json"),
			  let data = try? Data(contentsOf: url),
			  let decoded = try? JSONDecoder().decode([NFTCollection].self, from: data) else {
			return
		}
		self.collections = decoded
	}
}
