//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//

import Foundation
import UIKit

class ChooseTableViewController: UITableViewController {

    private let titlesArray = ["Style \"Scale From Big\"",
                               "Style \"Slide Above\"",
                               "Style \"Slide Below\"",
                               "Style \"Scale From Little\"",
                               "Blurred root view cover",
                               "Blurred covers of side views",
                               "Blurred backgrounds of side views",
                               "Landscape is always visible",
                               "Status bar is always visible",
                               "Gesture area is full screen",
                               "Concurrent touch actions",
                               "Custom style example"]

    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = titlesArray[indexPath.row]
        
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
