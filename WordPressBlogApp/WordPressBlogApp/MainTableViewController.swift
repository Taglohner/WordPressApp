//
//  MainTableViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: CoreDataTableViewController {
    
    //MARK: Properties
    
    var topRefreshControl: UIRefreshControl!
    let reachability = Reachability()!
    let coreDataStack = AppDelegate.stack
    let wordpressAPIService = APIService.sharedInstance()
    
    var page = 1
    var lastFetchTotalPages = Int()
    var lastFecthTotalPosts = Int()
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* clear data */
        coreDataStack.batchDelete(context: coreDataStack.context, entityName: "Post")
        
        /* download fresh data */
        wordpressAPIService.getPosts(page: 1, numberOfPosts: nil, save: true) { (pages, posts) in
            self.lastFetchTotalPages = pages
            self.lastFecthTotalPosts = posts
        }
        
        /* UI configuration */
        self.tableView.separatorColor = .white
        self.navigationItem.titleView = UIImageView(image: StyleKit.imageOfSwiftPadawanLogo())
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Oxygen-Light", size: 18)!], for: .normal)
        
        /* refresh control */
        topRefreshControl = UIRefreshControl()
        tableView.addSubview(topRefreshControl)
        
        /* creates a UIView to place under the status bar but above the navigation bar */
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIApplication.shared.statusBarFrame
        blurEffectView.autoresizingMask = .flexibleWidth
        UIApplication.shared.keyWindow?.addSubview(blurEffectView)
        
        /* creates a Fetch Request */
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.context, sectionNameKeyPath: "date", cacheName: nil)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if topRefreshControl.isRefreshing {
            wordpressAPIService.getPosts(page: 1, numberOfPosts: 1, save: false) { (pages,posts) in
                if posts > self.lastFecthTotalPosts {
                    self.wordpressAPIService.getPosts(page: 1, numberOfPosts: (posts - self.lastFecthTotalPosts), save: true) { (pages, posts) in
                        self.lastFecthTotalPosts = posts
                        self.lastFetchTotalPages = pages
                    }
                }
            }
            topRefreshControl.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let yOffSet = tableView.contentOffset.y
        let tableHeight = tableView.contentSize.height - tableView.frame.size.height
        let scrolledPercentage = yOffSet / tableHeight
        
        if scrolledPercentage > 0.55 && scrolledPercentage < 0.65 && page < lastFetchTotalPages {
            wordpressAPIService.getPosts(page: page + 1, numberOfPosts: nil, save: true) { (pages, posts) in
                
                /* VERIFY IF NEW POSTS ARE AVIALABLE AND NOTIFY THE USER IF SO */
                
                print(pages)
                print(posts)
                
                /* VERIFY IF NEW POSTS ARE AVIALABLE AND NOTIFY THE USER IF SO */
            }
            page += 1
        } else {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* UI configuration */
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isToolbarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = fetchedResultsController?.object(at: indexPath) as? Post, let postTitle = post.title, let postExcerpt = post.excerpt, let postImage = post.featuredImage else {
            return UITableViewCell()
        }
        
        if post.cellType == "featured" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "featuredPostCell", for: indexPath) as! FeaturedPostTableViewCell
            DispatchQueue.main.async {
                cell.featuredImage.image = UIImage(data: postImage)
                cell.titleLabel.text = postTitle
                cell.excerptLabel.text = postExcerpt
                cell.cellViewForFeaturedPost(cell: cell)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "regularPostCell", for: indexPath) as! RegularPostTableViewCell
            DispatchQueue.main.async {
                cell.postImage.image = UIImage(data: postImage)
                cell.titleLabel.text = postTitle
                cell.excerptLabel.text = postExcerpt
                cell.cellViewForRegularPost(cell: cell)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let post = fetchedResultsController?.object(at: indexPath) as? Post, let cellType = post.cellType else {
            return 0
        }
        
        if cellType == "featured" {
            return 280
        }
        else {
            return 203
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sectionName = fetchedResultsController?.sections![section].name {
            
            /* configure the blur effect */
            let blurEffect = UIBlurEffect(style: .light)
            
            /* creates the blurry view */
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 24)
            blurEffectView.autoresizingMask = .flexibleWidth
            
            /* creates the header text label */
            let headerLabel = UILabel()
            headerLabel.frame = blurEffectView.frame
            headerLabel.autoresizingMask = .flexibleWidth
            headerLabel.text = sectionName
            headerLabel.font = UIFont(name: "Oxygen-Light", size: 14)
            headerLabel.textColor = .orange
            headerLabel.textAlignment = .center
            
            /* add the label to the view */
            blurEffectView.contentView.addSubview(headerLabel)
            return blurEffectView
        }
        return nil
    }
    
    // MARK: Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationViewController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        if let selectedPost = fetchedResultsController?.object(at: indexPath) as? Post {
            destinationViewController.postID = Int(selectedPost.id)
            self.navigationController!.pushViewController(destinationViewController, animated: true)
        } else {
            return
        }
    }
    
    // MARK: Supporing methods
    
    /* observe the internet connectivity */
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    /* update data based on internet availability */
    //    func refreshDataIfOnline() {
    //
    //        reachability.whenReachable = { reachability in
    //            if reachability.connection == .wifi {
    //
    //            } else if reachability.connection == .cellular {
    //
    //            } else {
    //
    //                self.clearData()
    //                self.getPosts(page: 1, numberOfPosts: nil, save: true) { (pages, posts) in
    //                    self.lastFetchTotalPages = pages
    //                    self.lastFecthTotalPosts = posts
    //                }
    //            }
    //
    //            reachability.whenUnreachable = { _ in
    //                print("Not reachable")
    //            }
    //        }
    //    }
}


