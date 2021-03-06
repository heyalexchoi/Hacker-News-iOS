//
//  ViewController.swift
//  HackerNews
//
//  Created by alexchoi on 4/9/15.
//  Copyright (c) 2015 Alex Choi. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {
    
    fileprivate var page = 1
    fileprivate let storiesViewController = StoriesTableViewController()
    fileprivate let storiesType: StoriesType
    
    // MARK: - UIViewController
    
    init(type: StoriesType) {
        storiesType = type
        super.init(nibName: nil, bundle: nil)
        title = storiesType.title
    }

    required init?(coder aDecoder: NSCoder) {
        storiesType = .News
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(storiesViewController)
        view.addSubviewsWithAutoLayout(storiesViewController.view)
        _ = storiesViewController.view.anchorAllEdgesToView(view)
        storiesViewController.didMove(toParent: self)
        
        getStories(showHUD: true)
        
        storiesViewController.addPullToRefresh { [weak self] in
            self?.getStories()
        }
        storiesViewController.addInfiniteScroll { [weak self] in
            guard let self = self else {
                return
            }
            self.getStories(page: self.page)
        }
    }
}

// MARK: - Stories

extension StoriesViewController {
    
    func getStories(page: Int = 1, scrollToTop: Bool = false, showHUD: Bool = false) {
        let appendStories = page == 1 ? false : true
        if showHUD {
            storiesViewController.showHUD()
        }
        DataSource.getStories(withType: storiesType, page: page)
        .then { [weak self] (stories) -> Void in
            self?.storiesViewController.loadStories(stories, appendStories: appendStories, scrollToTop: scrollToTop, showHUD: showHUD)
            self?.page = page + 1
        }
        .catch { (error) in
            ErrorController.showErrorNotification(error)
        }
    }
}
