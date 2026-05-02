import Foundation

struct Route: Identifiable {
    let id = UUID()
    let mode: String
    let cost: String
    let time: String
    let transfers: Int
    let convenience: String
    let accentName: String
    let note: String
    let path: [String]
}
