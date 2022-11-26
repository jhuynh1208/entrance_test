import UIKit

protocol ModalPresenter {
}

extension ModalPresenter where Self: UIViewController {
    func presentAsModal(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    func presentAsFullScreen(_ controller: UIViewController,
                             animated: Bool = true,
                             completion: (() -> Void)? = nil) {
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: animated, completion: completion)
    }
}

extension UIViewController: PopoverPresenter {
}
