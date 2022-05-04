import Foundation

final class WordStore {
    
    static let shared = WordStore()
    
    var wordsByTopics = [String : [String]]()
    
    private init() {}
    
    func words(by topic: String) -> [String] {
        if let words = wordsByTopics[topic] {
            return words
        } else {
            let words = load(by: topic)
            wordsByTopics[topic] = words
            return words
        }
    }
    
    func load(by topic: String) -> [String] {
        guard let url = Bundle.main.url(forResource: topic, withExtension: "txt"),
              let wordString = try? String(contentsOf: url)
        else { return [] }
        let words = wordString.split(separator: ",").map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        return words
    }
    
}
