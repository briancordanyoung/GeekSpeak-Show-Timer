class Settings: UIViewController {
  
  
  @IBAction func hideSettingButton(sender: AnyObject) {
    self.splitViewController?.toggleMasterView()
  }
  
  
  
  
}