//
//  ComicListModels.swift
//
//  Created by Shinren Pan on 2024/4/9.
//

import UIKit

enum ComicListModels {}

// MARK: - Action

extension ComicListModels {
    enum Action {
        case loadData
    }
}

// MARK: - State

extension ComicListModels {
    enum State {
        case none
        case dataLoaded
        case dataFailure
    }
}

// MARK: - Other Model for DisplayModel

extension ComicListModels {
    struct Comic: Decodable {
        let title: String
    }
}

// MARK: - Display Model for ViewModel

extension ComicListModels {
    final class DisplayModel {
        var comics: [Comic] = []
    }
}
