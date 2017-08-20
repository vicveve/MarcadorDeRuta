//
//  ViewController.swift
//  MarcadorDeRuta
//
//  Created by Victor Ernesto Velasco Esquivel on 19/08/17.
//  Copyright © 2017 Victor Ernesto Velasco Esquivel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var lstCoordenadas = Array<CLLocationCoordinate2D>()
    var distanciaTotal : Double = 0
    var distanciaPin : Double = 0
    
    @IBOutlet weak var selector: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
       
       // punto.latitude =
        
       
        
        //Centrado posicion actual
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = manager.location!.coordinate.latitude
        punto.longitude = manager.location!.coordinate.longitude
        mapa.centerCoordinate = punto
        let span = MKCoordinateSpanMake(0.015, 0.015)
               let region = MKCoordinateRegion(center: punto, span: span)
        mapa.setRegion(region, animated: false)
        let pin = MKPointAnnotation()
        pin.title =  "(\(punto.latitude), \(punto.longitude))"
        print("Punto nuevo : (\(punto.latitude),\(punto.longitude))")
        lstCoordenadas.append(punto)

        pin.coordinate = punto
        
        var colocaPin : Bool = false
        
        if lstCoordenadas.count == 1{
            pin.subtitle = "Distancia recorrida = 0.0 "
            colocaPin = true
        }
        else if lstCoordenadas.count > 1
        {
            let elementos = lstCoordenadas.count
            let p1 = lstCoordenadas[elementos - 1]
            let p2 = lstCoordenadas[elementos - 2]
            let c1 = CLLocation(latitude: p1.latitude, longitude: p1.longitude)
            let c2 = CLLocation(latitude: p2.latitude, longitude: p2.longitude)
            let distancia = c1.distance(from: c2)
            print("Distancia entre C1 y C2 \(distancia)")
            distanciaTotal = distanciaTotal + distancia
            distanciaPin = distanciaPin + distancia
            print("Distancia total \(distanciaTotal)")
            let stD = String(format: "%.2f", distanciaTotal)
            pin.subtitle = "Distancia recorrida = \(stD) "
            
            if distanciaPin > 50
            {
                colocaPin = true
                distanciaPin = 0
            }
            
            /*let lstMapa = mapa.annotations.count
            if lstMapa > 0
            {
                print("Pines totales :  \(lstMapa)")
                //Buscamos el ultimo punto en el mapa
                let item = mapa.annotations[lstMapa - 1]
                print("Ultimo pin del mapa  \(item.coordinate.latitude) , \(item.coordinate.longitude)")
                let c0 = CLLocation(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
                print("Coordenadas C1  \(c1.coordinate.latitude) , \(c1.coordinate.longitude)")
                let disAgrega = c0.distance(from: c1)
                print("Distancia elemento ultimo mapa  \(disAgrega)")
                print(disAgrega)
                if disAgrega > 50
                {
                    colocaPin = true
                }
                

            }*/
            

            
        }
        
        
        
        if colocaPin
        {
            mapa.addAnnotation(pin)
            print("Se agrega PIN")
        }
        
        
        print("------------------------------------------------")
        print("------------------------------------------------")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
           
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }

  
    
  
    @IBAction func Vista(_ sender: Any) {
        switch selector.selectedSegmentIndex {
        case 0:
            mapa.mapType = MKMapType.standard
            break
        case 1:
            mapa.mapType = MKMapType.satellite
            break
        case 2:
            mapa.mapType = MKMapType.hybrid
            break
        default:
            mapa.mapType = MKMapType.standard
            break
            
        }

    }

}

