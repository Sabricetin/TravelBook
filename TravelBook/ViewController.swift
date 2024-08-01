//
//  ViewController.swift
//  TravelBook
//
//  Created by Sabri Çetin on 16.05.2024.
//
import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var commendTxt: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var selectedTitle = ""
    var selectedİd : UUID?
    
    var annatationTitle = ""
    var annatationSubtitle = ""
    var anatationLatitude = Double()
    var anatationLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Kullanıcının Yerini Tespit Etme
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Kullanıcı Yerini Haritada İşaretleyebilme
        
        let gesturRecogizer =  UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gesturRecognizer:)))
        
        gesturRecogizer.minimumPressDuration = 2
        mapView.addGestureRecognizer( gesturRecogizer)
        
        if selectedTitle != "" {
            
            //CoreData
            
            //Seçilen Konumu Haritada Gösterme
            let appDelgete = UIApplication.shared.delegate as! AppDelegate
            let context = appDelgete.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            let idString = selectedİd!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(fetchRequest)
                if result.count > 0 {
                    for result in result as! [NSManagedObject]{
                        
                    if let title = result.value(forKey: "tittle") as? String {
                        annatationTitle = title
                        
                        if let subtitle = result.value(forKey: "subtitle") as? String {
                            annatationSubtitle = subtitle
                            
                            if let latitude = result.value(forKey: "latitude") as? Double {
                                anatationLatitude = latitude
                                
                                if let longitude = result.value(forKey: "longitude") as? Double {
                                    anatationLongitude = longitude
                        
                        let annatation = MKPointAnnotation()
                        annatation.title = annatationTitle
                        annatation.subtitle = annatationSubtitle
                        let coordinate = CLLocationCoordinate2D(latitude: anatationLatitude, longitude: anatationLongitude)
                        
                        annatation.coordinate = coordinate
                        
                        mapView.addAnnotation(annatation)
                        nameTxt.text = annatationTitle
                        commendTxt.text = annatationSubtitle
                                    
                        locationManager.stopUpdatingLocation()
                                    
                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        mapView.setRegion(region, animated: true)
                                }
                            }
                        }
                    }
                }
                }
            }
            catch {
                print ("error!!!")
            }
        } else {
            //Add New Data
        }
    }
    
    @objc func chooseLocation (gesturRecognizer:UILongPressGestureRecognizer) {
        
        if gesturRecognizer.state == .began {
            
            let touchPoint = gesturRecognizer.location(in: self.mapView)
            let touchCordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchCordinate.latitude
            chosenLongitude = touchCordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCordinate
            annotation.title = nameTxt.text
            annotation.subtitle = commendTxt.text
            self.mapView.addAnnotation(annotation)
        }
    }
        //Kullanıcının Yerini Haritada Zoomlama
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        if selectedTitle == "" {
            let location = CLLocationCoordinate2D(latitude:  locations [0].coordinate.latitude , longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true) }
        else {
            //
        }
    }
    //Annatation Özelleşitrme Pini Özelleşitrme
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if annotation is MKUserLocation {
                return nil
            }
            let reuseId = "myAnnotation"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            
            if pinView == nil {
                pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
                pinView?.tintColor = UIColor.blue
                
                let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
                pinView?.rightCalloutAccessoryView = button
                
            } else {
                pinView?.annotation = annotation
            }
            return pinView
        }
    //Navigasyonu Açma
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if selectedTitle != "" {
            
            let requestLocation = CLLocation(latitude: anatationLatitude, longitude: anatationLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks , error) in
            
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.annatationTitle
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    // Konumu Haritada Üzerinde Girilen Texti Gösterip Kaydetme
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        
        newPlace.setValue(nameTxt.text, forKey: "tittle")
        newPlace.setValue(commendTxt.text, forKey: "subtitle")
        newPlace.setValue( chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print ("Success!!!")
        } catch{
            print ("Error!!!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
        navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
}
