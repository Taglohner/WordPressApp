//
//  MainTableViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class MainTableViewController: CoreDataTableViewController {
    
    //MARK: Properties
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        /* UI Configuration */
        
        self.tableView.separatorColor = .white
        
        /* creates a fetch request */
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        

    }

    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as! MainTableViewCell
        
        if let post = fetchedResultsController?.object(at: indexPath) as? Post {
            if post.featuredImage == nil {
                cell.postImage.image = UIImage(named: "placeholder")
            } else {
                DispatchQueue.main.async {
                    cell.postImage.image = UIImage(data: post.featuredImage!)
                }
            }
            cell.configureCellLayout(post: post)
        }
        return cell
    }
    
    /*  PENDING IMPLEMENTATION */
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // MARK: Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPost = fetchedResultsController?.object(at: indexPath) as! Post
        let destinationViewController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        destinationViewController.postID = selectedPost.id
        self.navigationController!.pushViewController(destinationViewController, animated: true)
        
    }
    
    // MARK: Supporing methods
    
    /* get new posts from WordPress */
    func getNewPosts() {
        RequestWordPressData.sharedInstance().getPostsFromWordPress { (result) in
            switch result {
            case .Success(let data):
                self.saveInCoreDataWith(array: data)
            case .Error(let error):
                print(error)
            }
        }
    }
    
    /* observe the internet connectivity */
    func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            print("Online")
        } else {
            print("Internet connection appears to be offline")
        }
    }
    
    /* update data based on internet availability */
    func updateData() {
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if reachability.isReachable {
                    self.clearData()
                    self.getNewPosts()
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("Internet is not reachable")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    /* creates a NSManagedObject from a PostObject */
    private func createPhotoEntityFrom(object: PostObject) -> NSManagedObject? {
        let context = AppDelegate.stack.context
        if let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as? Post {
            
            postEntity.type = object.type
            postEntity.id = Int32(object.id)
            postEntity.title = object.title
            postEntity.date = object.date
            postEntity.modified = object.modified
            postEntity.link = object.link
            postEntity.content = object.content
            postEntity.excerpt = object.excerpt
            postEntity.featuredImageURL = object.imageURL
            
            if let photoURL = postEntity.featuredImageURL {
                RequestWordPressData.sharedInstance().imageDataFrom(photoURL) { (result) in
                    
                    switch result {
                    case .Success(let imageData):
                        
                        DispatchQueue.main.async {
                            postEntity.featuredImage = imageData
                            AppDelegate.stack.save()
                        }
                    case .Error(let error):
                        print(error)
                    }
                }
            }
            return postEntity
        }
        return nil
    }
    
    /* save objects to core data after converting to a managed onject */
    private func saveInCoreDataWith(array: [PostObject]) {
        for object in array {
            
            _  = createPhotoEntityFrom(object: object)
            AppDelegate.stack.save()
        }
    }
    
    /* clear the data base data */
    private func clearData() {
        do {
            let context = AppDelegate.stack.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            do {
                if let fetchedObjects  = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    for object in fetchedObjects {
                        context.delete(object)
                    }
                    AppDelegate.stack.save()
                } else {
                    print("Error fetching objects.")
                }
            }
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
}


