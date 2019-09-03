import Cocoa

class PreviewViewController: NSViewController {
    
    @IBOutlet weak var previewView: CCTVPreviewView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var reloadButton: NSButton!
    
    private var showLoadingIndicator: Bool {
        get {
            !loadingIndicator.isHidden
        }
        set(show) {
            loadingIndicator.isHidden = !show
            show ? loadingIndicator.startAnimation(nil) : loadingIndicator.stopAnimation(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.backgroundColor = .gray
        previewView.didStartLoading = { [unowned self] in
            self.showLoadingIndicator = true
            self.reloadButton.isHidden = true
        }
        previewView.didStart = { [unowned self] in
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = true
        }
        previewView.didFailToStart = { [unowned self] in
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = false
            print("didFailToStart")
        }
        previewView.didStop = { [unowned self] in
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = false
        }
        
        NotificationCenter.default.addObserver(forName: CameraListViewController.selectionDidChangeNotification, object: nil, queue: .main) { note in
            guard let cctv = note.cctv else { return }
            self.previewView.play(cctv: cctv)
        }
        
        showLoadingIndicator = false
        reloadButton.isHidden = true
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        previewView.resume()
    }
    
}
