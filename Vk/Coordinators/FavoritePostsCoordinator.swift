//
//  FavoritePostsCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 28.08.2022.
//

import Foundation
import UIKit

public final class FavoritePostsCoordinator: Coordinator{

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = FavoritePostsController()
        vc.view.backgroundColor = .backgroundColor
        vc.tabBarItem = UITabBarItem(title: "Favorite".localized, image: UIImage(systemName: "heart.fill")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func pop (){
        navigationController.popViewController(animated: true)
    }

}
