
import UIKit

class EntryTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var summaryLabel = UILabel()
    var authorLabel = UILabel()
    var thumbnailImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.titleLabel.font = UIFont(name: "Helvetica", size: 14)
        //self.titleLabel.preferredMaxLayoutWidth = self.bounds.size.width - 10
        
        self.summaryLabel.numberOfLines = 0
        self.summaryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.summaryLabel.font = UIFont(name: "Helvetica", size: 10)
        self.summaryLabel.textColor = UIColor.darkGrayColor()
        //self.summaryLabel.preferredMaxLayoutWidth = self.bounds.size.width - 10
        
        self.authorLabel.font = UIFont(name: "Helvetica", size: 10)
        self.authorLabel.textColor = UIColor.darkGrayColor()
        
        self.titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.summaryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.authorLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.thumbnailImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.summaryLabel)
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.thumbnailImageView)
        
        var viewsDictionary = ["title" : self.titleLabel, "summary" : self.summaryLabel, "author" : self.authorLabel, "thumbnail" : self.thumbnailImageView]
        
        //picture   title
        //          first 25
        //          source icon, source name
        
        
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[author(10)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title]-[summary]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-[author(10)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[summary]-[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[title]-[summary]-[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        
        // http://commandshift.co.uk/blog/2013/01/31/visual-format-language-for-autolayout/
        
        // Vertical alignment
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[title]-5-[summary]-5-[author]-(>=5)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[thumbnail(50)]-(>=5)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        
        // Horizontal alignment
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[thumbnail(50)]-5-[title]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[thumbnail]-5-[summary]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[thumbnail]-5-[author]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
     /*
                "H:|-5-[image(40)]-5-[title]-5-|",
                "H:|-5-[image]-5-[body]-5-|",
                "V:|-5-[title]-5-[body]-(>=5)-|",
                "V:|-5-[image(41)]-(>=5)-|"))
     */
    }
    
    /*
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func updateConstraints() {
    super.updateConstraints()
    
    }

    
    override func layoutSubviews() {
        if thumbnailImageView.image == nil {
            self.titleLabel.preferredMaxLayoutWidth = 0
            self.summaryLabel.preferredMaxLayoutWidth = 0
            self.thumbnailImageView.frame = CGRectMake(0, 0, 0, 0)
            
        } else {
            //super.layoutSubviews()
            self.titleLabel.preferredMaxLayoutWidth = self.bounds.size.width - 150
            self.summaryLabel.preferredMaxLayoutWidth = self.bounds.size.width - 150
            //super.layoutSubviews()
            self.thumbnailImageView.frame = CGRectMake(0, 0, 150, 50)
            //super.layoutSubviews()
        }
        super.layoutSubviews()
    }
    */
}
