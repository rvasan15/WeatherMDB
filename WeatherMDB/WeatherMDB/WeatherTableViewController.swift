//
//  WeatherTableViewController.swift
//  WeatherMDB
//
//  Created by Rini Vasan on 3/10/20.
//  Copyright © 2020 Rini Vasan. All rights reserved.
//

import UIKit
import CoreLocation

var date: Date? = nil

class WeatherTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
  
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func changeDatePressed(_ sender: Any) {
        performSegue(withIdentifier: "toChangeDate", sender: self)
    }
    var locationManager = CLLocationManager()
    
    var forecastData = [Weather]()
    
    var firstTimeOpened = 1
        
    var userLocation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        searchBar.delegate = self
                
        updateWeatherForLocation(location: "New York")
        
        tableView.tableFooterView = UIView()
        
        if firstTimeOpened == 1 {
            weather(self)
            firstTimeOpened += 1
        }
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userLocation != nil {
            updateWeatherForLocation(location: userLocation)
        }
        else {
            updateWeatherForLocation(location: "New York")
        }
    }
    
    func weather(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print ("Authorized")
                let lat = locationManager.location?.coordinate.latitude
                let long = locationManager.location?.coordinate.longitude
                let location = CLLocation(latitude: lat!, longitude: long!)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                    if error != nil {
                        return
                    } else if let country = placemarks?.first?.country,
                        let city = placemarks?.first?.locality {
                        print(country)
                        print(city)
                        
                        let weatherGetter = self.updateWeatherForLocation(location: city)
                    }
                } )
                break
            case .notDetermined, .restricted, .denied:
                print("Error: Either Not Determined, Restricted, or Denied.")
                break
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text,
            !locationString.isEmpty {
            userLocation = locationString
            date = nil
            updateWeatherForLocation(location: locationString)
        }
    }

    func updateWeatherForLocation (location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error: Error?) in
            if error == nil {
                if let date = date {
                    //print(self.date)
                if let location = placemarks?.first?.location {
    
                    Weather.forecast(withLocation: location.coordinate, date: Int(date.timeIntervalSince1970), completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        
                    })
                    }
                }
                else {
                    if let location = placemarks?.first?.location {
                
                    Weather.forecast(withLocation: location.coordinate, date: 0, completion: { (results:[Weather]?) in
                                if let weatherData = results {
                                    self.forecastData = weatherData
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25)) //set these values as necessary
            returnedView.backgroundColor = .black

        let label = UILabel(frame: CGRect(x: 10, y: 3, width: view.frame.size.width, height: 25))

         var filteredDate: Date!
              if let date = date {
                  filteredDate = Calendar.current.date(byAdding: .day, value: section, to: date)
              }
              else {
                  filteredDate = Calendar.current.date(byAdding: .day, value: section, to: Date())
              }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        label.text = dateFormatter.string(from: filteredDate)
        label.textColor = .white
        returnedView.addSubview(label)

        return returnedView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weatherObject = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        cell.imageView?.image = imageWithImage(image: UIImage(named: weatherObject.icon)!, scaledToSize: CGSize(width: 50, height: 50))
        
        return cell
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
   


}
