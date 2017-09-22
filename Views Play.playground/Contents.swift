//: A UIKit based Playground to present user interface
  
import UIKit
import PlaygroundSupport
//import TimerViewsGear

class myViewController : UIViewController {

    override func loadView() {
        let view = UIView()

        let label = UILabel()
        label.text = "Hello World!"
        label.textColor = .white
        
        view.addSubview(label)
        self.view = view
    }
   
}

PlaygroundPage.current.liveView = myViewController()
