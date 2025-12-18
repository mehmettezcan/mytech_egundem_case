class Endpoints {
  Endpoints._();

  // Users
  static String get users => '/users';

  // signIn
  static String get signIn => '$users/login';

  // profile
  static String get profile => '$users/profile';

  // categories
  static String get categories => '/categories';

  // category with news
  static String get categoryNews => '$categories/with-news';

    // news
  static String get news => '/news';

  // news by category
  static String get newsByCategory => '$news/category';

  // saved news
  static String get savedNews => '/saved-news';

  // twitter
  static String get twitterTweets => '/twitter/tweets';

  // sources
  static String get sources => '/sources';

  // sources search
  static String get sourcesSearch => '$sources/search';

  // sources followed
  static String get sourcesFollowed => '$sources/followed';

  // sources follow bulk
  static String get sourcesFollowBulk => '$sources/follow/bulk';
}
