import UIKit

private let defaultDelegate = PopoverPresenterImplementation()

protocol PopoverPresenter {
}

extension PopoverPresenter where Self: UIViewController {
    func showAsPopover(_ controller: UIViewController,
                       from sourceView: UIView,
                       preferSize: CGSize) {
        controller.preferredContentSize = preferSize
        controller.modalPresentationStyle = .popover

        /* 3 */
        // Present popover
        if let popover = controller.popoverPresentationController {
            popover.permittedArrowDirections = .any
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.delegate = defaultDelegate
        }

        present(controller, animated: true, completion: nil)
    }
}

private class PopoverPresenterImplementation: NSObject, UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension UIViewController: ModalPresenter {
}
