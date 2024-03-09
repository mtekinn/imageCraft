enum FilterType: CaseIterable {
    case none
    case sepia
    case noir
    case comic
    // Eklenen yeni filtreler
    case oldFilm
    case hdr
    case bokeh
    case colorPop
    case dramaticShadows
    
    var displayName: String {
        switch self {
        case .none: return "Original"
        case .sepia: return "Sepia"
        case .noir: return "Noir"
        case .comic: return "Comic"
        // Eklenen yeni filtreler için displayName tanımları
        case .oldFilm: return "Old Film"
        case .hdr: return "HDR"
        case .bokeh: return "Bokeh"
        case .colorPop: return "Color Pop"
        case .dramaticShadows: return "Dramatic Shadows"
        }
    }
}
