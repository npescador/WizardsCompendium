import Foundation

protocol FavoritesStore {
    func toggleFavorite(id: String, type: FavoriteType)
    func isFavorite(id: String, type: FavoriteType) -> Bool
    func favorites(of type: FavoriteType) -> Set<String>
}

enum FavoriteType: String {
    case character
    case spell
}

final class UserDefaultsFavoritesStore: FavoritesStore {
    private let defaults: UserDefaults
    private let keyPrefix = "favorites."

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func toggleFavorite(id: String, type: FavoriteType) {
        var set = favorites(of: type)
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        defaults.set(Array(set), forKey: key(for: type))
    }

    func isFavorite(id: String, type: FavoriteType) -> Bool {
        favorites(of: type).contains(id)
    }

    func favorites(of type: FavoriteType) -> Set<String> {
        let array = defaults.array(forKey: key(for: type)) as? [String] ?? []
        return Set(array)
    }

    private func key(for type: FavoriteType) -> String {
        "\(keyPrefix)\(type.rawValue)"
    }
}
