
import UIKit
import MapKit

class WCCell: UICollectionViewCell {

    static let reuseIdentifier = "StationCell.reuseIdentifier"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var slotsLabel: UILabel!
    @IBOutlet weak var bikesLabel: UILabel!
    @IBOutlet weak var stationPin: UIView!

    override func awakeFromNib() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        imageView.alpha = 0.0
        stationPin.alpha = 0.0
        slotsLabel.text = ""
        bikesLabel.text = ""
        stationPin.layer.cornerRadius = stationPin.bounds.width/2.0
        stationPin.layer.borderColor = UIColor.white.cgColor
        stationPin.layer.borderWidth = 1.5
        activityIndicator.startAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.alpha = 0.0
        imageView.image = nil
        stationPin.alpha = 0.0
        slotsLabel.text = ""
        bikesLabel.text = ""
        activityIndicator.startAnimating()
    }

    func configure(_ wc: WC) {

        streetLabel.text = "\(wc.name)"

        let options = MKMapSnapshotOptions()
        options.region = MKCoordinateRegionMakeWithDistance(wc.coordinate, 500, 500)
        options.mapType = .satellite
        MKMapSnapshotter(options: options).start(with: DispatchQueue.global(qos: .background)) { (snapshot, error) in

            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                self.imageView.alpha = 0.0
                self.stationPin.alpha = 0.0
                self.imageView.image = snapshot.image
                UIView.animate(withDuration: 0.2, animations: {
                    self.imageView.alpha = 1.0
                    self.stationPin.alpha = 1.0
                    self.activityIndicator.stopAnimating()
                })
            }
        }
    }
}
