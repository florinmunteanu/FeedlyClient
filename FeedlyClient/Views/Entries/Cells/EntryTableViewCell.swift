
import UIKit

class EntryTableViewCell: UITableViewCell {
    /*
    var imgUser = UIImageView()
    var labUerName = UILabel()
    var labMessage = UILabel()
    var labTime = UILabel()
    */
    
    //var entry: Entry? = nil
    
    //var title: String? = nil
    //var summary: String? = nil
    //var author: String? = nil
    
    var titleLabel = UILabel()
    var summaryLabel = UILabel()
    var authorLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //self.titleLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
        self.titleLabel.font = UIFont(name: "Helvetica", size: 12)
        
        self.summaryLabel.numberOfLines = 0
        self.summaryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.summaryLabel.font = UIFont(name: "Helvetica", size: 10)
        self.summaryLabel.textColor = UIColor.darkGrayColor()
        
        self.titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.summaryLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.authorLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(summaryLabel)
        self.contentView.addSubview(authorLabel)
        
        var viewsDictionary = ["title" : titleLabel, "summary" : summaryLabel, "author" : authorLabel]
        
        //picture   title
        //          first 25
        //          source icon, source name
        
        
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[author(10)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title]-[summary]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title]-[author(10)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[summary]-[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        //self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[title]-[summary]-[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title]-[summary]-[author]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.titleLabel.preferredMaxLayoutWidth = 280//self.bounds.size.width - 10
        self.summaryLabel.preferredMaxLayoutWidth = 280
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
