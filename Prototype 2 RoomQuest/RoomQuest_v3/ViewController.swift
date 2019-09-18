//
//  ViewController.swift
//  RoomQuest_v3
//
//  Created by Steven Tang  on 1/26/17.
//  Copyright © 2017 Steven Tang . All rights reserved.
// Web Map Link: http://www.arcgis.com/home/webmap/viewer.html?webmap=d5ef78cbe5f64454a15cc967db011635
// MapServer: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/CSUSBCAMPUS/MapServer"
// self.portal = AGSPortal(url: NSURL(string: "http://www.arcgis.com")! as URL, loginRequired: false) 
// ONLY IF WE USE URL
// CSUSB COORDINATES: 34.181229, -117.323006
// Social & behavioral Geocode: http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SBLocator/GeocodeServer
// JB Geocode: http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/ThirdFloorLocator/GeocodeServer


import UIKit
import ArcGIS
import CoreLocation


//Initialize feature layers
let firstFloor = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/2")! as URL))
let firstRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/6") as! URL))
let secondFloor = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/12")! as URL))
let secondRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/13") as! URL))
let thirdFloor = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/3")! as URL))
let thirdRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/7") as! URL))
let fourthFloor = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/10")! as URL))
let fourthRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/11")! as URL))
let fifthFloor = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/5")! as URL))
let fifthRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/9")! as URL))
let basementFloors = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/4")! as URL))
let basementRooms = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/8") as! URL))
let bikes = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/CSUSBCAMPUS/MapServer/35") as! URL))
let firstAid = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/1") as! URL))
let atm = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/CSUSBCAMPUS/MapServer/33") as! URL))
let restroom = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/SecondPrototype/MapServer/0") as! URL))
let evacuation = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/CSUSBCAMPUS/MapServer/38") as! URL))
let food = AGSFeatureLayer(featureTable: AGSServiceFeatureTable(url: NSURL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/CSUSBCAMPUS/MapServer/32") as! URL))
let locatorURL = "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/ThirdFloorLocator/GeocodeServer"
let params = AGSGeocodeParameters()

class ViewController: UIViewController, AGSGeoViewTouchDelegate, UISearchBarDelegate{
    
    var map:AGSMap!
    var portal:AGSPortal!
    var basemap = AGSBasemap()
    var locatorTask:AGSLocatorTask!
    var userSearch = ""
    var graphicsOverlay:AGSGraphicsOverlay!
    var poi = ""
    @IBOutlet weak var mapView: AGSMapView!
    @IBOutlet weak var popUpFloors: UIView!
    @IBOutlet weak var popUpSearch: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DISMISSES KEYBOARD WHEN CLICKED SCREEN
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Makes popupfloors AND search rounded
        popUpFloors.layer.cornerRadius = 10
        popUpSearch.layer.cornerRadius = 5
        
        //Initilize where our map would pan to
        
        self.map = AGSMap(basemapType: AGSBasemapType.topographic,
                          latitude: 34.181229,
                          longitude: -117.323006,
                          levelOfDetail: 16)

        //display map onto screen
        self.mapView.map = self.map
        self.mapView.touchDelegate = self
    
        
        //instantiate the graphicsOverlay and add to the map view
        self.graphicsOverlay = AGSGraphicsOverlay()
        self.mapView.graphicsOverlays.add(self.graphicsOverlay)
        self.locatorTask = AGSLocatorTask(url: URL(string: "http://roomquest.research.cse.csusb.edu:6080/arcgis/rest/services/ThirdFloorLocator/GeocodeServer")!)

        
        //NEEDED FOR SEARCHBAR
        searchBar.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Search Bar Touch Gestures
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.text = ""
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.65, animations: {
            self.popUpSearch.alpha = 0
        })
        userSearch = searchBar.text!
        searchBar.text = ""
        //Removes previous searches
        self.graphicsOverlay.graphics.removeAllObjects()
        runSearch()
    }
    
    
    // The following are the code to make the search work
    
    //Calls Geocode Function
    func runSearch(){
        self.geocodePOIs(userSearch, location: self.mapView.locationDisplay.mapLocation, extent: nil)
    }
    
    //Searches geocode database for user point of interest
    func geocodePOIs(_ poi:String, location:AGSPoint?, extent:AGSGeometry?) {
        //parameters for geocoding POIs
        let params = AGSGeocodeParameters()
        params.preferredSearchLocation = location
        params.searchArea = extent
        params.outputSpatialReference = self.mapView.spatialReference
        params.resultAttributeNames.append(contentsOf: ["*"])
        
        
        //geocode using the search text and params
        self.locatorTask.geocode(withSearchText: userSearch, parameters: params) { [weak self] (results:[AGSGeocodeResult]?, error:Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self?.handleGeocodeResultsForPOIs(results, areExtentBased: (extent != nil))
            }
        }
    }
    
    //Pans to User Point of Interest
    func zoomToGraphics(_ graphics:[AGSGraphic]) {
        if graphics.count > 0 {
            let multipoint = AGSMultipointBuilder(spatialReference: graphics[0].geometry!.spatialReference)
            for graphic in graphics {
                multipoint.points.add(graphic.geometry as! AGSPoint)
            }
            self.mapView.setViewpoint(AGSViewpoint(targetExtent: multipoint.extent))
            //Add zooming??
        }
    }
    
    //Function that handles what the geocode server returns
    func handleGeocodeResultsForPOIs(_ geocodeResults:[AGSGeocodeResult]?, areExtentBased:Bool) {
        // If it returns a valid result, it adds graphic to the map and zooms to the location
        // else, prints out that the user's input not found.
        if let results = geocodeResults , results.count > 0 {
            //show the graphics on the map
            for result in results {
                let graphic = self.graphicForPoint(result.displayLocation!, attributes: result.attributes as [String : AnyObject]?)
                
                self.graphicsOverlay.graphics.add(graphic)
                if (Int(userSearch)! > 300){
                    self.map.operationalLayers.add(thirdFloor)
                    self.map.operationalLayers.add(thirdRooms)
                }
                self.zoomToGraphics(self.graphicsOverlay.graphics as AnyObject as! [AGSGraphic])
            }
        }
        else {
            //show alert for no results
            print(userSearch + " not found.")
            
        }
    }
    
    //Constructs icon for point of interest
    func graphicForPoint(_ point: AGSPoint, attributes:[String:AnyObject]?) -> AGSGraphic {
        let markerImage = UIImage(named: "poi_icon")!
        let symbol = AGSPictureMarkerSymbol(image: #imageLiteral(resourceName: "poi_icon"))
        symbol.leaderOffsetY = markerImage.size.height/2
        symbol.offsetY = markerImage.size.height/2
        let graphic = AGSGraphic(geometry: point, symbol: symbol, attributes: attributes)
        return graphic
    }
    
    //Calls this function when the tap is recognized. Dismisses Keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //When current location button is pressed, this function runs. Returns current location
    func startLocationDisplay(autoPanMode:AGSLocationDisplayAutoPanMode) {
        self.mapView.locationDisplay.autoPanMode = autoPanMode
        self.mapView.locationDisplay.start { (error:Error?) -> Void in
            if error != nil {
            }
        }
    }
    
    //current location button
    @IBAction func location_btn(_ sender: Any) {
        self.startLocationDisplay(autoPanMode: AGSLocationDisplayAutoPanMode.recenter)
    }

    // POP UP FLOOR CODE
    @IBAction func showPopUpFloors(_ sender: Any){
        UIView.animate(withDuration: 0.65, animations: {
            self.popUpFloors.alpha = 1
            self.popUpSearch.alpha = 0;
        })
    }
    @IBAction func closePopUpFloors(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.popUpFloors.alpha = 0
        })
    }
    @IBAction func showBasement(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(basementFloors)
            self.map.operationalLayers.add(basementRooms)
            self.popUpFloors.alpha = 0
            
        })
    }
    @IBAction func showFirstFloor(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(firstFloor)
            self.map.operationalLayers.add(firstRooms)
            self.popUpFloors.alpha = 0
        })
    }
    @IBAction func showSecondFloor(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(secondFloor)
            self.map.operationalLayers.add(secondRooms)
            self.popUpFloors.alpha = 0
        })
    }
    
    @IBAction func showThirdFloor(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(thirdFloor)
            self.map.operationalLayers.add(thirdRooms)
            self.popUpFloors.alpha = 0
        })
    }
 
    @IBAction func showFourthFloor(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(fourthFloor)
            self.map.operationalLayers.add(fourthRooms)
            self.popUpFloors.alpha = 0
        })
    }
    @IBAction func showFifthFloor(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(fifthFloor)
            self.map.operationalLayers.add(fifthRooms)
            self.popUpFloors.alpha = 0
        })
    }
    
    
    // POPUPVIEWSEARCH FUNCTIONS
    @IBAction func showPopUpSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.popUpSearch.alpha = 1
            self.popUpFloors.alpha = 0
        })
    }
    
    @IBAction func closePopUpSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.popUpSearch.alpha = 0
        })
    }
    @IBAction func showBikes(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(bikes)
            self.popUpSearch.alpha = 0
        })
    }
    
    @IBAction func showFirstAid(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(firstAid)
            self.popUpSearch.alpha = 0
        })
    }
    
    @IBAction func showATM(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(atm)
            self.popUpSearch.alpha = 0
        })
    }
    @IBAction func showEvacuation(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(evacuation)
            self.popUpSearch.alpha = 0
        })
    }
    @IBAction func showFood(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(food)
            self.popUpSearch.alpha = 0
        })
    }
    @IBAction func showRestrooms(_ sender: Any) {
        UIView.animate(withDuration: 0.65, animations: {
            self.map.operationalLayers.removeAllObjects()
            self.graphicsOverlay.graphics.removeAllObjects()
            self.map.operationalLayers.add(firstFloor)
            self.map.operationalLayers.add(firstRooms)
            self.map.operationalLayers.add(restroom)
            self.popUpSearch.alpha = 0
        })
    }
 
}
