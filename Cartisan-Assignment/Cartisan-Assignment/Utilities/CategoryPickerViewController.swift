//
//  CategoryPickerViewController.swift
//  Cartisan-Assignment
//
//  Created by Deepak Sharma on 23/11/16.
//  Copyright © 2016 Deepak Sharma. All rights reserved.
//

import UIKit

protocol CategoryPickerViewControllerDelegate: class {
    func serachResults(forCategory categoryID: String?)
}

class CategoryPickerViewController: UIViewController {
    
    weak var delegate: CategoryPickerViewControllerDelegate?
    
    var selectedID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func search(_ sender: Any) {
        delegate?.serachResults(forCategory: selectedID)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPicker(onViewController viewController: UIViewController) {
        viewController.addChildViewController(self)
        self.view.frame = viewController.view.frame
        viewController.view.addSubview(self.view)
        self.didMove(toParentViewController: viewController)
    }

    func removePicker()  {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}


extension CategoryPickerViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension CategoryPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category(rawValue: row)?.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedID = Category(rawValue: row)?.id
    }
}
