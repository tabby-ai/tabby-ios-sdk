//
//  RemoteImage.swift
//  TabbyDemo
//
//  Created by ilya.kuznetsov on 11.09.2021.
//

import SwiftUI
import Combine

@available(iOS 13.0, *)
class ImgLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let e = error {
                print(e)
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

@available(iOS 13.0, *)
struct ImageView: View {
        
    @ObservedObject var imageLoader: ImgLoader
    @State var image:UIImage = UIImage()
    @Binding var loaded: Bool
    
    init(withURL url:String, loaded: Binding<Bool>) {
        imageLoader = ImgLoader(urlString:url)
        self._loaded = loaded
    }
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
                loaded = true
            }
    }
}

@available(iOS 13.0, *)
struct Logo: View {
    @State var loaded = false
    
    var body: some View {
        ImageView(withURL: imgUrls[.logo]!, loaded: $loaded)
            .scaledToFit()
            .background(tabbyColor)
            .frame(width: 70, height: 28)
            .cornerRadius(4)
            .overlay(
                Group {
                    if (loaded) {
                        EmptyView()
                    } else {
                        Rectangle()
                            .foregroundColor(tabbyColor)
                            .frame(width: 70, height: 28)
                            .cornerRadius(4)
                    }
                }
            )
    }
}

@available(iOS 13.0, *)
struct CirclePlaceholder: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .frame(width: 40, height: 40)
            .cornerRadius(40/2)
    }
}


@available(iOS 13.0, *)
struct SegmentedCircle: View {
    
    enum State {
        case q25
        case q50
        case q75
        case q100
    }
    
    var state: State
    
    private let size: CGFloat = 40
    private let padding: CGFloat = 5
    
    init(state: State) {
        self.state = state
    }
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 1)
            .foregroundColor(segmentedCircleColor)
            .frame(width: size, height: size)
            .overlay(
                Group {
                    switch state {
                    case .q25:
                        Path { path in
                            path.move(to: CGPoint(x: size / 2.0, y: size / 2.0))
                            path.addArc(
                                center: CGPoint(x: size / 2.0, y: size / 2.0),
                                radius: (size - padding) / 2,
                                startAngle: .degrees(0),
                                endAngle: .degrees(-90),
                                clockwise: true
                            )
                        }
                        .fill(segmentedCircleColor)
                    case .q50:
                        Path { path in
                            path.move(to: CGPoint(x: size / 2.0, y: size / 2.0))
                            path.addArc(
                                center: CGPoint(x: size / 2.0, y: size / 2.0),
                                radius: (size - padding) / 2,
                                startAngle: .degrees(90),
                                endAngle: .degrees(-90),
                                clockwise: true
                            )
                        }
                        .fill(segmentedCircleColor)
                    case .q75:
                        Path { path in
                            path.move(to: CGPoint(x: size / 2.0, y: size / 2.0))
                            path.addArc(
                                center: CGPoint(x: size / 2.0, y: size / 2.0),
                                radius: (size - padding) / 2,
                                startAngle: .degrees(180),
                                endAngle: .degrees(-90),
                                clockwise: true
                            )
                        }
                        .fill(segmentedCircleColor)
                    case .q100:
                        Circle()
                            .foregroundColor(segmentedCircleColor)
                            .frame(width: size - padding, height: size - padding)
                    }
                }
            )
            .padding(0.5)
    }
}

@available(iOS 13.0, *)
struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Logo()
            SegmentedCircle(state: .q25)
            SegmentedCircle(state: .q50)
            SegmentedCircle(state: .q75)
            SegmentedCircle(state: .q100)
        }
        .previewLayout(.sizeThatFits)
    }
}
