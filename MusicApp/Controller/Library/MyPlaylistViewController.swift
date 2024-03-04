//
//  MyPlaylistViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 01/03/2024.
//

import UIKit

class MyPlaylistViewController: UIViewController {
    var playlist: [Playlist] = []
    
    let placeholderView = ActionLabelPlaceholderView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholderView()
        
    }
    
    private func setupPlaceholderView(){
        placeholderView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        fetchData()
        view.addSubview(placeholderView)
        view.addSubview(tableView)
        
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        placeholderView.configure(with: ActionLabelViewViewModel(text: "You dont have any playlist yet", actionTitle: "Create"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        placeholderView.frame = CGRect(x: 0, y: 0, width: 150, height: 100)
        placeholderView.center = view.center
    }
    
    func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name.",
            preferredStyle: .alert
        )
        var textFieldStore: UITextField?
        
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
            textFieldStore = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { alertAction in
            guard let text = textFieldStore?.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                    return
                }
            ApiManagers.shared.createUserPlaylist(with: text) { isSuccess in
                if isSuccess {
                    self.fetchData()
                }
            }
            
        }))
        
        present(alert, animated: true)
    }
    
    func updateUI(){
        if playlist.count > 0 {
            placeholderView.isHidden = true
            tableView.isHidden = false
        }
        else {
            placeholderView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func fetchData(){
        ApiManagers.shared.getUserPlaylist { playlist in
            if let playlist = playlist {
                self.playlist = playlist
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateUI()
                }
            }
        }
    }
    
}


extension MyPlaylistViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton() {
        showCreatePlaylistAlert()
    }
}


extension MyPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as! SongTableViewCell
        let data = playlist[indexPath.row]
        cell.configure(data:
                        SongCellModel(
                            name: data.name,
                            subName: nil,
                            imageUrl: URL(fileURLWithPath: ""))
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
