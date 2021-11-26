//
//  DetailImageWithTitle.swift
//  WhatsHappenin
//
//  Created by Christian Tingle on 11/26/21.
//

import SwiftUI

struct DetailImageWithTitle: View {
    @Binding var event: Event
    @Binding var outerGeometry: GeometryProxy
    @State private var controller: EventsListController = EventsListController.sharedInstance
    
    let MAX_IMAGE_FRAME_HEIGHT: CGFloat = 500//px
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                let offset = self.getOffsetForHeaderImage(geometry)
                Image(uiImage: getHeaderImage())
                    .resizable()
                    .scaledToFill()
                    .overlay(ImageOverlayView(event: $event, geometry: geometry))
                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                    .clipped()
                    .offset(y: offset)
                    
                let titleFont = Font.system(size: 30).bold()

                Text($event.title.wrappedValue)
                    .font(titleFont)
                    .foregroundColor(.white)
                    .offset(y: offset)
                    .padding()
                    .frame(width: geometry.size.width, alignment: .bottomLeading)
            }
        }
        .frame(height: getScaledHeightForFrame(getHeaderImage(), geometry: outerGeometry))
    }
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    private func getScaledHeightForFrame(_ image: UIImage, geometry: GeometryProxy) -> CGFloat {
        let ratio = geometry.size.width / image.size.width
        let scaledHeight = ratio * image.size.height
        let finalHeight = scaledHeight <= MAX_IMAGE_FRAME_HEIGHT ? scaledHeight : MAX_IMAGE_FRAME_HEIGHT
        return finalHeight
    }
    
    
    
    private func getHeaderImage() -> UIImage {
        if let img: UIImage = controller.eventImages[event] {
            return img
        }
        return UIImage(named: "SampleImage")!
    }
}

struct ImageOverlayView: View {
    @Binding var event: Event
    @State var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            EmptyView()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: imageGradient()), startPoint: .top, endPoint:.bottom))
    }
    
    private func imageGradient() -> Array<Color> {
        return [
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.2),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.4),
        ]
    }
    
}
