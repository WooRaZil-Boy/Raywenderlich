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

import Foundation
import Combine

public class BullsEyeGame: ObservableObject {

  public let objectWillChange = PassthroughSubject<Void, Never>()

  public var round = 0
  public var startValue = 50
  public var targetValue = 50
  public var scoreRound = 0
  public var scoreTotal = 0
  
  public init() {
    startNewGame()
  }
  
  public func startNewGame() {
    round = 0
    scoreTotal = 0
    startNewRound()
  }
  
  public func startNewRound() {
    round += 1
    scoreRound = 0
    startValue = 50
    targetValue = Int.random(in: 1...100)
    objectWillChange.send()
  }
  
  public func checkGuess(_ guess: Int) {
    let difference = abs(targetValue - guess)
    scoreRound = 100 - difference
    scoreTotal = scoreTotal + scoreRound
    objectWillChange.send()
  }
}

//Customizing your Game package
//BullsEyeGame.swift를 Game Package로 이동 한다. BullsEyeGame의 모듈이 바뀌었기 때문에
//public으로 교체 해줘야 한다.
