//
//  ProfileCoordinatorTests.swift
//  VkTests
//
//  Created by Табункин Вадим on 13.10.2022.
//

import XCTest
@testable import Vk

class ProfileCoordinatorTests: XCTestCase {
    let profileCoordinator =  ProfileCoordinator(navigationController: UINavigationController(), loginCheker: MyLoginFactory().getLoginChek())
    let realmCoordinator = RealmCoordinator()
    override func setUpWithError() throws {
        realmCoordinator.delete()
    }

    override func tearDownWithError() throws {
            realmCoordinator.delete()
    }

    func testStart_LogInNil() {
        profileCoordinator.start()
        XCTAssertNil(profileCoordinator.item)
    }

    func testStart_LogIntrue() {
        realmCoordinator.create(password: "1", email: "1")
        realmCoordinator.edit(item: realmCoordinator.get()!, isLogIn: true)
        profileCoordinator.start()
        XCTAssertEqual(profileCoordinator.item?.logIn, true)
        realmCoordinator.delete()
    }

    func testStart_LogInfalse() {
        realmCoordinator.create(password: "1", email: "1")
        realmCoordinator.edit(item: realmCoordinator.get()!, isLogIn: false)
        profileCoordinator.start()
        XCTAssertEqual(profileCoordinator.item?.logIn, false)
        realmCoordinator.delete()
    }
}
