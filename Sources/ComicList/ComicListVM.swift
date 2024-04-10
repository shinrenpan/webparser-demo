//
//  ComicListVM.swift
//
//  Created by Shinren Pan on 2024/4/9.
//

import Combine
import UIKit
import WebParser

final class ComicListVM {
    @Published private(set) var state = ComicListModels.State.none
    private(set) var model = ComicListModels.DisplayModel()
    lazy var parser = makeParser()
}

// MARK: - Public

extension ComicListVM {
    func doAction(_ action: ComicListModels.Action) {
        switch action {
        case .loadData:
            actionLoadData()
        }
    }
}

// MARK: - Private

private extension ComicListVM {
    // MARK: Handle Action
    
    func actionLoadData() {
        Task {
            do {
                let result = try await parser.start()
                try loadDataResult(result)
                state = .dataLoaded
            }
            catch {
                state = .dataFailure
            }
        }
    }
    
    // MARK: Handle Result
    
    func loadDataResult(_ result: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: result)
        model.comics = try JSONDecoder().decode([ComicListModels.Comic].self, from: data)
    }
    
    // MARK: - Make Something
    
    func makeParser() -> Parser {
        let configuration = ParserConfiguration(
            request: makeRequest(),
            windowSize: makeWindowSize(),
            customUserAgent: makeUserAgent(),
            retryCount: 10,
            retryDuration: 3,
            javascript: makeJS()
        )
        
        return .init(parserConfiguration: configuration)
    }
    
    func makeRequest() -> URLRequest {
        URLRequest(url: .init(string: "https://www.manhuagui.com/update/")!)
    }
    
    func makeWindowSize() -> CGSize {
        .init(width: 1920, height: 1080)
    }
    
    func makeUserAgent() -> String {
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.5 Safari/605.1.15"
    }
    
    func makeJS() -> String {
        return """
        var results = [];
        var list = $('.latest-list > ul > li');
        list.each(function() {
        var comic = new Object();
        comic.title = $(this).find('a').eq(0).attr('title');
        results.push(comic);
        });
        results;
        """
    }
}
