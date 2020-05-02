import 'package:beyondthemelody/youtube/models/video_model.dart';
import 'package:beyondthemelody/utilities/playlistID.dart';

class Channel {

  final String id;
  final String title;
  final String profilePictureUrl;
  final String subscriberCount;
  final int videoCount;
  final String uploadPlaylistId;
  List<Video> videos;

  Channel({
    this.id,
    this.title,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      //videoCount: map['statistics']['videoCount'],
      videoCount: playlistId['anger'].length,
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
      //uploadPlaylistId: playlistId['happiness'],
    );
  }

}