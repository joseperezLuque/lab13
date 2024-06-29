//
//  snap.swift
//  PerezSnapchat2
//
//  Created by Jose Adriano Perez Luque on 27/06/24.
//

import Foundation
class Snap{
    var imagenURL = ""
    var descrip = ""
    var from = ""
    var id = ""
    var imagenID = ""
    var audioURL: String = ""
    var contentType: ContentType = .image
    init() {}

    enum ContentType {
           case image
           case audio
       }
}
