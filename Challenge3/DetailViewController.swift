//
//  ViewController.swift
//  Challenge3
//
//  Created by Mikhail Strizhenov on 29.04.2020.
//  Copyright © 2020 Mikhail Strizhenov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var note = UITextView()
    var indexOfNote: Int?
    var noteText: String!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        
        note.bounds = view.bounds
        note.translatesAutoresizingMaskIntoConstraints = false
        note.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(note)
        
        NSLayoutConstraint.activate([
            note.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            note.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            note.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            note.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteText = note.text
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            guard note.text != "" else { return }
            var notes: [Note]?
            if let savedNotes = UserDefaults.standard.object(forKey: "notes") as? Data {
                notes = try? JSONDecoder().decode([Note].self, from: savedNotes)
            } else {
                notes = [Note]()
            }
            let title = note.text.components(separatedBy: "\n").first!
            let noteToSave = Note(title: title, body: note.text, date: Date())
            if let index = indexOfNote {
                if noteText != note.text {
                    notes?.remove(at: index)
                    notes?.insert(noteToSave, at: 0)
                }
            } else {
                notes?.insert(noteToSave, at: 0)
            }
            let savedData = try? JSONEncoder().encode(notes)
            UserDefaults.standard.set(savedData, forKey: "notes")
        }
    }
    
    @objc func shareNote() {
        guard note.text != "" else { return }
        let vc = UIActivityViewController(activityItems: [note.text!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
        present(vc, animated: true)
    }

}

