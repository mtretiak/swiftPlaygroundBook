/*:
 - callout(Travel): I love traveling, let it be to find coffee, view new art at MoMa San fran, or hitting the slopes in Whistler.
 */

/*:
  - Experiment: Scroll around the map and tap on the flags to see where my travels have taken me.
 */

//#-hidden-code
import MapKit
import PlaygroundSupport
//#-end-hidden-code

/// Define the size of the flags
let pinSize:             CGFloat = /*#-editable-code Define the size of the flags*/42/*#-end-editable-code*/

/// Enter a number of seconds after which the map animation starts
let animationDelay: TimeInterval = /*#-editable-code Enter a number of seconds after which the map animation starts*/2/*#-end-editable-code*/

/*:
 - Experiment: Try adding some new countries. (Eg. japan)
 */

/// Displayed places
let countries:    [MKAnnotation] = [/*#-editable-code Edit pins*/canada, france, uk, ireland, germany, italy, greece, usa, newZealand, australia, winnipeg, calgary/*#-end-editable-code*/]

//#-hidden-code

/// Enable caching to disk. Activate to create offline cache
let createCache = false

//: ## Create the map (main view)
let map = MKMapView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
/// Strong reference to the map view delegate
let delegate = MapDelegate()
delegate.cacheTiles = createCache
delegate.map = map
delegate.pinSize = pinSize
delegate.reloadTiles()
map.delegate = delegate
map.region = MKCoordinateRegionMake(canada.coordinate,
                                    MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))

map.addAnnotations(countries)
//map.addAnnotation(plane)

//: ## Configure playground
PlaygroundPage.current.liveView = map



//: ### Unzoom to global scale
Timer.scheduledTimer(withTimeInterval: animationDelay, repeats: false) { _ in
    map.showAnnotations(countries, animated: true)
}

/* Lets me know which tiles I need to set offline for an iPad Air 2 9.7” viewport
Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { _ in
    var tilesNeeded = ""
    for tile in tilesNumbersNeededForiPad97Inches {
        tilesNeeded += "\(tile.z)-\(tile.x)-\(tile.y),"
    }
    print(tilesNeeded)
    UIPasteboard.general.string = tilesNeeded
}
 */

//#-end-hidden-code
