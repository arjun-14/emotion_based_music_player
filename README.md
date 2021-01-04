# Beyond the Melody
Flutter application that can detect emotion and recommend a playlist as per the detected emotion.

![](working.gif)



## Setup
1. Obtain azure and youtube api keys and add them inside ```lib\utilities\keys.dart```.
2. Playlists are predefined in youtube. If you wish to use your own, you can provide the playlist id inside ```lib\utilites\playlistID.dart```
3. ```$ flutter run```

## Emotions detected
- happiness
- sadness
- neutral
- anger
- contempt
- disgust
- fear
- surprise
