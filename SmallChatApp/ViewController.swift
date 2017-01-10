//
//  ViewController.swift
//  SmallChatApp
//
//  Created by Adarsh Kolluru on 11/12/16.
//  Copyright © 2016 Saurabh. All rights reserved.
//

import UIKit
import AI

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var chat:[[String:String]] = [["des":"send","chat":"Hi, I am a IT Bot. If you want to calculate your income tax(India) then simply type yes or no"]]
    
    var animation:Bool = false
    var rowCount:Int!
    var control:UIPageControl!
    var count = 1
    var timer:NSTimer!
    @IBOutlet weak var controlView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
        textView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.userInteractionEnabled = true
//        let path = NSBundle.mainBundle().pathForResource("chatList", ofType: "plist")
//        let dict = NSDictionary(contentsOfFile: path!)
//        
//        chat = dict!.objectForKey("Chats") as! [[String:String]]
        
        rowCount = chat.count
        tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        tableViewScrollToBottom(true)
      
        self.tableView.reloadData()
        control = UIPageControl(frame: CGRect(x: 10, y: 5, width: 60, height: 35))
        control.currentPage = count
        control.numberOfPages = 3
        control.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        control.pageIndicatorTintColor = UIColor.lightGrayColor()
        control.tintColor = UIColor.darkGrayColor()
        control.layer.borderWidth = 0.5
        control.layer.cornerRadius = 18
        control.layer.borderColor = UIColor.whiteColor().CGColor
        control.backgroundColor = UIColor(red: 226.0/255.0, green: 226.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        // Do any additional setup after loading the view, typically from a nib.
    }
//    override func viewWillAppear(animated: Bool) {
//        tableViewScrollToBottom(true)
//    }
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if chat[indexPath.row]["des"] == "recieve"{
            let cell = tableView.dequeueReusableCellWithIdentifier("receive") as! receiverTableViewCell
            
          
            cell.chat.text = chat[indexPath.row]["chat"]
            cell.delivery.text = "delivered"
            cell.chat.sizeToFit()
            cell.recieverView.layer.cornerRadius = 10.0
            cell.recieverView.layer.borderWidth = 0.5
            cell.recieverView.layer.borderColor = UIColor.whiteColor().CGColor
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        }
        
         else {
            let cell = tableView.dequeueReusableCellWithIdentifier("send") as! senderTableViewCell
            let x = chat[indexPath.row]["chat"]
            
            let ans = self.httpCutter(x!).ans
            let url = self.httpCutter(x!).url
            let index = self.httpCutter(x!).index
            
            
            
            if url != ""{
                
                let attribute = NSMutableAttributedString(string: ans)
                attribute.addAttribute(NSLinkAttributeName, value: url, range: NSRange(location: index-4, length: 4))
                cell.getChat.attributedText = attribute

                cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            }
                
            else{
                
            cell.getChat.text = chat[indexPath.row]["chat"]
    
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
           
            cell.getChat.userInteractionEnabled = true
            cell.getChat.sizeToFit()
            cell.senderView.layer.cornerRadius = 10.0
            cell.senderView.layer.borderWidth = 0.5
            cell.senderView.layer.borderColor = UIColor.whiteColor().CGColor
            return cell
            
        }
    }

    @IBAction func sendButton(sender: AnyObject) {
        
        self.textView.resignFirstResponder()
        self.control.removeFromSuperview()
        var text:String=""
        let ques:String = stringCutter(chat[rowCount-1]["chat"]!)
        let add = " is "
        
        if self.textView.text! != ""{
        let x = ["des":"recieve", "chat":self.textView.text!]
        text = self.textView.text!
        chat.append(x)
        rowCount! += 1
        }
        let res:String
        if ques == "income" || ques == "savings" || ques == "HRA"{
            if let x = Int(text){
                res = ques+add+text
                print(res)
            }
            else{
                res = ""
                let x = chat[rowCount-2]
                chat.append(x)
                self.rowCount! += 1
                self.tableViewScrollToBottom(true)
                self.tableView.reloadData()
                
            }
        
        }
        else{
            res = text
        }
        if res != ""{
        AI.sharedService.TextRequest(res).success { (response) -> Void in
            // Handle success ...
//            if response.result
           
            let x = ["des":"send", "chat":(response.result.fulfillment?.speech)! as String]
            
            self.chat.append(x)
            self.rowCount! += 1
            self.tableViewScrollToBottom(true)
            self.tableView.reloadData()
            
            }.failure { (error) -> Void in
                // Handle error ...
                let x = ["des":"send", "chat":"server error"]
                self.chat.append(x)
                self.rowCount! += 1
                self.tableViewScrollToBottom(true)
                self.tableView.reloadData()
        }
        }
        tableViewScrollToBottom(true)
        tableView.reloadData()
        self.textView.text = ""
    }
    @IBAction func CamButton(sender: AnyObject) {
        
        
    }
    @IBOutlet weak var textView: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidBeginEditing(textView: UITextView) {
        self.view.frame.origin.y -= 220
//        self.controlView.addSubview(control)
//        startAnimation()
//        self.view.addSubview(self.animation)
    }
    func textViewDidEndEditing(textView: UITextView) {
         self.view.frame.origin.y += 220
    }
   
    func startAnimation(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.ControlAnimation), userInfo: nil, repeats: true)
    }
    func ControlAnimation(){
        count = count+1
        self.control.currentPage = (count)%3
//        print(self.control.currentPage)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! LinkTableViewCell
        print("tapped")
    }
    
    func dismissKeyBoard(){
        textView.resignFirstResponder()
        self.control.removeFromSuperview()
        
    }
    
    func stringCutter(s:String)->String{
        
        let x:Character = " "
        let stringToArray = Array(s.characters)
        var next:Int = 0
        var prev:Int = 0
        
        for i in 0...stringToArray.count-1{
            if stringToArray[i] == x{
                count = count+1
                next = i
                prev = next
            }
        }
        
        let ans:String = s[s.startIndex.advancedBy(next+1)..<s.endIndex]
        
        return ans
      
        
    }
    
    func httpCutter(s:String)->(ans:String,url:String,index:Int){
        let stringToArray = Array(s.characters)
        var first:Int = 0
        var last:Int = 0
        
        for i in 0...stringToArray.count-1{
            if stringToArray[i] == "["{
                
                first = i
            }
            if  stringToArray[i] == "]"{
                
                last = i
                break
            }
        }
        
        if first == 0 && last == 0{
            return (s,"",0)
        }
        let ans1 = s[s.startIndex..<s.startIndex.advancedBy(first)]
        let ans2 = s[s.startIndex.advancedBy(last+1)..<s.endIndex]
        
        let ans = ans1 + " " + ans2
        
        let url = s[s.startIndex.advancedBy(first+1)..<s.startIndex.advancedBy(last)]
        
        return (ans,url,first)
  
    }

    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        UIApplication.sharedApplication().openURL(URL)
        return true
        
    }

}


