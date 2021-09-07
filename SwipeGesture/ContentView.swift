//
//  ContentView.swift
//  SwipeGesture
//
//  Created by Master on 9/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var apiClient = SearchGif(key: "")
    @State private var searchText = ""
    
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return geometry.size.width
    }
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  0
    }
    
    private var maxID: Int {
        return self.apiClient.searchResult.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 24) {
                    VStack {
                        TextField("Search Text", text: $searchText)
                            .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    ZStack {
                        ForEach(self.apiClient.searchResult, id: \.self) { gif in
                            Group {
                                // Range Operator
                                if (self.maxID - 3)...self.maxID ~= gif.id {
                                    CardView(gif: gif, onRemove: { removedUser in
                                        // Remove that user from our array
                                        self.apiClient.searchResult.removeAll { $0.id == removedUser.id }
                                    })
                                        .animation(.spring())
                                        .frame(width: self.getCardWidth(geometry, id: gif.id), height: 500)
                                        .offset(x: 0, y: self.getCardOffset(geometry, id: gif.id))
                                }
                            }
                        }
                    }
                    Spacer()
                    Button (action: {
                        self.apiClient.getGifs(key: searchText)
                    }) {
                        Text("Next")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
