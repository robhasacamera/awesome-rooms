//
//  TitleClockViewController.swift
//  Awesome Rooms
//
//  Created by Robert J Cole on 9/21/18.
//  Copyright © 2018 Robert Cole. All rights reserved.
//

import UIKit

class TitleClockViewController: UIViewController {
    @IBOutlet weak var clockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            let now = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm:ss a"
            
            self.clockLabel.text = dateFormatter.string(from: now)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
