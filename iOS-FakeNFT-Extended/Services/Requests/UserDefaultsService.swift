import Foundation

final class UserDefaultsService {
	static let shared = UserDefaultsService()
	private let defaults = UserDefaults.standard

	private init() {}

	private enum Key {
		static let selectedSortType = "selectedSortType"
	}

	var selectedSortType: String {
		get { defaults.string(forKey: Key.selectedSortType) ?? "" }
		set { defaults.set(newValue, forKey: Key.selectedSortType) }
	}
}
