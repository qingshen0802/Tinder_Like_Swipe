//
//  CardView.swift
//  SwipeGesture
//
//  Created by Master on 9/7/21.
//

import SwiftUI

struct CardView: View {
    
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    private var gifModel: GifModel
    private var onRemove: (_ user: GifModel) -> Void
    
    private var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(gif: GifModel, onRemove: @escaping (_ user: GifModel) -> Void) {
        self.gifModel = gif
        self.onRemove = onRemove
    }
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                 ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                    AsyncImage(
                        url: URL(string: self.gifModel.imageUrl)!,
                        placeholder: { Text("Loading ...") },
                        image: { Image(uiImage: $0).resizable()}
                    ).frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                }
            }
            .padding(.bottom, 0.0)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                            self.swipeStatus = .like
                        } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                            self.swipeStatus = .dislike
                        } else {
                            self.swipeStatus = .none
                        }
                        
                }.onEnded { value in
                    // determine snap distance > 0.5 aka half the width of the screen
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            self.onRemove(self.gifModel)
                        } else {
                            self.translation = .zero
                        }
                    }
                )
            }
        }
    }

    // 7
    struct CardView_Previews: PreviewProvider {
        static var previews: some View {
            CardView(gif: GifModel(id: 12, imageUrl: "https://media3.giphy.com/media/Wsk5V26W0jVYur1f9Z/giphy_s.gif?cid=daf30bf3y6fr8qgt55xk2dtzov4dmdg2clvo9t9f2h60vpu5&rid=giphy_s.gif&ct=g"),
                     onRemove: { _ in
                        
                })
                .frame(height: 400)
                .padding()
        }
    }
