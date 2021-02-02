//
//  ViewController.swift
//  LGSideMenuControllerDemo
//

class ViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let imageView: UIImageView
    private let button: UIButton
    private let tableView: UITableView?
    private var numberOfCells: Int = 100

    convenience init() {
        self.init(withTableView: false)
    }

    init(withTableView: Bool = false) {
        self.imageView = UIImageView(image: UIImage(named: "imageRoot"))
        self.imageView.contentMode = .scaleAspectFill

        if withTableView {
            self.tableView = UITableView()
            self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        } else {
            self.tableView = nil
        }

        self.button = UIButton()
        self.button.setTitle("Show Choose Controller", for: .normal)
        self.button.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0), for: .highlighted)

        super.init(nibName: nil, bundle: nil)

        self.title = "LGSideMenuController"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .plain, target: self, action: #selector(showRightView(sender:)))

        self.view.addSubview(self.imageView)

        if let tableView = self.tableView {
            tableView.delegate = self
            tableView.dataSource = self
            self.view.addSubview(tableView)
        }

        self.button.addTarget(self, action: #selector(showChooseController), for: .touchUpInside)
        self.view.addSubview(self.button)

        self.setColors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let buttonHeight: CGFloat = 44.0

        self.imageView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height)
        self.button.frame = CGRect(x: 0.0, y: view.frame.size.height - buttonHeight, width: view.frame.size.width, height: buttonHeight)

        self.tableView?.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height - buttonHeight);
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setColors()
    }

    // MARK: -

    func setColors() {
        self.button.backgroundColor = UIColor(white:(isLightTheme() ? 1.0 : 0.0), alpha: 0.75)
        self.button.setTitleColor((isLightTheme() ? .black : .white), for: .normal)
        self.tableView?.backgroundColor = UIColor(white: (isLightTheme() ? 1.0 : 0.0), alpha: 0.5)
    }

    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }

    @objc func showRightView(sender: AnyObject?) {
        sideMenuController?.showRightView(animated: true, completionHandler: nil)
    }

    @objc func showChooseController() {
        let navigationController = ChooseNavigationController()

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.accessoryType = .none
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel!.text = "You can delete me by swiping"
        cell.backgroundColor = .clear

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

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
