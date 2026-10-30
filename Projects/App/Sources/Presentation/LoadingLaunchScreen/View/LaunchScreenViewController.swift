//
//  LaunchScreenViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.startAnimating()
    }
}
