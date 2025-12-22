import AppIntents

// MARK: - Search Engine Enum

enum SnowlineModeIntent: String, AppEnum {

    case google, bing, duckduckgo, startpage, ecosia, brave, metager

    static var typeDisplayRepresentation =
        TypeDisplayRepresentation(name: "Snowline Search Engine")

    static var caseDisplayRepresentations:
        [SnowlineModeIntent: DisplayRepresentation] = [
            .google: "Google",
            .bing: "Bing",
            .duckduckgo: "DuckDuckGo",
            .startpage: "Startpage",
            .ecosia: "Ecosia",
            .brave: "Brave Search",
            .metager: "MetaGer",
        ]
}

// MARK: - Open Snowline

struct OpenSnowlineIntent: AppIntent {

    static var title: LocalizedStringResource = "Open Snowline"
    static var openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        .result()
    }
}

// MARK: - Open Snowline With Engine

struct OpenSnowlineWithEngineIntent: AppIntent {

    static var title: LocalizedStringResource =
        "Open Snowline with Search Engine"

    static var openAppWhenRun = true

    @Parameter(title: "Search Engine")
    var mode: SnowlineModeIntent

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(
            mode.rawValue,
            forKey: "snowline_startpage"
        )
        return .result()
    }
}
