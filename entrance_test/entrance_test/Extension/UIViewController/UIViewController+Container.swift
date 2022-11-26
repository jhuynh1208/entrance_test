import UIKit

extension UIViewController {
    func addChildController(_ child: UIViewController,
                            container: UIView? = nil) {
        guard let container = container ?? view else { return }

        addChild(child)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(child.view)

        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: container.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        child.didMove(toParent: self)
    }

    func removeFromParentController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
