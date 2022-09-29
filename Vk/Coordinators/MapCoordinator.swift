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
        vc.view.backgroundColor = .systemBackground
        vc.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map")?.withAlignmentRectInsets(.init(top: 0, left: 0, bottom: 0, right: 0)), tag: 0 )
        vc.view.backgroundColor = .systemBackground
        vc.title = "Map"
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: false)
    }

    func pop (){
        navigationController.popViewController(animated: true)
    }

}
