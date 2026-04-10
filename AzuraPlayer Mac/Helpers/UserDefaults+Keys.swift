import Foundation

extension UserDefaults {
    enum Keys {
        static let appLanguage          = "appLanguage"
        static let showSongTitleInMenuBar = "showSongTitleInMenuBar"
        static let savedStations        = "saved_stations_mac"
        static let playbackHistory      = "playback_history"
    }

    var showSongTitleInMenuBar: Bool {
        get { bool(forKey: Keys.showSongTitleInMenuBar) }
        set { set(newValue, forKey: Keys.showSongTitleInMenuBar) }
    }
}
