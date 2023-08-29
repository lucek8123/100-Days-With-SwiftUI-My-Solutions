//
//  ContentView.swift
//  Instafilter
//
//  Created by Lucek Krzywdzinski on 13/02/2022.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensityOne = 0.5
    @State private var filterIntensityTwo = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilterOne: CIFilter = CIFilter.sepiaTone()
    @State private var currentFilterTwo: CIFilter = CIFilter.gaussianBlur()
    let context = CIContext()
    
    @State private var showingFilterChose = false
    @State private var showingFilterSheet = false
    @State private var forFilterOne = true
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(.secondary)
                            .frame(width: (image == nil) ? geo.size.width : 0)
                    }
                    if image == nil {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    VStack {
                        image?
                            .resizable()
                            .scaledToFit()
                        if image != nil {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                        }
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Filter One")
                    Slider(value: $filterIntensityOne)
                        .onChange(of: filterIntensityOne) { _ in applyProcessing() }
                }
                
                HStack {
                    Text("Filter Two")
                    Slider(value: $filterIntensityTwo)
                        .onChange(of: filterIntensityTwo) { _ in applyProcessing() }
                }
                .padding(.vertical)
                
                HStack{
                    Button("Change filter") {
                        showingFilterChose.toggle()
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .vertical])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize(), forOne: forFilterOne) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone(), forOne: forFilterOne) }
                Button("Edges") { setFilter(CIFilter.edges(), forOne: forFilterOne) }
                Button("Guassian Blur") { setFilter(CIFilter.gaussianBlur(), forOne: forFilterOne) }
                Button("Pixellrate") { setFilter(CIFilter.pixellate(), forOne: forFilterOne) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask(), forOne: forFilterOne) }
                Button("Vignette") { setFilter(CIFilter.vignette(), forOne: forFilterOne) }
                Button("Cancel", role: .cancel) { }
            }
            .confirmationDialog("Select for with filter you wont to chose", isPresented: $showingFilterChose) {
                Button("Filter One") { forFilterOne = true; showingFilterSheet = true}
                Button("Filter Two") { forFilterOne = false; showingFilterSheet = true}
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        
        let beginImage = CIImage(image: inputImage)
        currentFilterOne.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilterTwo.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else {
            return
        }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        
        imageSaver.errorHandler = { error in
            print("Ooops... \(error.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilterOne.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilterOne.setValue(filterIntensityOne, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilterOne.setValue(filterIntensityOne * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilterOne.setValue(filterIntensityOne * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilterOne.outputImage else {
            return
        }
        
        currentFilterTwo.setValue(outputImage, forKey: kCIInputImageKey)
        
        let inputKeysTwo = currentFilterTwo.inputKeys
        
        if inputKeysTwo.contains(kCIInputIntensityKey) {
            currentFilterTwo.setValue(filterIntensityTwo, forKey: kCIInputIntensityKey)
        }
        if inputKeysTwo.contains(kCIInputRadiusKey) {
            currentFilterTwo.setValue(filterIntensityTwo * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeysTwo.contains(kCIInputScaleKey) {
            currentFilterTwo.setValue(filterIntensityTwo * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImageTwo = currentFilterTwo.outputImage else {
            return
        }
        
        if let cgimg = context.createCGImage(outputImageTwo, from: outputImageTwo.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    func setFilter(_ filter: CIFilter, forOne forFilterOne: Bool) {
        if forFilterOne {
            currentFilterOne = filter
        } else {
            currentFilterTwo = filter
        }
        loadImage()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
