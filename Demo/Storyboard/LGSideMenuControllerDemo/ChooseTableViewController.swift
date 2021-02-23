//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class ChooseTableViewController: UITableViewController {

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.text = DemoType(rawValue: indexPath.row)?.description
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let mainViewController = storyboard.instantiateInitialViewController() as? MainViewController else { return }

        mainViewController.setup(type: DemoType(rawValue: indexPath.row)!)

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}
