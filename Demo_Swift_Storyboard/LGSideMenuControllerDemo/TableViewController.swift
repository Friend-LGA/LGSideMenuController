//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//

class TableViewController: UITableViewController {

    private let titlesArray = ["Style \"Scale From Big\"",
                               "Style \"Slide Above\"",
                               "Style \"Slide Below\"",
                               "Style \"Scale From Little\"",
                               "Blurred root view cover",
                               "Blurred side views covers",
                               "Blurred side views backgrounds",
                               "Landscape always visible",
                               "Status bar always visible",
                               "Gesture area full screen",
                               "Editable table view",
                               "Custom style"]

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
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController

        if (indexPath.row == self.titlesArray.count - 2) {
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "OtherViewController")], animated: false)
        }
        else {
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
        }
        
        let mainViewController = storyboard.instantiateInitialViewController() as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(indexPath.row))

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}
