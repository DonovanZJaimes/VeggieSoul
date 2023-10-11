//
//  Media.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//
//MARK: INFO:
/*Creacion del modelo de la info que ocuparan el mensaje que tenga una imagen */


import Foundation
import UIKit
import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
