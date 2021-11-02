//
//  RemoteImageView.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/2/21.
//

import Foundation
import Siesta
import SwiftUI

class RemoteImageView: UIImageView {
    
    var loadingView: UIView?
    var alternateView: UIView?
    var placeholderImage: UIImage?
    
    public static var defaultImageService = Service()
    
    public var imageService: Service = RemoteImageView.defaultImageService
    
    public var imageURL: String? {
        get { imageResource?.url.absoluteString }
        set {
            imageResource = (newValue == nil)
            ? nil
            : imageService.resource(absoluteURL: newValue)
        }
    }
    
    public var imageTransform: (UIImage?) -> UIImage? = { $0 }
    
    public var imageResource: Resource? {
        willSet {
            imageResource?.removeObservers(ownedBy: self)
            imageResource?.cancelLoadIfUnobserved(afterDelay: 0.05)
        }
        
        didSet {
            imageResource?.loadIfNeeded()
            imageResource?.addObserver(owner: self)
                { [weak self] _,_ in self?.updateViews() }

            if imageResource == nil  // (and thus closure above was not called on observerAdded)
                { updateViews() }
        }
    }
    
    private func updateViews() {
        image = imageTransform(imageResource?.typedContent(ifNone: placeholderImage))

        let isLoading = imageResource?.isLoading ?? false
        loadingView?.isHidden = !isLoading
        alternateView?.isHidden = (image != nil) || isLoading
    }
}

    

//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }

//struct RemoteImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        RemoteImageView()
//    }
//}
