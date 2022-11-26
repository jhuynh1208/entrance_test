import UIKit

// MARK: - instance from nib
extension UIViewController {
    class func instance(_ storyboardId: String, storyboardName: String) -> Self {
        return instance(storyboardId, storyboard: UIStoryboard(name: storyboardName, bundle: nil))
    }
    
    class func instance(_ storyboardId: String, storyboard: UIStoryboard) -> Self {
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! Self
        return controller
    }
    
    class func instance(storyboardName: String) -> UIViewController {
        let sbId = String(describing: self)
        return instance(sbId, storyboardName: storyboardName)
    }
    
    class func instance(storyboard: UIStoryboard) -> UIViewController {
        let sbId = String(describing: self)
        return instance(sbId, storyboard: storyboard)
    }
}
