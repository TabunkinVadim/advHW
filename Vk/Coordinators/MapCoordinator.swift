//
//  MapCoordinator.swift
//  Vk
//
//  Created by Табункин Вадим on 25.09.2022.
//

import Foundation
import UIKit

public final class MapCoordinator: Coordinator{

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController


    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MapViewController()
        vc.view.backgroundColor = .backgroundColor
        vc.tabBarItem = UITabBarItem(title: "Map".localized, image: UIImage(systemName: "map")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func pop (){
        navigationController.popViewController(animated: true)
    }

}
