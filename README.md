# iosmap

THINGS TO DO

CLICKING ON BUTTON makes a a UICollectionView that holds a UITableView popup: https://gyazo.com/ff0ea4fb6bc53d110bb18da8bcf5afeb
-no note part for now
-cityname is the cityname that is set when selecting a UITableView Element from side menu, so if nil, no element from side menu has been selected
-Same for pointarray. pointArray is nil if no element from side menu clicked but is filled with points from city when element is clicked
  -Each point has a lat lng, name, and address. Will eventually have index for icon in assets.xcassets but for now can you import a       default pic to make it replacable for when I have icons
 
So when button is clicked, the popup shown in pic(has round edges) is shown over map, and clicking on a point in the Popup UITableview closes the popup and centers the google map camera around that points lat and lng. P1, P2 ... being where the name is and the address of the place like underneath it. If possible the icon of the point on left of name and address with padding.

Line 90 is where I would start since it is right after the user clicked on all button on map


Clustering part:
Points I want to be clustered are stored as points in a pointArray, each point should look like this: https://gyazo.com/1629fde9a5006d607bbf1a1cf856eccb
Like above, should be rendered after a UITableView element is clicked in side menu, which is when points from that cityname are put into pointArray.


can you setup clustering by making a marker that looks like one shown in pic for each point in the pointarray using its lat and lng and I will eventually make each point have a pic but for now can you make the pic a default pic.


Line ___ is where I would start since it is right after the user clicked on element in side menu
