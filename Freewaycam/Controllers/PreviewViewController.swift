import Cocoa

class PreviewViewController: NSViewController {
    
    @IBOutlet weak var previewView: CCTVPreviewView!
    @IBOutlet weak var stopButton: NSButton!
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
        
        setupPreviewView()
        stopButton.isHidden = true
        showLoadingIndicator = false
        reloadButton.isHidden = true
        
        NotificationCenter.default.addObserver(forName: CameraListViewController.selectionDidChangeNotification, object: nil, queue: .main) { note in
            guard let cctv = note.cctv else { return }
            self.previewView.play(cctv: cctv)
        }
    }
    
    private func setupPreviewView() {
        previewView.didStartLoading = { [unowned self] in
            self.stopButton.isHidden = false
            self.showLoadingIndicator = true
            self.reloadButton.isHidden = true
        }
        previewView.didStart = { [unowned self] in
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = true
        }
        previewView.didFailToStart = { [unowned self] in
            self.stopButton.isHidden = true
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = false
        }
        previewView.didStop = { [unowned self] in
            self.stopButton.isHidden = true
            self.showLoadingIndicator = false
            self.reloadButton.isHidden = false
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        previewView.stop()
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        previewView.resume()
    }
    
}
