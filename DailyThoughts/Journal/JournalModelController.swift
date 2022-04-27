/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

final class JournalModelController: ObservableObject {
  @Published var thoughts: [ThoughtModel] = []
  @Published var newThoughtText: String = ""
  private lazy var databasePath: DatabaseReference? = {
    // Get User ID of the authenticated user
    guard let uid = Auth.auth().currentUser?.uid else {
      return nil
    }
    
    let ref = Database.database()
      .reference()
      .child("users/\(uid)/thoughts")
    
    // Return the reference to the path where thoughts data is stored
    return ref
  }()
  
  // Define an encoder variable for JSON data
  private let encoder = JSONEncoder()
  
  func listenForThoughts() {
    // Check is database path is valid
    guard let databasePath = databasePath else {
      return
    }
    // Check is the text is provided
    if newThoughtText.isEmpty {
      return
    }
    // Create a new ThoughtModel object from the text
    let thought = ThoughtModel(text: newThoughtText)
    
    do {
      // Encode the model
      let data = try encoder.encode(thought)
      // Create JSON object and store it
      let json = try JSONSerialization.jsonObject(with: data)
      databasePath.childByAutoId()
        .setValue(json)
    } catch {
      print("An error occured", error)
    }
  }
  
  func stopListening() {}
  
  func postThought() {}
}
