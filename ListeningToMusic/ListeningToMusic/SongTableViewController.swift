//
//  SongTableViewController.swift
//  ListeningToMusic
//
//  Created by Xin Li on 11/19/17.
//  Copyright © 2017 Xin Li. All rights reserved.
//

import UIKit
import os.log

class SongTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved songs, otherwise load sample data.
        if let savedSongs = loadSongs() {
            songs += savedSongs
        }
        else {
            // Load the sample data.
            loadSampleSongs()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SongTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SongTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate song for the data source layout.
        let song = songs[indexPath.row]
        
        cell.nameLabel.text = song.name
        cell.photoImageView.image = song.photo
        cell.ratingControl.rating = song.rating
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            songs.remove(at: indexPath.row)
            saveSongs()
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

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new song.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let songDetailViewController = segue.destination as? SongViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedSongCell = sender as? SongTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedSongCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSong = songs[indexPath.row]
            songDetailViewController.song = selectedSong
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 
    
    // MARK: Actions
    @IBAction func unwindToSongList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SongViewController,
            let song = sourceViewController.song {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing song.
                songs[selectedIndexPath.row] = song
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new song.
                let newIndexPath = IndexPath(row: songs.count, section: 0)
                
                songs.append(song)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the songs.
            saveSongs()
        }
        
    }
    
    //MARK: Private Methods
    
    private func loadSampleSongs() {
        
        let photo1 = UIImage(named: "song1")
        let photo2 = UIImage(named: "song2")
        let photo3 = UIImage(named: "song3")

        guard let song1 = Song(name: "Havana", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate song1")
        }

        guard let song2 = Song(name: "Something Just Like This", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate song2")
        }

        guard let song3 = Song(name: "Closer", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate song3")
        }

        songs += [song1, song2, song3]
    }
    
    private func saveSongs() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(songs, toFile: Song.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Songs successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save songs...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSongs() -> [Song]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Song.ArchiveURL.path) as? [Song]
    }

}
