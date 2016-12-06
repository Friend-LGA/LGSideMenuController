//
//  ViewController.swift
//  LGSideMenuControllerDemo
//

class ViewController : UIViewController {

    @IBAction func showChooseController(sender: Any) {
        let storyboard = UIStoryboard(name: "Choose", bundle: nil)

        let navigationController = storyboard.instantiateInitialViewController() as! ChooseNavigationController

        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = navigationController

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

}
