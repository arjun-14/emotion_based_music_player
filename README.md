This is a flutter application that can detect emotion and recommend a playlist as per the detected emotions.
Microsoft's azure api is used to detect emotion and youtube api for recommending playlist to combat copyright restrictions.

To run the app you would need an azure apikey as well as youtube api key.
Create a file keys.dart under utilities in lib folder and add your respective api key as follows.
final String kAzureApiKey = '';
final String kYoutubeApiKey = '';

Working can be observed here- https://drive.google.com/file/d/197YUZPsIbWWt16GsmVL1z-XuR95gJgfG/view?usp=sharing
