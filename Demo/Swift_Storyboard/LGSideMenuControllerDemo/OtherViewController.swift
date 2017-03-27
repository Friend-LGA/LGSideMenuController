//
//  OtherViewController.swift
//  LGSideMenuControllerDemo
//

class OtherViewController: UITableViewController {

    private var numberOfCells = 100 as Int

    // MARK: -

    @IBAction func showChooseController(sender: Any) {
        let storyboard = UIStoryboard(name: "Choose", bundle: nil)

        let navigationController = storyboard.instantiateInitialViewController() as! ChooseNavigationController

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            numberOfCells -= 1
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
