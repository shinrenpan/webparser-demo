//
//  ComicListVC.swift
//
//  Created by Shinren Pan on 2024/4/9.
//

import Combine
import UIKit

final class ComicListVC: UIViewController {
    private let vo = ComicListVO()
    private let vm = ComicListVM()
    private let router = ComicListRouter()
    private var binding: Set<AnyCancellable> = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setupBinding()
        setupVO()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        doLoadData()
    }
}

// MARK: - Private

private extension ComicListVC {
    // MARK: Setup Something

    func setupSelf() {
        view.backgroundColor = vo.mainView.backgroundColor
        navigationItem.title = "更新列表"
        router.vc = self
    }

    func setupBinding() {
        vm.$state.receive(on: DispatchQueue.main).sink { [weak self] state in
            if self?.viewIfLoaded?.window == nil { return }

            switch state {
            case .none:
                self?.stateNone()
            case .dataLoaded:
                self?.stateDataLoaded()
            case .dataFailure:
                self?.stateDataFailure()
            }
        }.store(in: &binding)
    }

    func setupVO() {
        view.addSubview(vo.mainView)
        NSLayoutConstraint.activate([
            vo.mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vo.mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            vo.mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            vo.mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        vo.list.dataSource = self
        vo.list.refreshControl = .init(frame: .zero)
        vo.list.refreshControl?.addTarget(self, action: #selector(doLoadData), for: .valueChanged)
    }

    // MARK: - Handle State

    func stateNone() {}
    
    func stateDataLoaded() {
        vo.list.reloadData()
        vo.list.refreshControl?.endRefreshing()
    }
    
    func stateDataFailure() {
        vo.list.refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "錯誤!", message: "爬取錯誤", preferredStyle: .alert)
        alert.addAction(.init(title: "確定", style: .destructive))
        present(alert, animated: true)
    }
    
    // MARK: - Do Something
    
    @objc func doLoadData(_ sender: UIRefreshControl? = nil) {
        if sender == nil {
            vo.list.setContentOffset(.zero, animated: true)
            vo.list.refreshControl?.beginRefreshing()
        }
        
        vm.doAction(.loadData)
    }
}

// MARK: - UITableViewDataSource

extension ComicListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.model.comics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let comic = vm.model.comics[indexPath.row]
        cell.textLabel?.text = comic.title
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
}
