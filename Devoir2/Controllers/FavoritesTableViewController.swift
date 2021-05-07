//
//  FavoritesTableViewController.swift
//  Devoir2
//
//  Created by Mac11 on 2021-05-06.
//

import UIKit
import AVFoundation
/*
class FavoritesTableViewCell: UITableViewCell {
    var road: Road?
    
    @IBOutlet weak var label: UILabel!
    @IBAction func deleteRoad(_ sender: Any) {
        let dao = FavoriteDAO()
        dao.remove(email: connectedUser, road: road!)
    }
    
}*/

class FavoritesTableViewController: UITableViewController {
    var audioPlayer = AVQueuePlayer()
    
    @IBOutlet weak var audioProgress: UIProgressView!
    @IBAction func playPause(_ sender: Any) {
        if audioPlayer.rate > 0 {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    let dao = FavoriteDAO()
    var roads: [Road]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRoads()
        getSounds()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
    }
    
    func getRoads() {
        roads = dao.getRoadsByEmail(email: connectedUser)
    }
    
    func getSounds() {
        audioPlayer = AVQueuePlayer()
        for road in roads! {
            let array = road.audio?.components(separatedBy: ".")
            audioPlayer.insert(AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: array![0], ofType: array![1])!)), after: nil)
        }
    }

    @objc func updateAudioProgressView()
    {
            if self.audioPlayer.rate > 0
            {
                // Update progress
                if self.audioPlayer.currentItem != nil {
                    self.audioProgress.setProgress(Float(self.audioPlayer.currentItem!.currentTime().seconds/self.audioPlayer.currentItem!.duration.seconds), animated: true)
                }
            }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roads!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)

        cell.textLabel!.text = roads![indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dao.remove(email: connectedUser, road: roads![indexPath.row])
            roads?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRoads()
        getSounds()
        self.tableView.reloadData()
    }
}
