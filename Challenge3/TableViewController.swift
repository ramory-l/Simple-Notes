//
//  TableViewController.swift
//  Challenge3
//
//  Created by Mikhail Strizhenov on 29.04.2020.
//  Copyright © 2020 Mikhail Strizhenov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var notes = [Note]()
    let cellId = "Note"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedNotes = UserDefaults.standard.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch let error {
                let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailViewController()
        dvc.note.text = notes[indexPath.row].body
        dvc.indexOfNote = indexPath.row
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func addNote() {
        let dvc = DetailViewController()
        navigationController?.pushViewController(dvc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        do {
            let savedData = try jsonEncoder.encode(notes)
            UserDefaults.standard.set(savedData, forKey: "notes")
        } catch let error {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
}
