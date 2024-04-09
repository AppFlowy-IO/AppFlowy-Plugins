import 'package:flutter/rendering.dart';

import 'package:af_link_preview/af_link_preview.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

enum LinkPreviewRegex {
  title,
  description,
  image;
}

class LinkPreviewData {
  const LinkPreviewData({
    this.title,
    this.description,
    this.imageUrl,
  });

  final String? title;
  final String? description;
  final String? imageUrl;

  factory LinkPreviewData.fromPreviewData(PreviewData data) {
    return LinkPreviewData(
      title: data.title,
      description: data.description,
      imageUrl: data.image?.url,
    );
  }

  factory LinkPreviewData.fromJson(Map<String, dynamic> json) {
    return LinkPreviewData(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}

/// parse the url link to get the title, description, image
class LinkPreviewParser {
  LinkPreviewParser({
    required this.url,
    this.cache,
  });

  final String url;
  final LinkPreviewDataCacheInterface? cache;

  LinkPreviewData? metadata;

  /// must call this method before using the other methods
  Future<void> start() async {
    try {
      metadata = await cache?.get(url);
      if (metadata != null) {
        // refresh the cache on background
        getPreviewData(url).then(
          (value) => cache?.set(
            url,
            LinkPreviewData.fromPreviewData(value),
          ),
        );
        return;
      }
      metadata = LinkPreviewData.fromPreviewData(
        await getPreviewData(url),
      );
      cache?.set(
        url,
        metadata!,
      );
    } catch (e) {
      debugPrint(e.toString());
      metadata = null;
    }
  }

  String? getContent(LinkPreviewRegex regex) {
    if (metadata == null) {
      return null;
    }

    return switch (regex) {
      LinkPreviewRegex.title => metadata?.title,
      LinkPreviewRegex.description => metadata?.description,
      LinkPreviewRegex.image => metadata?.imageUrl,
    };
  }
}
