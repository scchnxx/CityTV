import Cocoa

extension CCTVPreviewView {
    
    enum State: Int {
        case preparing
        case playing
        case paused
        case stopped
    }
    
}

class CCTVPreviewView: NSView {
    
    private var session: URLSession?
    private var currentTask: URLSessionDataTask?
    private var cctvValue: CCTVData.Value?
    private var receivedData = Data()
    private var recoveryCount = 0
    
    var backgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var didStart: (() -> Void)?
    var didPause: (() -> Void)?
    var didResume: (() -> Void)?
    var didStop: (() -> Void)?
    
    var state = State.stopped {
        didSet {
            switch state {
            case .playing:   (oldValue == .paused) ? didResume?() :didStart?()
            case .paused:    didPause?()
            case .stopped:   didStop?()
            default:         break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer?.contentsGravity = .resizeAspect
        backgroundColor = .black
    }
    
    func play(with value: CCTVData.Value) {
        if value == cctvValue {
            if state == .paused {
                resume()
                return
            } else if state == .playing {
                return
            }
        }
        
        stop()
        
        let newSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let req = URLRequest(url: value.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 1)
        
        cctvValue = value
        session = newSession
        state = .preparing
        
        currentTask = newSession.dataTask(with: req)
        currentTask?.resume()
    }
    
    func resume() {
        guard state == .paused else { return }
        recover()
    }
    
    func pause() {
        guard state == .playing else { return }
        state = .paused
        cancel()
    }
    
    func stop() {
        guard let session = session else { return }
        let alreadyStopped = (currentTask == nil)
        self.session = nil
        session.invalidateAndCancel()
        if alreadyStopped {
            state = .stopped
        }
    }
    
    private func cancel() {
        guard let task = currentTask else { return }
        currentTask = nil
        task.cancel()
    }
    
    private func recover() {
        guard let session = session else { return }
        guard let value = cctvValue else { return }
        let req = URLRequest(url: value.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3)
        currentTask = session.dataTask(with: req)
        currentTask?.resume()
    }
    
}

fileprivate let SOI = Data([0xFF, 0xD8])
fileprivate let EOI = Data([0xFF, 0xD9])

extension CCTVPreviewView: URLSessionTaskDelegate, URLSessionDataDelegate {
    
    private func checkImageData(_ data: Data) -> Bool {
        guard data.count >= 125 else { return false }
        return data.subdata(in: 0..<2) == SOI &&
            data.range(of: EOI, options: .backwards, in: (data.endIndex - 4)..<data.endIndex) != nil
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if state != .playing {
            state = .playing
            recoveryCount = 0
        }
        receivedData += data
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        if checkImageData(receivedData), let image = NSImage(data: receivedData) {
            layer?.contents = image
        }
        receivedData.removeAll()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        receivedData.removeAll()
        
        if session == self.session {
            if state != .paused {
                if recoveryCount != 3 {
                    recoveryCount += 1
                    recover()
                } else {
                    state = .stopped
                }
            }
        } else if self.session == nil {
            state = .stopped
        }
    }
    
}
