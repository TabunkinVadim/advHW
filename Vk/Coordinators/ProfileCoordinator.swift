//
//  ProfileCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 23.06.2022.
//

import Foundation
import StorageService
import UIKit
import RealmSwift
import Firebase

final class ProfileCoordinator: Coordinator{
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let loginCheker: LoginInspector
    var item :AuthorizationRealmModel?
    init(navigationController: UINavigationController, loginCheker: LoginInspector) {
        self.navigationController = navigationController
        self.loginCheker = loginCheker
    }
    
    func start() {
        item = RealmCoordinator().get()
        guard let item = item  else {
            logInVC()
            return}
        
        if item.logIn{
#if DEBUG
            self.profileVC(user: TestUserService(), name: "Petr".localized)
#else
            self.profileVC(user: CurrentUserService(), name: "Ivan".localized )
#endif
        } else {
            logInVC()
        }
    }
    
    func logInVC() {
        let vc = LogInViewController(loginCheker: loginCheker)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        vc.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }
    
    func profileVC(user: UserService, name: String) {
        let vc = ProfileViewController(user: user, name: name, personalPosts: posts)
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        vc.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func photoVC() {
        let vc = PhotosViewController()
        vc.coordinator = self
        vc.view.backgroundColor = .backgroundColor
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(vc, animated: true)
    }
    
    func didfinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
