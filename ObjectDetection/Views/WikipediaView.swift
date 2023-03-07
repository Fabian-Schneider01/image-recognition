//
//  WikipediaView.swift
//  ObjectDetector
//
//  Created by Fabian Schneider on 12.06.22.
//



import SwiftUI
import WikipediaKit

extension String {
    func load() ->UIImage {
        do {
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data: Data = try Data(contentsOf: url, options: .uncached)
            return UIImage(data: data) ?? UIImage()
        } catch{
            
        }
        return UIImage()
    }
}

struct WikipediaView: View {
    @ObservedObject var vm: DetectionViewModel = DetectionViewModel()
    @Binding var results: Array<String>
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(.blue), Color(.purple)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    func fetchWikiData(element: String) {
        Wikipedia.shared.requestOptimizedSearchResults(language: WikipediaLanguage("en"), term: element){(searchResults, error) in
            guard error == nil else {return}
            guard let searchResults = searchResults else {return}
            for articlePreview in searchResults.items {
                if let image = articlePreview.imageURL {
                    wikiImage.append("\(image)")
                    
                }
                wikiText.append(articlePreview.displayText)
                wikiTitle.append(articlePreview.title)
                break
            }
        }
    }
    
    @State private var wikiImage = ""
    @State private var wikiSearch = ""
    @State private var wikiText = ""
    @State private var wikiTitle = ""
    @State private var showWiki = false
    @State private var wikiCounter = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                if showWiki == true {
                    VStack {
                        Image(uiImage: wikiImage.load())
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .center)
                            .scaledToFit()
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(gradient, lineWidth: 4))
                            .cornerRadius(10.0)
                            .padding()
                        Text(wikiTitle)
                            .font(.title)
                            .foregroundColor(Color.primary)
                        Text(wikiText)
                            .padding()
                    }
                } else {
                    TextField("Search", text: $wikiSearch)
                        .multilineTextAlignment(.center)
                        .frame(width: 300, height: 30, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                        .padding()
                }
            }
            .onAppear(){
                fetchWikiData(element: results[wikiCounter])
                self.showWiki = true
            }
            .navigationBarTitle("Wikipedia")
            .navigationBarItems(leading: Button(action: {
                if wikiCounter != 0 {
                    wikiImage = ""
                    wikiSearch = ""
                    wikiText = ""
                    wikiTitle = ""
                    wikiCounter -= 1
                    fetchWikiData(element: results[wikiCounter])
                }
            }){
                Text("Previous")
            },
                                
            trailing: Button(action: {
                if wikiCounter != 6 {
                    wikiImage = ""
                    wikiSearch = ""
                    wikiText = ""
                    wikiTitle = ""
                    wikiCounter += 1
                    fetchWikiData(element: results[wikiCounter])
                }
            }){
                Text("Next")
            })
        }
    }
}

