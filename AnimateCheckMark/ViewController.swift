//
//  ViewController.swift
//  AnimateCheckMark
//
//  Created by Duncan Champney on 4/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var checkmarkView: CheckmarkView!
    @IBOutlet weak var showCheckmarkSwitch: UISwitch!
    @IBOutlet weak var animateSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func handleShowCheckmarkSwitch(_ sender: UISwitch) {
        checkmarkView.showCheckmark(showCheckmarkSwitch.isOn, animated: animateSwitch.isOn)
    }
}

