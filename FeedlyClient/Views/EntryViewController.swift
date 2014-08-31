
import Foundation

/*
// Set the current feedly user token
//CurrentFeedlyUser.token = userToken
/*FeedlyCategories().beginGetCategories(userToken.accessToken,
success: {([Category]) -> Void in

},
failure: {(NSError) -> Void in

})*/
//FeedlySubscriptions().beginGetSubscriptions(userToken.accessToken,
//    success: {([Subscription]) -> Void in
//
//    }, failure: {(NSError) -> Void in
//})
//var options = StreamSearchOptions()
//options.accessToken = userToken.accessToken
//FeedlyStreams().beginGetStream(
//    "feed/https://developer.apple.com/swift/blog/news.rss",
//    options: options,
//    success: {
//       (stream: Stream) -> Void in
//
//    },
//    failure: { (error: NSError) -> Void in
//})
/*entries = 12 values {
[0] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_14818d7b4e5:ca31:23535a44"
[1] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147f0bdae0d:1480d:1be42e7e"
[2] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147db9610ac:5a88:e0e8dc38"
[3] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147b75f294a:6a2c9:bda086f"
[4] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147a8a73a35:36f1a:bda086f"
[5] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1479397e732:ba:bda086f"
[6] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1477e63e58e:13f8:d9c45486"
[7] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1476575ba31:46d22:cdf4c12c"
[8] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1474bfa2ab5:210f:cdf4c12c"
[9] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_1473af76e80:45a8e:899a63a0"
[10] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147265dfe80:45a8d:899a63a0"
[11] = "vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_147265dfe80:45a8c:899a63a0"*/
FeedlyEntries().beginGetEntry("vcyf1G8Elosuw95ihMv8g5cbteSzYO7qyleXrM6tPEM=_14818d7b4e5:ca31:23535a44",
accessToken: userToken.accessToken,
success: {
(entry: Entry) -> Void in

}, failure: { (error:NSError) -> Void in

})

*/