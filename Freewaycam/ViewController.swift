import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var previewView: CCTVPreviewView!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resumeButton: NSButton!
    
    let loader = CCTVLoader()
    
    var currentCCTV: CCTV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CCTVLoader().fetch { result in
            guard case .success(let cctvs) = result else { return }
            self.currentCCTV = cctvs[55]
        }
        
        previewView.didStart = { [unowned self] in
            self.stopButton.isEnabled = true
        }
        
        previewView.didFailToStart = { [unowned self] in
            self.resumeButton.isEnabled = true
        }
        
        previewView.didStop = { [unowned self] in
            self.stopButton.isEnabled = false
            self.resumeButton.isEnabled = true
        }
    }

    @IBAction func play(_ sender: Any) {
        guard let cctv = currentCCTV else { return }
        previewView.play(cctv: cctv)
    }
    
    @IBAction func stop(_ sender: Any) {
        previewView.stop()
    }
    
    @IBAction func resume(_ sender: Any) {
        previewView.resume()
    }
    
}

