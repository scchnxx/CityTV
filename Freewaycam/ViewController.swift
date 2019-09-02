import Cocoa

enum RoadType: Int {
    case freeway
    case expressway
}

extension LocationPath {
    
    var roadType: RoadType {
        switch self {
        case .n1:  fallthrough
        case .n2:  fallthrough
        case .n3:  fallthrough
        case .n3A: fallthrough
        case .n4:  fallthrough
        case .n5:  fallthrough
        case .n6:  fallthrough
        case .n8:  fallthrough
        case .n10: fallthrough
        case .n1H: fallthrough
        case .n2K: fallthrough
        case .n3N: return .freeway
        default:   return .expressway
        }
    }
    
}

class ViewController: NSViewController {
    
    @IBOutlet weak var roadTypeControl: NSSegmentedControl!
    @IBOutlet weak var roadTableView: NSTableView!
    @IBOutlet weak var previewView: CCTVPreviewView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    
    let loader = TrafficInfoLoader()
    var allCCTVs = [CCTV]() {
        didSet {
            updateCCTVs()
        }
    }
    var roadType = RoadType.freeway {
        didSet {
            updateCCTVs()
        }
    }
    var filteredCCTVs = [CCTV]()
    
    private func updateCCTVs() {
        filteredCCTVs = allCCTVs.filter { cctv in
            LocationPath(id: cctv.locationpath)?.roadType == roadType
        }
        roadTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPreviewView()
        setUpTableView()
        
        TrafficInfoLoader().fetch(CCTV.self, type: .cctv) { result in
            guard case .success(let cctvs) = result else {
                self.allCCTVs = []
                return
            }
            self.allCCTVs = cctvs
        }
    }
    
    private func setUpTableView() {
        roadTableView.dataSource = self
        roadTableView.delegate = self
        roadTableView.doubleAction = #selector(tableViewItemDidDoubleClick(_:))
    }
    
    private func setUpPreviewView() {
        loadingIndicator.isHidden = false
        
        previewView.didStart = { [unowned self] in
            print("didStart")
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimation(nil)
        }
        
        previewView.didStartLoading = { [unowned self] in
            print("didStartLoading")
            self.loadingIndicator.startAnimation(nil)
            self.loadingIndicator.isHidden = false
        }
        
        previewView.didFailToStart = { [unowned self] in
            print("didFailToStart")
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimation(nil)
        }
        
        previewView.didStop = { [unowned self] in
            print("didStop")
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimation(nil)
        }
    }
    
    @objc private func tableViewItemDidDoubleClick(_ sender: NSTableView) {
        previewView.play(cctv: allCCTVs[sender.selectedRow])
    }
    
    @IBAction func roadTypeControlDidChangeValue(_ sender: NSSegmentedControl) {
        roadType = RoadType(rawValue: sender.selectedSegment)!
    }
    
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        filteredCCTVs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RoadCellID"), owner: nil)
        
        if let cellView = view as? NSTableCellView {
            let cctv = filteredCCTVs[row]
            cellView.textField?.stringValue = cctv.roadsection
        }
        
        return view
    }
    
}
