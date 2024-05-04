//
//  BookmarksView.swift
//  WordChainApp
//
//  Created by Yachae on 4/29/24.
//

import SwiftUI
struct BookmarksView: View {
  @ObservedObject var contentViewModel: ContentViewViewModel
  
  
  var body: some View {
	List {
	  ForEach(Array(contentViewModel.bookmarkedWords).sorted(), id: \.self) { word in
		Text(word)
	  }
	  .onDelete(perform: deleteItems)
	}
	.navigationTitle("북마크한 단어들")
	.navigationBarItems(trailing: Button(action: {
        contentViewModel.bookmarkedWords.removeAll()
	}) {
	  Text("모두 지우기")
	})
  }
  
  func deleteItems(at offsets: IndexSet) {
	for index in offsets {
	  let word = Array(contentViewModel.bookmarkedWords).sorted()[index]
        contentViewModel.bookmarkedWords.remove(word)
	}
  }
}
