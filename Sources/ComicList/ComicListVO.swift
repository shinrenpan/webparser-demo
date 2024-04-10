//
//  ComicListVO.swift
//
//  Created by Shinren Pan on 2024/4/9.
//

import UIKit

final class ComicListVO {
    let mainView = UIView(frame: .zero)
    let list = UITableView(frame: .zero, style: .plain)
    
    init() {
        setupSelf()
        addViews()
    }
}

// MARK: - Private

private extension ComicListVO {
    // MARK: Setup Something
    
    func setupSelf() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .white
        
        list.translatesAutoresizingMaskIntoConstraints = false
        list.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Add Something
    
    func addViews() {
        mainView.addSubview(list)
        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: mainView.topAnchor),
            list.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            list.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            list.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
        ])
    }
}
