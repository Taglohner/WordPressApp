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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearData()
        getNewPosts()
        
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
                cell.cellImage.image = UIImage(named: "placeholder")
            } else {
                DispatchQueue.main.async {
                    cell.cellImage.image = UIImage(data: post.featuredImage!)
                }
            }
            cell.textLabel?.text = post.title
            cell.detailTextLabel?.text = post.excerpt
        }
        return cell
    }
    
    // MARK: Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPost = fetchedResultsController?.object(at: indexPath) as! Post
        
        print(selectedPost.link ?? "no link found")
        
        let destinationViewController = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController!.pushViewController(destinationViewController, animated: true)
        
    }
    
    // MARK: Supporing methods
    
    /* perform a network task and fetch for new posts, save into CoreData */
    
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
    
    private func saveInCoreDataWith(array: [PostObject]) {
        for object in array {
            
            _  = createPhotoEntityFrom(object: object)
            AppDelegate.stack.save()
        }
    }
    
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
