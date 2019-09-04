struct OutlineViewNode {
    
    var name: String
    var cctv: CCTV?
    var iconName: String?
    var children: [OutlineViewNode]
    var isSeparator = false
    var isLeaf: Bool {
        children.isEmpty
    }
    
    static func separator() -> OutlineViewNode {
        OutlineViewNode(name: "", children: [], isSeparator: true)
    }
    
}
