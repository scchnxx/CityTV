protocol TrafficData {
    var id: String { get }
    init?(data: [String: String])
}
