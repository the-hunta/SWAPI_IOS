import UIKit
import Foundation

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let peopleEndpoint = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peopleEndpoint)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { data, _, _ in
            
            guard let data = data else { return completion(nil) }
            
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                completion(person)
            } catch {
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return completion(nil) }
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                return completion(nil)
            }
            
        }.resume()
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 1) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
            
            }
        }
}

