//
//  VideoPlayerWebView.swift
//  Criczz Movie
//
//  Created by Santhosh G Patkar on 04/10/25.
//

import Foundation
import SwiftUI
import WebKit
import AVKit

struct TrailerPlayerView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> UIViewController {
        if url.absoluteString.contains("youtube") {
            // WKWebView for YouTube
            let webView = WKWebView()
            webView.allowsBackForwardNavigationGestures = true
            webView.load(URLRequest(url: url))
            
            let vc = UIViewController()
            vc.view = webView
            return vc
            
        } else {
            // AVPlayer for direct video URLs
            let controller = AVPlayerViewController()
            controller.player = AVPlayer(url: url)
            return controller
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
