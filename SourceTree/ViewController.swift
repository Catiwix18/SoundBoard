//
//  ViewController.swift
//  SourceTree
//
//  Created by Katherine Quispe Arias on 26/06/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tablaGrabaciones: UITableView!
    
    var grabaciones:[Grabacion] = []
    var reproducirAudio:AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaGrabaciones.dataSource=self
        tablaGrabaciones.delegate=self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            grabaciones = try context.fetch(Grabacion.fetchRequest())
            tablaGrabaciones.reloadData()
        }catch{}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grabaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        cell.detailTextLabel?.text = formatTimeInterval(grabacion.duracion)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do{
            reproducirAudio = try AVAudioPlayer (data: grabacion.audio! as Data)
            reproducirAudio?.play()
        }catch{}
        tablaGrabaciones.deselectRow(at: indexPath, animated: true)
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            let grabacion = grabaciones[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(grabacion)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                grabaciones = try context.fetch(Grabacion.fetchRequest())
                tablaGrabaciones.reloadData()
            }catch{}
        }
    }
    
    
}

