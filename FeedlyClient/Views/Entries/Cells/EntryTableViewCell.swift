
import UIKit

class EntryTableViewCell: UITableViewCell {
    
    enum Views: String {
        case Title     = "title"
        case Summary   = "summary"
        case Author    = "author"
        case Thumbnail = "thumbnail"
        case Published = "published"
    }
    
    enum Padding: String{
        case Top    = "top"
        case Bottom = "bottom"
        case Left   = "left"
        case Right  = "right"
    }
    
    enum Width: String {
        case Thumbnail = "thumbnailWidth"
    }
    
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    
    internal var title: String? {
        get { return self.titleLabel.text }
        set(newValue) { self.titleLabel.text = newValue }
    }
    
    internal var summary: String? {
        get { return self.summaryLabel.text }
        set(newValue) { self.summaryLabel.text = newValue }
    }
    
    internal var author: String? {
        get { return self.authorLabel.text }
        set(newValue) { self.authorLabel.text = newValue }
    }
    
    internal var thumbnail: UIImage? {
        get { return self.thumbnailImageView.image }
        set(newValue) { self.thumbnailImageView.image = newValue }
    }
    
    private var _published: NSTimeInterval?
    internal var published: NSTimeInterval? {
        get { return self._published }
        set(newValue) {
            self._published = newValue
            setupPublishedLabelContent()
        }
    }
    
    internal var unread: Bool {
        get {
            return self.titleLabel.textColor == UIColor.blackColor()
        }
        set(isUnread) {
            if isUnread {
                self.titleLabel.textColor = UIColor.blackColor()
                self.summaryLabel.textColor = UIColor.darkGrayColor()
                self.authorLabel.textColor = UIColor.darkGrayColor()
                self.publishedLabel.textColor = UIColor.darkGrayColor()
            } else {
                self.titleLabel.textColor = UIColor.grayColor()
                self.summaryLabel.textColor = UIColor.grayColor()
                self.authorLabel.textColor = UIColor.grayColor()
                self.publishedLabel.textColor = UIColor.grayColor()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViews()
        
        let viewsDictionary = [
            Views.Title.rawValue     : self.titleLabel,
            Views.Summary.rawValue   : self.summaryLabel,
            Views.Author.rawValue    : self.authorLabel,
            Views.Thumbnail.rawValue : self.thumbnailImageView,
            Views.Published.rawValue : self.publishedLabel]
        
        var metrics = [
            Padding.Top.rawValue     : 5.0,
            Padding.Bottom.rawValue  : 5.0,
            Padding.Left.rawValue    : 5.0,
            Padding.Right.rawValue   : 5.0,
            Width.Thumbnail.rawValue : 50.0]
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            metrics[Padding.Top.rawValue] = 15.0
            metrics[Padding.Bottom.rawValue] = 15.0
            metrics[Padding.Left.rawValue] = 20.0
            metrics[Padding.Right.rawValue] = 20.0
            metrics[Width.Thumbnail.rawValue] = 150.0
        }
        
        //thumbnail  title
        //           summary
        //           author published
        
        // http://commandshift.co.uk/blog/2013/01/31/visual-format-language-for-autolayout/
        // https://www.hackingwithswift.com/read/6/3/auto-layout-in-code-addconstraints
        
        /*
        "V:|-5-[title]-5-[summary]-5-[author]-(>=5)-|",
        "V:|-5-[title]-5-[summary]-5-[published]-(>=5)-|",
        "V:|-5-[thumbnail(50)]-(>=5)-|"))
        
        "H:|-5-[thumbnail(50)]-5-[title]  -5-|",
        "H:|-5-[thumbnail]    -5-[summary]-5-|",
        "H:|-5-[thumbnail]    -5-[author] -5-[published]-(>=5)-|"
        */
        
        let verticalAlignments = [
            "V:|-\(Padding.Top.rawValue)-[\(Views.Title.rawValue)]-5-[\(Views.Summary.rawValue)]-5-[\(Views.Author.rawValue)]-(>=\(Padding.Bottom.rawValue))-|",
            "V:|-\(Padding.Top.rawValue)-[\(Views.Title.rawValue)]-5-[\(Views.Summary.rawValue)]-5-[\(Views.Published.rawValue)]-(>=\(Padding.Bottom.rawValue))-|",
            "V:|-\(Padding.Top.rawValue)-[\(Views.Thumbnail.rawValue)(50)]-(>=\(Padding.Bottom.rawValue))-|"]
        
        let horizontalAlignments = [
            "H:|-\(Padding.Left.rawValue)-[\(Views.Thumbnail.rawValue)(\(Width.Thumbnail.rawValue))]-5-[\(Views.Title.rawValue)]-\(Padding.Right.rawValue)-|",
            "H:|-\(Padding.Left.rawValue)-[\(Views.Thumbnail.rawValue)]-5-[\(Views.Summary.rawValue)]-\(Padding.Right.rawValue)-|",
            "H:|-\(Padding.Left.rawValue)-[\(Views.Thumbnail.rawValue)]-5-[\(Views.Author.rawValue)]-5-[\(Views.Published.rawValue)]-(>=\(Padding.Right.rawValue))-|"]
        
        for alignment in (verticalAlignments + horizontalAlignments) {
            self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(alignment, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary))
        }
    }
    
    private func setupPublishedLabelContent() {
        if self.published != nil {
            self.publishedLabel.text = self.formatPublishedDate(self.published!)
        } else {
            self.publishedLabel.text = ""
        }
    }
    
    private func formatPublishedDate(publishedAsIntervalSince1970: NSTimeInterval) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd";
        
        return dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: publishedAsIntervalSince1970))
    }
    
    private func setupViews() {
        self.setupTitleLabel()
        self.setupSummaryLabel()
        self.setupAuthorLabel()
        self.setupPublishedLabel()
        self.setupThumbnailLabel()
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.summaryLabel)
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.publishedLabel)
        self.contentView.addSubview(self.thumbnailImageView)
    }
    
    private func setupTitleLabel() {
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.titleLabel.font = UIFont(name: "Helvetica", size: 14)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSummaryLabel() {
        self.summaryLabel.numberOfLines = 0
        self.summaryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.summaryLabel.font = UIFont(name: "Helvetica", size: 10)
        
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupAuthorLabel() {
        self.authorLabel.font = UIFont(name: "Helvetica", size: 10)
        
        self.authorLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPublishedLabel() {
        self.publishedLabel.font = UIFont(name: "Helvetica", size: 10)
        
        self.publishedLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupThumbnailLabel() {
        self.thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
