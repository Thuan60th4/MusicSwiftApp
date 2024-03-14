//
//  MyAlbumViewController.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 01/03/2024.
//

import UIKit

class MyAlbumViewController: UIViewController {
    var myAlbums: [Album] = []

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
        placeholderView.configure(with: ActionLabelViewViewModel(text: "You dont have any album yet", actionTitle: "Browse"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        placeholderView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 100)
//        placeholderView.center = view.center
    }
        
    func updateUI(){
        if myAlbums.count > 0 {
            placeholderView.isHidden = true
            tableView.isHidden = false
        }
        else {
            placeholderView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func fetchData(){
        ApiManagers.shared.getCurrentUserAlbums { res in
            switch res {
                case .success(let album):
                    self.myAlbums = album
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.updateUI()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
}


extension MyAlbumViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension MyAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as! SongTableViewCell
        let data = myAlbums[indexPath.row]
        cell.configure(data:
                        SongCellModel(
                            name: data.name,
                            subName: nil,
                            imageUrl: URL(string: data.images.first?.url ?? ""))
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = myAlbums[indexPath.row]
    
        let albumView = AlbumViewController(album: album)
        navigationController?.pushViewController(albumView, animated: true)

    }
}
