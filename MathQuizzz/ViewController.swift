//
//  ViewController.swift
//  MathQuizzz
//
//  Created by Mark Shepherd on 3/7/16.
//  Copyright © 2016 Mark Shepherd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var answerButton1: UIButton!
    @IBOutlet var answerButton2: UIButton!
    @IBOutlet var answerButton3: UIButton!
    @IBOutlet var questionTimer: UIProgressView!
    @IBOutlet var startButton: UIButton!
    
    
    var ans:NSInteger = 0; var score:NSInteger = 0


    var timer=NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "math.jpg")!)
        
              resetGame()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkAnswer1(sender: AnyObject) {
        isAnswerCorrect(answerButton1, correctAnswer: ans)
         generateQuestions()
    }
    
    @IBAction func checkAnswer2(sender: AnyObject) {
        isAnswerCorrect(answerButton2, correctAnswer: ans)
         generateQuestions()
    }
    
    @IBAction func checkAnswer3(sender: AnyObject) {
        isAnswerCorrect(answerButton3, correctAnswer: ans)
           generateQuestions()
    }
    
    @IBAction func startGame(sender: AnyObject) {
        
        startButton.hidden=true
        self.generateQuestions()
        
        
        
        answerButton1.hidden=false ;answerButton2.hidden=false ;answerButton3.hidden=false
        questionLabel.hidden=false ;questionTimer.hidden=false;
        questionTimer.progress=0.0; questionTimer.progressTintColor=UIColor.redColor()
        scoreLabel.hidden=false
        
        
    }
    
    @IBAction func reset(sender: AnyObject) {

    }

    func printRandomNum(lowerBounds: UInt32, upperBounds:UInt32) -> UInt32{
        let lower : UInt32 = lowerBounds
        let upper : UInt32 = upperBounds
        let randomNumber = arc4random_uniform(upper - lower) + lower
        return randomNumber
    }

    //Sent Random operation and return results
    func calcOperations(num1:Int, num2:Int, operationType:UInt32) ->Int{
        
        var answer:Int
        answer=0
        
        
        switch operationType{
            
            case 0:
                answer=(num1 + num2)
            case 1:
                answer=(num1 - num2)
            case 2:
                answer=(num1 * num2)
            
        default:0
            
        }
        return answer
    }
    
    //Get the operation label for the UI
    func getOperationLabel(operationType: UInt32)->String{
        var symbol=""
        
        switch operationType{
            
            case 0:
                symbol="+"
            case 1:
                symbol="-"
            case 2:
                symbol="*"
            
        default:"+"
            
        }
        
        return symbol
    }
    
    func randomizeAnswerChoices (var answerChoices: [Int]) ->[Int]{
        
        //Randomize elements of array
        for var index = answerChoices.count - 1; index > 0; index--
        {
            // Random int from 0 to index-1
            let j = Int(arc4random_uniform(UInt32(index-1)))
            swap(&answerChoices[index], &answerChoices[j])
        }
        return answerChoices
    }
    
    
    func generateQuestions(){
        let num1=Int(printRandomNum(0, upperBounds: 12))
        let num2=Int(printRandomNum(0, upperBounds: 12))
        let operationType=printRandomNum(0, upperBounds: 3)
        ans=calcOperations(num1,num2: num2, operationType: operationType)
        
        getOperationLabel(operationType)
        print("\(num1) \(getOperationLabel(operationType)) \(num2) = \(ans)")
        
        questionLabel.text = ("\(num1) \(getOperationLabel(operationType)) \(num2) = ?")
        
        
        
        //Get answer buttons and assign their choices
        
        var buttonValues=generateAnswerChoices(ans, operationLabel:getOperationLabel(operationType) )
        var buttons = [answerButton1, answerButton2, answerButton3]
        for var i = 0; i<buttons.count; i++ {
            
        buttons[i].setTitle(String(buttonValues[i]), forState: UIControlState.Normal)
            
            questionTimer.progress=0.0
      
           self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
            
            
        }
    }
    
    func generateAnswerChoices(correctAnswer: Int, operationLabel: String) ->[Int]{
        
        var f:Set  = [correctAnswer]
        let additionUpperBounds=24
        let subtractionUpperBounds=12
        let multiUpperBounds=144
        var wrongChoice=0
        
        
        switch operationLabel{
            
            case "+":
                while f.count<3 {
                    wrongChoice=Int(printRandomNum(0, upperBounds: UInt32(additionUpperBounds)))
                    f.insert(wrongChoice)
                }
        
            case "-":
                
                 while f.count<3{
                    
                    wrongChoice=Int(printRandomNum(0, upperBounds: UInt32(subtractionUpperBounds)))
                    
                    if (correctAnswer < 0){
                        wrongChoice=wrongChoice*(-1)
                    }
                    
                    f.insert(wrongChoice)
                }
        
            case "*":
                
                 while f.count<3 {
                    wrongChoice=Int(printRandomNum(0, upperBounds: UInt32(multiUpperBounds)))
                    f.insert(wrongChoice)
            }
            default:"+"
    
        }
        
        var answerArray=Array(f)
        answerArray=randomizeAnswerChoices(answerArray)
        print("Answer Choices: \(answerArray)")
        return answerArray
        
    }
    
    func isAnswerCorrect(buttonSelected: UIButton, correctAnswer:Int) -> Bool{
        
        
        print(Int((buttonSelected.titleLabel?.text)!))
        
        print(correctAnswer)
        
        if ((Int((buttonSelected.titleLabel?.text)!) == correctAnswer)){
            print("Correct Answer")
            score++
            scoreLabel.text="Score: \(String(score))"
            return true
        }else{
           print("InCorrect Answer")
            
            resetGame()
            
            let alertController = UIAlertController(title: "INCORRECT ANSWER", message: "GAME OVER Your Score was \(String(score))", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return false }
        
    }
    
    func resetGame(){
        
        //Rest Score
        score=0
        
        //Go to reset screen
        answerButton1.hidden=true
        answerButton2.hidden=true
        answerButton3.hidden=true
        questionLabel.hidden=true
        questionTimer.hidden=true
        questionTimer.progress=0.0
        questionTimer.progressTintColor=UIColor.redColor()
        self.timer.invalidate()
        startButton.hidden=false
        
        scoreLabel.hidden=true
        scoreLabel.text = "Score: \(String(0))"
       
    }
   
    func updateProgress(){
        self.questionTimer.progress+=0.025
        
        if(self.questionTimer.progress==1.0){
            
            self.timer.invalidate()
    
            let alertController = UIAlertController(title: "OUT OF TIME", message: "GAME OVER: Your Score was \(String(score))", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            resetGame()
            
            }
        
        }
    
    }













