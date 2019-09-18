#Maintenance Manual
####1. Dowload Project from BitBucket
####2. Dowload SDK 100.0 from: 
 https://developers.arcgis.com/ios/latest/  
####3. Opening the project
  Open the project with Xcode by clicking on the RoomQuest_v3.xcodeproj  
####4. Replacing the ArcGIS.bundle
First, delete the ArcGIS.bundle. Then add another ArcGIS.bundle by doing the following:
   * Click on file > Add files to "RoomQuest_v3"
   * From home directory go to library > SDKs > ArcGIS > iOS > Frameworks > Static > ArcGIS.framework > Resources > ArcGIS.bundle
   * Click the bundle and add it to the project
####5. Installing Cocoapods 
On your terminal type "sudo gem install cocoapods", that'll install cocoapods if you haven't installed it yet
####6.  Creating a Podfile
Open up a new project or your current one and create a NEW BLANK FILE named Podfile. It should be stored in your project's folder. Then open up Podfile and insert the following:



    Target "RoomQuest_v3” do
    pod 'ArcGIS-Runtime-SDK-iOS', '100.0'
    end
    
The stuff between the quotes is your projects name. After you save that, go to your terminal and navigate to the directory where the Podfile is located in.
####7. Installing the Pods
Now, type in your terminal "pod install" and it'll install all the frameworks for you
####8. Selecting the correct file
Close your workspace and it'll tell you to only use the file "projectname.xcworkspace". Don't use the file with extension .xcodeproj. Cocoapods will only work with xcworkspace extensions
####9. Downloading Pulse Secure
Download Pulse Secure and login, then you can run app and see the layers. Logging in is NEEDED to see the layers.

####Configuring your Apple Device
1. Download Pulse Secure on iPhone, and login. 
2. Plug phone in to computer and change run settings in Xcode to connect to device plugged in
3. Press play on Xcode


-------
If extra help is needed, refer to the follow [guide](https://developers.arcgis.com/ios/latest/swift/guide/introduction.htm).
