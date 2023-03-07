//
//  ContentView.swift
//  ObjectDetector
//
//  Created by Fabian Schneider on 11.06.2022.
//

import SwiftUI

struct DetectionView: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [Color(.blue), Color(.purple)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    @ObservedObject var model = DetectionViewModel()
    @State var userImage = UIImage()
    @State var showPicker = false
    @State var showWikipedia = false
    
    var body: some View {
        VStack {
          
                Image(uiImage: userImage)
                .resizable()
                .scaledToFit()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(gradient, lineWidth: 4))
                .cornerRadius(10.0)
                .padding()
            
            List{
                ForEach(model.listResults, id: \.self) { res in
                    Text(res)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
            
            Spacer()
            HStack {
                Button {
                    showPicker = true
                } label: {
                    Text("Select Image")
                        .fontWeight(.heavy)
                        .padding()
                }
                .background(Capsule()
                    .stroke(gradient, lineWidth: 2)
                    .saturation(1.8))
                .padding()
                Button {
                   showWikipedia = true
                } label: {
                    Text("Wikipedia Info")
                        .fontWeight(.heavy)
                        .padding()
                }
                .background(Capsule()
                    .stroke(gradient, lineWidth: 2)
                    .saturation(1.8))
                .padding()
            }
        }
        .onAppear {
            if let image = UIImage(named: "welcome_ml") {
                self.userImage = image
                model.classifyImage(image)
            }
        }
        .imagePickerSheet(isPresented: $showPicker) { image in
            self.userImage = image
            model.classifyImage(image)
        }
        .sheet(isPresented: $showWikipedia) {
            WikipediaView(results: $model.results)
        }
    }
}

struct DetectionView_Previews: PreviewProvider {
    static var previews: some View {
        DetectionView()
    }
}
