//
//  Imageable.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/2/21.
//

import Foundation
import UIKit
import Siesta

protocol Imageable {
    var imageURL: String? { get set }
    var imageResource: Resource? { get set }
    var image: UIImage? { get set }
}
