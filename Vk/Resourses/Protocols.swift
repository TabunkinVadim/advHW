//
//  Protocols.swift
//  Vk
//
//  Created by Табункин Вадим on 31.05.2022.
//

import Foundation
import UIKit

protocol UserService {
    func setUser(fullName:String) -> User?
}
protocol LoginViewControllerDelegate: AnyObject {
    func chek(login: String, pswd: String, completion: @escaping (AuthResult) -> Void)
    func signUp(login: String, pswd: String, completion: @escaping (AuthResult) -> Void)
    }
protocol LoginFactory{
    func getLoginChek() -> LoginInspector
}

protocol ProfileViewControllerProtocol: AnyObject {
    func close ()
}

protocol LogInViewControllerProtocol: AnyObject {
    func showAlert (title: String, massege: String, action:@escaping (UIAlertAction)-> Void)
}
