//
//  FoodPreferencesViewController.swift
//  Mezzo-1.0
//
//  Created by Heejung Chung on 7/30/15.
//  Copyright (c) 2015 MezzoAwesomeness. All rights reserved.
//

import UIKit
import Parse

class FoodPreferencesViewController: UIViewController {

    // MARK: Outlets and Properties
    
    weak var selectedDayButton: UIButton!
    @IBOutlet var weekdayButtons: [UIButton]!
    
    @IBOutlet weak var unavailableOptionButton: UIButton!
    @IBOutlet weak var availableOptionButton: UIButton!
    
    @IBOutlet weak var fromTimePicker: UIDatePicker!
    @IBOutlet weak var toTimePicker: UIDatePicker!
    
    @IBOutlet weak var timePickingContentView: UIView!
    
    var weeklyHours: [String : (start: NSDate?, end: NSDate?)] = [:]
    let weekDaySymbols = ["S", "M", "T", "W", "Th", "F", "Sa"]
    
    /// default date formatter for String <-> NSdate conversion
    var formatter: NSDateFormatter {
        get {
            let returnable = NSDateFormatter()
            returnable.dateFormat = "hh:mm a"
            return returnable
        }
    }
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let orgUser = (PFUser.currentUser() as? User)?.organization {
            orgUser.fetchIfNeededInBackgroundWithBlock { result, error -> Void in
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                } else {
                    self.loadAllDateSettings()
                    
                    self.selectedDayButton = self.weekdayButtons.filter { $0.titleLabel!.text == "M" }[0]
                    self.toggleDayButton(self.selectedDayButton, select: true)
                    self.showSettingsForDay(self.selectedDayButton)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        
    }
    
    // MARK: UI change methods
    
    /// load strings from parse into local weeklyHours property + toggle unavailable day buttons
    func loadAllDateSettings() {
        if let orgUser = (PFUser.currentUser() as? User)?.organization {
            for index in 0..<(orgUser.weeklyHours as [String]).count {
                // get separate date strings
                let dateStrings = orgUser.weeklyHours[index].componentsSeparatedByString(", ")
                
                // load into weely hours dictionary
                let startDate = formatter.dateFromString(dateStrings[0])
                let endDate = formatter.dateFromString(dateStrings[1])
                weeklyHours[weekDaySymbols[index]] = (startDate, endDate)
                
                // set gray background for all unavailable days
                let dayButton = self.weekdayButtons.filter {
                    $0.titleLabel!.text! == self.weekDaySymbols[index]
                }
                let available = startDate != nil && endDate != nil
                toggleAvailabilityForDayButton(dayButton[0], available: available)
            }
            
            
        }
    }

    @IBAction func weekDayButtonTapped(sender: UIButton) {
        // save current day's settings
        saveDateSettingsForDay(selectedDayButton)
        
        // set former day button to deselected
        toggleDayButton(selectedDayButton, select: false)
        
        // select new day button
        toggleDayButton(sender, select: true)
        selectedDayButton = sender
        
        showSettingsForDay(selectedDayButton)
    }
    
    @IBAction func availabilityToggled(sender: UIButton) {
        let available = sender == availableOptionButton
        toggleAvailabilityForDayButton(selectedDayButton, available: available)
        availableOptionButton.selected = available
        unavailableOptionButton.selected = !available
        timePickingContentView.hidden = !available
    }
    
    /// toggle selection of day button (border)
    func toggleDayButton(button: UIButton, select: Bool) {
        button.layer.borderWidth = select ? 3.0 : 0.0
        button.layer.borderColor = UIColor(red: 0, green: 84.0/255.0, blue: 180.0/255.0, alpha: 1.0).CGColor
    }
    
    /// toggle availability indicator (background color)
    func toggleAvailabilityForDayButton(button: UIButton, available: Bool) {
        if available {
            button.backgroundColor = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            button.backgroundColor = UIColor.lightGrayColor()
            button.setTitleColor(UIColor.lightTextColor(), forState: UIControlState.Normal)
        }
    }

    /// set availability checkmarks + toggle enabled of datepickers
    func showSettingsForDay(button: UIButton!) {
        let datesTuple = weeklyHours[button.titleLabel!.text!]
        if let startDate = datesTuple?.start, endDate = datesTuple?.end {
            
            fromTimePicker.date = startDate
            toTimePicker.date = endDate
            
            resetDatePickerMinsAndMaxes()
            
            availabilityToggled(availableOptionButton)
            
        } else {
            availabilityToggled(unavailableOptionButton)
        }
    }
    
    func resetDatePickerMinsAndMaxes() {
        
    }
    
    func saveDateSettingsForDay(button: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}