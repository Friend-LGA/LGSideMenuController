//
//  OtherViewController.swift
//  LGSideMenuControllerDemo
//

class OtherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var numberOfCells: Int = 100

    // MARK: -

    @IBAction func showChooseController(sender: Any) {
        let storyboard = UIStoryboard(name: "Choose", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? ChooseNavigationController else { return }

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.numberOfCells -= 1
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
