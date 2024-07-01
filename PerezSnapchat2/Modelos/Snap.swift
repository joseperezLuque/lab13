import CoreLocation
class Snap {
    var imagenURL = ""
    var descrip = ""
    var from = ""
    var id = ""
    var imagenID = ""
    var audioURL = ""
    var audioTitle = ""
    var locationURL = ""
    var contentType: ContentType = .image // Por defecto, contentType es .image

    

    enum ContentType {
        case image
        case audio
    }
}
