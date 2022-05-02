//
//  ViewController.swift
//  JokeGetter
//
//  Created by Paul on 02.05.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var jokeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func fetchWithCompletion(_ sender: UIButton) {
        JokeStore.shared.fetchJoke(from: JokeEndpoint.random) { [weak self] result in
            switch result {
            case .success(let joke):
                self?.updateJokeLabel(with: joke)
            case .failure(let error):
                self?.updateJokeLabel(with: error)
            }
        }
    }
    
    @IBAction func fetchWithAsync(_ sender: Any) {
        Task {
            if let joke = await JokeStore.shared.fetchJoke(from: JokeEndpoint.random) {
                updateJokeLabel(with: joke)
            } else {
                updateJokeLabel(with: URLError(.cannotLoadFromNetwork))
            }
        }
    }
    
    private func updateJokeLabel(with joke: Joke) {
        jokeLabel.text = joke.setup + "\n" + joke.punchline
    }
    private func updateJokeLabel(with error: Error) {
        jokeLabel.text = "Could not fetch joke. Error: \(error.localizedDescription)"
    }
}

