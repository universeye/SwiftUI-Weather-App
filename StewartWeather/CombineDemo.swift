//
//  CombineDemo.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/8.
//

import UIKit
import Combine


//we create a new Publisher for our new blog post notification.
//This publisher will listen for incoming notifications for the newBlogPost notification name

 extension Notification.Name {
     static let newBlogPost = Notification.Name("new_blog_post")
 }

 struct BlogPost {
     let title: String
     let url: URL
 }

let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
     .map { (notification) -> String? in
         return (notification.object as? BlogPost)?.title ?? ""
     }


//create a lastPostTitleLabel which subscribes to the publisher.
let lastPostLabel = UILabel()
let lastPostLabelSubscriber = Subscribers.Assign(object: lastPostLabel, keyPath: \.text)
func blogSubscribe() {
    blogPostPublisher.subscribe(lastPostLabelSubscriber)
}


let blogPost = BlogPost(title: "Getting started with the Combine framework in Swift", url: URL(string: "https://www.avanderlee.com/swift/combine/")!)
func notifica() {
    NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
    print("Last post is: \(lastPostLabel.text!)")
}
// Last post is: Getting started with the Combine framework in Swift 
