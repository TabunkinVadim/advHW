//
//  LocalAuthorizationService.swift
//  Vk
//
//  Created by Табункин Вадим on 19.10.2022.
//

import LocalAuthentication

class LocalAuthorizationService {

    weak var delegate:LogInViewControllerProtocol?

    let context = LAContext()
    var biometricType: LABiometryType {
        get {
            let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            return context.biometryType
        }
    }

    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        var error: NSError? = nil
        context.canEvaluatePolicy(policy, error: &error)
        if let error = error {
            print(error)
            self.delegate?.showAlert(title: "Error".localized, massege: error.localizedDescription, action: { _ in
            })

        } else {
            context.evaluatePolicy(policy, localizedReason: "logInToLogin".localized)
            { [weak self] success, error in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    if success {
                        authorizationFinished(true)
                    } else {
                        self.delegate?.showAlert(title: "Error".localized, massege: "authenticationError".localized, action: { _ in
                        })
                    }
                }
            }
        }
    }
}
