protocol ViewModelLoadable {
    
    associatedtype ViewModel: Any
    
    func loadViewModel(_ vm: ViewModel)
    
}
