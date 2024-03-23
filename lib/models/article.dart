
class Article {
  final int id;
  final String title;
  final String alias;
  final String description;
  final dynamic content;
  final bool hasFee;
  final String imageUrl;
  final int likes;
  final int views;
  final int comments;
  final String status;
  final int royalties;
  final List<String> hashtag;
  final List<String> categories;
  final String postedAt;
  final Object listComment;
  final Object createdBy;
  final bool userLiked;
  final String articleLink;
  final String source;
  final String stocks;

  Article({
    required this.alias,
    required this.likes,
    required this.views,
    required this.comments,
    required this.royalties,
    required this.hashtag,
    required this.categories,
    required this.listComment,
    required this.createdBy,
    required this.userLiked,
    required this.articleLink,
    required this.source,
    required this.stocks,
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.hasFee,
    required this.imageUrl,
    required this.status,
    required this.postedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      alias: json['alias'],
      description: json['description'],
      content: json['content'],
      hasFee: json['hasFee'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      views: json['views'],
      comments: json['comments'],
      status: json['status'],
      royalties: json['royalties'],
      hashtag: json['hashtag'],
      categories: json['categories'],
      postedAt: json['postedAt'],
      listComment: json['listComment'],
      createdBy: json['createdBy'],
      userLiked: json['userLiked'],
      articleLink: json['articleLink'],
      source: json['source'],
      stocks: json['stocks'],
    );
  }
}
