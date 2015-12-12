
import UIKit

// http://bcdilumonline.blogspot.ro/2015/03/add-uicollectionview-to-xib-with-custom.html
class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set what preferredMaxLayoutWidth you want
        //contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets
    }
    
    func configCell(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
        
        if content == ""{
            
        }
        if title == "" {
            
        }
        //titleLabel.font = UIFont(name: titleFont, size: 18)
        //contentLabel.font = UIFont(name: contentFont, size: 16)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
