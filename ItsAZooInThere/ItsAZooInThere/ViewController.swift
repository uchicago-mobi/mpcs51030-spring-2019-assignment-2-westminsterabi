//
//  ViewController.swift
//  ItsAZooInThere
//
//  Created by Abi Hunter on 4/14/19.
//  Copyright © 2019 Abi Hunter. All rights reserved.
//

import UIKit
import AVFoundation

let SCREEN_WIDTH: Int = 375

class Animal: CustomStringConvertible {
    var description: String
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    init(_ name: String, _ species: String, _ age: Int,
         _ image: UIImage, _ soundPath: String) {
        description = "Animal: name = \(name), species = \(species), age = \(age)"
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
    }
    
}

class ViewController: UIViewController {
    var animals: [Animal] = []
    var cuteSoundEffect: AVAudioPlayer?
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var speciesLabel: UILabel!
    
    // MARK: sound effects
    // got help here: https://www.hackingwithswift.com/example-code/media/how-to-play-sounds-using-avaudioplayer
    
    func playSound(pathName: String) {
        let path = Bundle.main.path(forResource: pathName,
                                    ofType: nil)
        do {
            let url = URL(fileURLWithPath: path!)
            cuteSoundEffect = try AVAudioPlayer(contentsOf: url)
            cuteSoundEffect?.play()
        } catch {
            print("Couldn't load file")
        }
    }
    
    // MARK: button tap handler
    // got help here: https://learnappmaking.com/target-action-swift/
    
    @objc func buttonTapped(_ button: UIButton) {
        let fuzzButt: Animal = animals[button.tag]
        let alertCont = UIAlertController(
            title: fuzzButt.name,
            message: "\(fuzzButt.name) is a \(fuzzButt.species) and is \(fuzzButt.age) years old!",
            preferredStyle: .alert)
        let awwwAction = UIAlertAction(title: "AWWWWWW SO CUTE!!!", style: .default)
        alertCont.addAction(awwwAction)
        playSound(pathName: fuzzButt.soundPath)
        self.present(alertCont, animated: true)
        print(fuzzButt)
    }
    
    override func viewDidLoad() {
        // MARK: create animals
        let claude = Animal(
            "Claude",
            "Mommy's Little Vacuum",
            3,
            UIImage(named: "Claude")!,
            "./Sounds/Honk!.mp3")
        let cooper = Animal(
            "Cooper",
            "The Pooper",
            10,
            UIImage(named: "Cooper")!,
            "./Sounds/Rabbit noises.mp3")
        let peanutButter = Animal(
            "Peanut Butter",
            "Bundle of love",
            2,
            UIImage(named: "Peanut Butter")!,
            "./Sounds/Guinea pig NOISES!.mp3")
        
        animals.append(contentsOf: [claude, peanutButter, cooper])
        animals.shuffle()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainScroll.delegate = self
        mainScroll.contentSize = CGSize(width: 1125, height:500)
        
        // got help here:  https://developer.apple.com/documentation/uikit/uibutton/1624018-settitle
        
        // MARK: add buttons and images
        for (index, animal) in animals.enumerated() {
            let button = UIButton(type: .system)
            let buttonWidth = 100
            let xPos: Int = (SCREEN_WIDTH / 2 - (buttonWidth / 2)) + index * SCREEN_WIDTH
            button.frame = CGRect(
                x: xPos,
                y: 400,
                width: buttonWidth,
                height: 20)
            button.setTitle(animal.name, for: [])
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            mainScroll.addSubview(button)
            
            let imgView = UIImageView(image: animal.image)
            let imgXPos: Int = SCREEN_WIDTH * index
            imgView.frame = CGRect(
                x: imgXPos,
                y: 0,
                width: SCREEN_WIDTH,
                height: SCREEN_WIDTH)
            mainScroll.addSubview(imgView)
        }
        
        
    }


}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // got help with coercing and rounding here https://stackoverflow.com/questions/24029917/convert-float-to-int-in-swift
        let xCoor: CGFloat = scrollView.contentOffset.x
        var pageDiv: CGFloat = ((xCoor + 187) / CGFloat(SCREEN_WIDTH))
        pageDiv.round(.down)
        let page: Int = Int(pageDiv)
        let pageMiddle = page * SCREEN_WIDTH
        let pageDiff = abs(pageMiddle - Int(xCoor))
        let alphaVal = 1.0 - CGFloat(pageDiff) / 187.0
        if (page >= 0 && page < 3)  {
            speciesLabel.text = animals[page].species
            speciesLabel.alpha = alphaVal
        
        }
       
        
    }
}

