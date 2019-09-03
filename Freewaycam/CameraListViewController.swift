import Cocoa

struct Road {
    var name: String
    var iconName: String
    var cctvs: [CCTV]
}

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
    
    static let selectionDidChangeNotification = Notification.Name(rawValue: "com.scchnxx.Freewaycam.CameraListViewController.selectionDidChangeNotification")
    
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
    private var roads = [Road]()
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

            self.updateRoads()
            self.reloadOutlineView()
            self.showBlockingView = false
        }
    }
    
    private func updateRoads() {
        var roads = [Road]()
        var cctvs = self.cctvs.filter { $0.direction == self.direction }
        let locationPathFilter: (LocationPath) -> Bool = {
            $0.roadType == self.roadType &&
                $0.hasDirection(self.direction)
        }
        
        for path in LocationPath.allCases.filter(locationPathFilter) {
            var road = Road(name: "\(path)", iconName: path.iconName, cctvs: [])
            cctvs.removeAll { cctv in
                if cctv.locationpath == path {
                    road.cctvs += [cctv]
                    return true
                }
                return false
            }
            roads += [road]
        }
        
        self.roads = roads
    }
    
    private func reloadOutlineView() {
        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }
    
    @IBAction func roadTypeControlDidChangeValue(_ sender: NSSegmentedControl) {
        roadType = RoadType(rawValue: sender.indexOfSelectedItem)!
        updateRoads()
        reloadOutlineView()
    }
    
    @IBAction func directionListButtonDidChangeValue(_ sender: NSPopUpButton) {
        direction = Direction.allCases[sender.indexOfSelectedItem]
        updateRoads()
        reloadOutlineView()
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        reloadRemoteData()
    }
    
}

extension CameraListViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        item is Road ? 22 : 20
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let road = item as? Road {
            return road.cctvs[index]
        } else {
            return roads[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let road = item as? Road {
            return road.cctvs.count
        } else {
            return roads.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let road = item as? Road {
            return !road.cctvs.isEmpty
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        !(item is Road)
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cellId = (item is Road ? "RoadCell" : "CCTVCell")
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellId), owner: nil)
        
        if let road = item as? Road, let roadCell = view as? NSTableCellView {
            roadCell.textField?.stringValue = road.name
            roadCell.imageView?.image = NSImage(named: road.iconName)
        } else if let cctv = item as? CCTV, let cctvCell = view as? CCTVCellView {
            let vm = CCTVCellViewModel(cctv: cctv)
            cctvCell.loadCellViewModel(vm)
        }
        
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard outlineView.selectedRow != -1 else { return }
        guard let cctv = outlineView.item(atRow: outlineView.selectedRow) as? CCTV else { return }
        NotificationCenter.default.post(name: CameraListViewController.selectionDidChangeNotification,
                                        object: nil, userInfo: [Key.cctv: cctv])
    }
    
}
