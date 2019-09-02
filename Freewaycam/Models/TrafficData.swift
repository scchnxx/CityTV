protocol TraficData {
    var id: String { get }
    init?(data: [String: String])
}
