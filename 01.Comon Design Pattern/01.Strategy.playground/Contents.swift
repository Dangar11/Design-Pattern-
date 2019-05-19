import UIKit

/*:
 
 ![alternate text ](Strategy_Diagram.png)
 
 */

//<Protocol> Strategy
public protocol MovieRatingStrategy {
  
  //Show wich Service provide rating "Rotten Tomatoes"
  var ratingServiceName: String { get }
  
  //2
  func fetchRating(for movieTitle: String, success: (_ rating: String, _ review: String) -> ())
}


//Concreate Strategy 1
//CLIENT: - ROTTEN TOMATOES
public class RottenTomatoesClien: MovieRatingStrategy {
  
  public var ratingServiceName = "Rotten Tomatoes"
  
  public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
    //make some network request for ratings...
    //Set dummy values for this service
    
    
    let rating = "95%"
    let review = "It rocked"
    success(rating, review)
  }
}



//Concreate Strategy 2
//CLIENT: - IMDbClient


public class IMDbClient: MovieRatingStrategy {
  
  public var ratingServiceName = "IMDb"
  
  public func fetchRating(for movieTitle: String, success: (String, String) -> ()) {
    
    
    let rating = "3 / 10"
    let review = "It was terrible! The audience was throwing rotten tomatoes!"
    success(rating, review)
  }
}



//Object using a Strategy

public class MoviewRatingVC: UIViewController {
  
  //MARK: - Properties
  public var movieRatingClient: MovieRatingStrategy!
  
  // MARK: - Outlets
  @IBOutlet public var movieTitleTextField: UITextField!
  @IBOutlet public var ratingServiceNameLabel: UILabel!
  @IBOutlet public var ratingLabel: UILabel!
  @IBOutlet public var reviewLabel: UILabel!
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    ratingServiceNameLabel.text = movieRatingClient.ratingServiceName
  }
  
  @IBAction public func searchButtonPressed(sender: Any) {
    guard let moviewTitle = movieTitleTextField.text else { return }
    
    movieRatingClient.fetchRating(for: moviewTitle) { (rating, review) in
      self.ratingLabel.text = rating
      self.reviewLabel.text = review
    }
  }
  
}
