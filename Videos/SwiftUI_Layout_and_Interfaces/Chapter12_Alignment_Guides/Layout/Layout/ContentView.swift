/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  var body: some View {
//    HStack {
//      //Vstack은 HorizontalAlignment가 필요하고, HStack은 VerticalAlignment가 필요하다.
//      Image("Frogon")
//        .resizable()
//        .scaledToFit()
//        .frame(width: 60)
//        .alignmentGuide(VerticalAlignment.center) { $0[.bottom]  * 3.5}
//        //alignmentGuide를 사용하지 않으면, Stack의 subviews는 모두 가운데 정렬이 default이다.
//        //alignmentGuide를 사용해 각각의 View 정렬을 해 줄 수 있다.
//
//      Text("Alignment == 😻!")
//        .multilineTextAlignment(.center)
//        .alignmentGuide(VerticalAlignment.center) { _ in 300 }
//
//      Image("Xcode Magic")
//        .resizable()
//        .scaledToFit()
//        .frame(width: 240)
//        .alignmentGuide(VerticalAlignment.center) { $0[.top] - 200 }
//    }
    
    VStack(alignment: .leading) {
      //Vstack은 HorizontalAlignment가 필요하고, HStack은 VerticalAlignment가 필요하다.
      Image("Frogon")
        .resizable()
        .scaledToFit()
        .frame(width: 60)
//        .alignmentGuide(HorizontalAlignment.center) { $0[.leading]  }
        //alignmentGuide를 사용하지 않으면, Stack의 subviews는 모두 가운데 정렬이 default이다.
        //alignmentGuide를 사용해 각각의 View 정렬을 해 줄 수 있다.

      Text("Alignment == 😻!")
        .multilineTextAlignment(.center)

      Image("Xcode Magic")
        .resizable()
        .scaledToFit()
        .frame(width: 240)
        .alignmentGuide(.leading) { $0[HorizontalAlignment.center] }
    }
  }
}

//https://swiftui-lab.com/alignment-guides/

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
