/// Copyright (c) 2020 Razeware LLC
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

import UIKit
import CoreLocation

typealias PlacesCompletion = ([GooglePlace]) -> Void
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleDataProvider {
  private var photosDictionary: [String: UIImage] = [:]
  private var placesTask: URLSessionDataTask?
  private let googleApiKey = ""

  static let shared : GoogleDataProvider = GoogleDataProvider()
    
  private var session: URLSession {
    return URLSession.shared
  }
 
  func fetchPlaces(
    near coordinate: CLLocationCoordinate2D,
    types:[String],
    completion: @escaping PlacesCompletion
  ) -> Void {
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate)&rankby=distance&key=\(googleApiKey)"
    let typesString = types.count > 0 ? types.joined(separator: "|") : "school"
    urlString += "&types=\(typesString)"
    
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
    
    
    performURLTask(urlString: urlString) { (places) in
        completion(places)
    }
   
  }
    
    func searchPlaces(near coordinate: CLLocationCoordinate2D, query : String, types: [String], completion: @escaping PlacesCompletion){
 
        var urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&location=\(coordinate)&key=\(googleApiKey)"
        let typesString = types.count > 0 ? types.joined(separator: "|") : "school"
        urlString += "&types=\(typesString)"

        let url = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
       
        performURLTask(urlString: url) { (places) in
            completion(places)
        }
    }
    
    
    private func performURLTask(urlString : String, completion: @escaping PlacesCompletion) {
        print("google search places string : \(urlString)")
        guard let url = URL(string: urlString) else {
             completion([])
             return
           }
           
           if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            print("URL TASK CANCELLED")
             task.cancel()
           }
           
           placesTask = session.dataTask(with: url) { data, response, _ in
             guard let data = data else {
               print("NO DATA FOUND")
               DispatchQueue.main.async {
                 completion([])
               }
               return
             }
             let decoder = JSONDecoder()
             decoder.keyDecodingStrategy = .convertFromSnakeCase
            
             guard let placesResponse = try? decoder.decode(GooglePlace.Response.self, from: data) else {
                print("FAILED TO DECODE")
               DispatchQueue.main.async {
                 completion([])
               }
               return
             }
             
             if let errorMessage = placesResponse.errorMessage {
               print("THERE WAS A PLACES ERROR: \(errorMessage)")
             }
             
             DispatchQueue.main.async {
               completion(placesResponse.results)
             }
           }
           placesTask?.resume()
    }
}
