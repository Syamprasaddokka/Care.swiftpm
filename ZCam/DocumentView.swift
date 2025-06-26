//
//  DocumentView.swift
//  My App
//
//  Created by Syam Prasad Dokka on 21/02/25.
//

import SwiftUI
import SwiftData
import VisionKit

struct DocumentsView: View {
    @Query(sort: [.init(\Document.createdAt, order: .reverse)], animation: .snappy(duration: 0.25, extraBounce: 0)) private var documents: [Document]
    @Namespace private var animationID
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 15) {
                ForEach(documents) { document in
                    NavigationLink {
                        DocumentDetailView(document: document)
                            .navigationTransition(.zoom(sourceID: document.uniqueID, in: animationID))
                    } label: {
                        DocumentCardView(document: document, animationID: animationID)
                            .foregroundStyle(Color.primary)
                    }
                }
            }
            .padding(15)
            .navigationBarTitle("Records")
        }
        
    }
}
