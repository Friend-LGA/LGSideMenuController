//
//  TableViewController.swift
//  LGSideMenuControllerDemo
//

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
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }

        if (indexPath.row == self.titlesArray.count - 2) {
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "OtherViewController")], animated: false)
        }
        else {
            navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "ViewController")], animated: false)
        }
        
        guard let mainViewController = storyboard.instantiateInitialViewController() as? MainViewController else { return }

        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: DemoType(rawValue: indexPath.row)!)

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController

        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}
