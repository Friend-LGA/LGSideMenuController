//
//  OtherViewController.swift
//  LGSideMenuControllerDemo
//

class OtherViewController: UITableViewController {

    private var numberOfCells = 100 as Int

    init() {
        super.init(style: .plain)

        title = "LGSideMenuController"

        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(showChooseController))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: -

    func showChooseController() {
        let navigationController = ChooseNavigationController()

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.accessoryType = .none
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = "You can delete me by swipe"

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

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
