//
//  DetailViewController.swift
//  calendar


import UIKit

class DetailViewController: UIViewController {

    var nameTask: String?
    var dateTask: String?
    var timeTask: String?
    var descriptionTask: String?

    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailTime: UILabel!
    @IBOutlet weak var detailDescription: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let nameTask = self.nameTask else { return }
        detailName.text = nameTask
        detailDate.text = dateTask
        detailTime.text = timeTask
        detailDescription.text = descriptionTask

    }

    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }

}
