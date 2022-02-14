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
      .frame(width: 45, height: 18)
      .cornerRadius(4)
      .overlay(
        Group {
          if (loaded) {
            EmptyView()
          } else {
            Rectangle()
              .foregroundColor(tabbyColor)
              .frame(width: 45, height: 18)
              .cornerRadius(4)
          }
        }
      )
  }
}

@available(iOS 13.0, *)
struct Round1: View {
  @State var loaded = false
  
  var body: some View {
    ImageView(withURL: imgUrls[.round1]!, loaded: $loaded)
      .scaledToFit()
      .frame(width: 40, height: 40)
      .overlay(
        Group {
          if (loaded) {
            EmptyView()
          } else {
            Rectangle()
              .foregroundColor(.gray)
              .frame(width: 40, height: 40)
              .cornerRadius(40/2)
          }
        }
      )
  }
}

@available(iOS 13.0, *)
struct Round2: View {
  @State var loaded = false
  
  var body: some View {
    ImageView(withURL: imgUrls[.round2]!, loaded: $loaded)
      .scaledToFit()
      .frame(width: 40, height: 40)
      .overlay(
        Group {
          if (loaded) {
            EmptyView()
          } else {
            Rectangle()
              .foregroundColor(.gray)
              .frame(width: 40, height: 40)
              .cornerRadius(40/2)
          }
        }
      )
  }
}

@available(iOS 13.0, *)
struct Round3: View {
  @State var loaded = false
  
  var body: some View {
    ImageView(withURL: imgUrls[.round3]!, loaded: $loaded)
      .scaledToFit()
      .frame(width: 40, height: 40)
      .overlay(
        Group {
          if (loaded) {
            EmptyView()
          } else {
            Rectangle()
              .foregroundColor(.gray)
              .frame(width: 40, height: 40)
              .cornerRadius(40/2)
          }
        }
      )
  }
}

@available(iOS 13.0, *)
struct Round4: View {
  @State var loaded = false
  
  var body: some View {
    ImageView(withURL: imgUrls[.round4]!, loaded: $loaded)
      .scaledToFit()
      .frame(width: 40, height: 40)
      .overlay(
        Group {
          if (loaded) {
            EmptyView()
          } else {
            Rectangle()
              .foregroundColor(.gray)
              .frame(width: 40, height: 40)
              .cornerRadius(40/2)
          }
        }
      )
  }
}

@available(iOS 13.0, *)
struct Logo_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Logo()
      Round1()
      Round2()
      Round3()
      Round4()
    }.previewLayout(.sizeThatFits)
  }
}
