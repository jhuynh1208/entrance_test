//
//  UITextField+Extension.swift
//  entrance_test
//
//  Created by Thiện on 27/11/2022.
//

import UIKit
import Combine

extension UITextField {
    func textChangedPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}
