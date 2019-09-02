import Cocoa

struct Node {
    var name: String
    var cctvs: [CCTV]?
}

struct NodeContainer {
    var name: String
    var nodes: [Node]
}

class CCTVListViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension CCTVListViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        []
    }
    
}
