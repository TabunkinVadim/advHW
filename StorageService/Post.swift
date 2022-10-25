
//
//  Post.swift
//  Navigation
//
//  Created by Табункин Вадим on 03.03.2022.
//

import Foundation
import UIKit
import iOSIntPackage

public struct Post {
    public let author: String
    public let image: UIImage
    public let description: String
    public var likes: Int
    public var views: Int
    public let title: String

    public init(author: String, image: UIImage, description: String,likes: Int,views: Int, title:String) {
        self .author = author
        self .image = image
        self .description = description
        self .likes = likes
        self .views = views
        self .title = title
    }
}

var images = [UIImage(imageLiteralResourceName: "img_1"), UIImage(imageLiteralResourceName: "img_2"), UIImage(imageLiteralResourceName: "img_3"), UIImage(imageLiteralResourceName: "img_4")]

public var post1 = Post(author: NSLocalizedString("AuthorPost1", comment: ""), image: images[0], description: NSLocalizedString("DescriptionPost1", comment: ""), likes: 0, views: 900, title: "")

public var post2 = Post(author: NSLocalizedString("AuthorPost2", comment: ""), image: images[1], description: NSLocalizedString("DescriptionPost2", comment: ""), likes: 1, views: 700, title: "")

public var post3 = Post(author: NSLocalizedString("AuthorPost3", comment: ""), image: images[2], description:NSLocalizedString("DescriptionPost3", comment: ""), likes: 102, views: 200, title: "")

public var post4 = Post(author: NSLocalizedString("AuthorPost4", comment: ""), image: images[3], description: NSLocalizedString("DescriptionPost4", comment: ""), likes: 805, views: 400, title: "")

public var posts = [post1, post2, post3, post4]

public let newPost = Post(author: NSLocalizedString("AuthorNews", comment: ""), image: UIImage(), description: "", likes: 10, views: 10, title:NSLocalizedString("DescriptionNews", comment: ""))
