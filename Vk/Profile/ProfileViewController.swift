//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import UIKit
import StorageService
import RealmSwift
import SwiftUI

protocol ProfileViewControllerProtocol: AnyObject {
    func close ()
}
class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    private var coreDataCoordinator = CoreDataCoordinator()
    weak var coordinator: ProfileCoordinator?
    private var index: Int = 0
    var header: ProfileHeaderView = ProfileHeaderView(reuseIdentifier: ProfileHeaderView.identifier)

    private lazy var tableView: UITableView = {
        $0.toAutoLayout()
        $0.dataSource = self
        $0.delegate = self
        
#if DEBUG
        $0.backgroundColor = .red
#else
        $0.backgroundColor = .systemGray6
#endif
        
        $0.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        $0.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        $0.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        return $0
    }(UITableView(frame: .zero, style: .grouped))
    
    var user: User

    init (user: UserService, name: String) {
        self.user = user.setUser(fullName: name) ?? User(fullName: "", avatar: UIImage(), status: "")

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func close() {
        let alert = UIAlertController(title: "Exit".localized, message: "YouAreSure".localized, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes".localized, style: .destructive) { _ in
            let realmCoordinator = RealmCoordinator()
            guard let item = realmCoordinator.get() else {return}
            realmCoordinator.edit(item: item, isLogIn: false)
            self.dismiss(animated: true)
            self.coordinator?.logInVC()
        }
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "No".localized, style: .cancel) { _ in
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegateClose = self
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func layout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows = 0
        if section == 0 {
            numberRows = 1
        } else {
            numberRows = posts.count
        }
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            var cell: PhotosTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            return cell
        } else {
            var cell: PostTableViewCell
            cell = (tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier , for: indexPath) as! PostTableViewCell)
            cell.setupCell(model: posts[indexPath.row], set: indexPath.row)
            cell.index = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tap)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header.avatar.image = user.avatar
            header.name.text = user.fullName
            header.status.text = user.status
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var autiHeight:CGFloat {
            UITableView.automaticDimension
        }
        return autiHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            coordinator?.photoVC()
        } else {
            index = indexPath.row
        }
    }

    @objc private func doubleTapped() {

        coreDataCoordinator.sevePost(post: posts[index])
        NotificationCenter.default.post(name: NSNotification.Name.reloadFavoritPost, object: nil)
    }
}

public extension NSNotification.Name {
    static let reloadFavoritPost = NSNotification.Name("reloadFavoritPost")
}
