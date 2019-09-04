import Cocoa

extension LocationPath {

    private var directions: [Direction] {
        switch self {
        case .n1:   fallthrough
        case .n3:   fallthrough
        case .n5:   fallthrough
        case .n1H:  fallthrough
        case .n2K:  fallthrough
        case .n3N:  return [.north, .south]
        default:    return [.west, .east]
        }
    }
    
    func hasDirection(_ d: Direction) -> Bool {
        directions.contains(d)
    }
    
    var iconName: String {
        switch self {
        case .n1H: return LocationPath.n1.rawValue
        case .n3N: return LocationPath.n3.rawValue
        default:   return rawValue
        }
    }
    
}

extension CCTV {
    
    var iconName: String {
        "CCTV"
    }
    
}

extension Notification {
    
    var cctv: CCTV? {
        userInfo?[CameraListViewController.Key.cctv] as? CCTV
    }
    
}

class CameraListViewController: NSViewController {
    
    struct Key {
        static let cctv = "cctv"
    }
    
    static let selectionDidChangeNotification = Notification.Name(rawValue: "com.scchnxx.CityTV.CameraListViewController.selectionDidChangeNotification")
    
    // MARK: - UI
    
    @IBOutlet
    weak var outlineView: NSOutlineView!
    
    lazy var blockingViewController: BlockingViewController = {
        let controller = storyboard!.instantiateController(withIdentifier: "BlockingViewController") as! BlockingViewController
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    // MARK: - Data
    
    private var roadType = RoadType.freeway
    private var direction = Direction.north
    private var cctvs = [CCTV]()
    private var outlineViewNodes = [OutlineViewNode]()
    private var showBlockingView: Bool {
        get {
            blockingViewController.view.superview != nil
        }
        set(show) {
            let blockingView = blockingViewController.view
            
            blockingView.removeFromSuperview()
            
            if show {
                blockingView.removeFromSuperview()
                view.addSubview(blockingView)
                blockingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                blockingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                blockingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                blockingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                blockingViewController.startAnimation()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outlineView.dataSource = self
        outlineView.delegate = self
        
        reloadRemoteData()
    }
    
    private func reloadRemoteData() {
        showBlockingView = true
        
        TrafficInfoLoader().fetch(CCTV.self, type: .cctv) { result in
            if case .success(let cctvs) = result {
                self.cctvs = cctvs
            } else {
                self.cctvs = []
            }

            self.updateOutlineViewNodes()
            self.reloadOutlineView()
            self.showBlockingView = false
        }
    }
    
    private func updateOutlineViewNodes() {
        var nodes = [OutlineViewNode]()
        var cctvs = self.cctvs.filter { $0.direction == self.direction }
        let locationPathFilter: (LocationPath) -> Bool = {
            $0.roadType == self.roadType &&
                $0.hasDirection(self.direction)
        }
        let locationPaths = LocationPath.allCases.filter(locationPathFilter)
        
        for (index, path) in locationPaths.enumerated() {
            var node = OutlineViewNode(name: "\(path)", iconName: path.iconName, children: [])
            cctvs.removeAll { cctv in
                guard cctv.locationpath == path else { return false }
                node.children.append(OutlineViewNode(name: "", cctv: cctv, children: []))
                return true
            }
            nodes += [node]
            if index < locationPaths.count - 1 {
                nodes += [OutlineViewNode.separator()]
            }
        }
        
        outlineViewNodes = nodes
    }
    
    private func reloadOutlineView() {
        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func roadTypeControlDidChangeValue(_ sender: NSSegmentedControl) {
        roadType = RoadType(rawValue: sender.indexOfSelectedItem)!
        updateOutlineViewNodes()
        reloadOutlineView()
    }
    
    @IBAction func directionListButtonDidChangeValue(_ sender: NSPopUpButton) {
        direction = Direction.allCases[sender.indexOfSelectedItem]
        updateOutlineViewNodes()
        reloadOutlineView()
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        reloadRemoteData()
    }
    
}

extension CameraListViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if let node = item as? OutlineViewNode {
            if node.isSeparator {
                return 10
            } else if node.isLeaf {
                return 20
            } else {
                return 22
            }
        }
        return 20
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let node = item as? OutlineViewNode {
            return node.children[index]
        } else {
            return outlineViewNodes[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let node = item as? OutlineViewNode {
            return node.children.count
        } else {
            return outlineViewNodes.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let node = item as? OutlineViewNode {
            return !node.isLeaf
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        (item as? OutlineViewNode)?.isLeaf ?? false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let node = item as? OutlineViewNode else { return nil }
        
        let cellId = node.isSeparator ? "SeparatorCell" : (node.isLeaf ? "CCTVCell" : "RoadCell")
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), owner: nil)
        
        if let cctv = node.cctv, let cctvCellView = view as? CCTVCellView {
            var vm = CCTVCellViewModel(cctv: cctv)
            vm.iconName = "CCTV"
            cctvCellView.loadViewModel(vm)
        } else if let roadCellView = view as? RoadCellView, !node.isSeparator {
            let vm = RoadCellViewModel(name: node.name, iconName: node.iconName)
            roadCellView.loadViewModel(vm)
        }
        
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard outlineView.selectedRow != -1 else { return }
        guard let node = outlineView.item(atRow: outlineView.selectedRow) as? OutlineViewNode else { return }
        guard let cctv = node.cctv else { return }
        NotificationCenter.default.post(name: CameraListViewController.selectionDidChangeNotification,
                                        object: nil, userInfo: [Key.cctv: cctv])
    }
    
}
