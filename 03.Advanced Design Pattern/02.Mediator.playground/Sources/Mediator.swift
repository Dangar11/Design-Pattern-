//Define as Generic class
open class Mediator<ColleagueT> {
    
    //inner class support 2 scenarious weak and strong
    //declare AnyObject instead of ColleagueT
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
      // This is a convenience property that first attempts to unwrap weakColleague and, if that’s nil, then it attempts to unwrap strongColleague.
        var colleague: ColleagueT? {
            return (weakColleague ?? strongColleague) as? ColleagueT
        }
        
        //to initializer to weak and strong cases
        init(weakColleague: ColleagueT) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: ColleagueT) {
            self.strongColleague = strongColleague as AnyObject
            self.weakColleague = nil
        }
    }
    
    
    //MARK: - InstanceProperties
    //Hold ColleagueWrappers
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    //filter to find colleagues from colleagueWrappers that have already been released and returns non-nil colleagues
    public var colleagues: [ColleagueT] {
        var colleagues: [ColleagueT] = []
        colleagueWrappers = colleagueWrappers.filter { guard let colleague = $0.colleague else { return false }
        colleagues.append(colleague)
        return true
        }
        return colleagues
    }
    
    //MARK: - Object Lifecycle
    //public designated initializer
    public init() { }
    
    
    //MARK: - Colleague Managment
    
    // creates either strongly or weakly colleague
    
    public func addColleague(_ colleague: ColleagueT, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    // find index for the ColleagueWrapper that matches the colleague using pointer === it's exact CollegueType object
    //if you find you remote at given index
    public func removeColleague(_ colleague: ColleagueT) {
      guard let index = colleagues.firstIndex(where: { ($0 as AnyObject) === (colleague as AnyObject)})
    else { return }
    colleagueWrappers.remove(at: index)
    }
  

    public func invokeColleagues(closure: (ColleagueT) -> Void) {
        colleagues.forEach(closure)
    }
    
    public func invokeColleagues(by colleague: ColleagueT, closure: (ColleagueT) -> Void) {
        colleagues.forEach { guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closure($0)
        }
    }
    
    
}
