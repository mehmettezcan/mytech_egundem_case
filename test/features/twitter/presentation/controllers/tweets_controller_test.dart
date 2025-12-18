import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/features/twitter/data/models/tweet_item.dart';
import 'package:mytech_egundem_case/features/twitter/data/twitter_repository.dart';
import 'package:mytech_egundem_case/features/twitter/di/twitter_provider.dart';
import 'package:mytech_egundem_case/features/twitter/presentation/controllers/tweets_controller.dart';

class MockTwitterRepository extends Mock implements TwitterRepository {}

void main() {
  group('TweetsController', () {
    late MockTwitterRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockTwitterRepository();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create paging controller for popular tweets', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          twitterRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final controller = container.read(
        tweetsControllerProvider(TweetFeedType.popular),
      );

      // Assert
      expect(controller.pagingController, isNotNull);
      expect(controller.type, equals(TweetFeedType.popular));
    });

    test('should create paging controller for forYou tweets', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          twitterRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final controller = container.read(
        tweetsControllerProvider(TweetFeedType.forYou),
      );

      // Assert
      expect(controller.pagingController, isNotNull);
      expect(controller.type, equals(TweetFeedType.forYou));
    });

    test('should have correct page size constant', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          twitterRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final controller = container.read(
        tweetsControllerProvider(TweetFeedType.popular),
      );

      // Assert
      expect(TweetsController.pageSize, equals(10));
    });

    test('should have correct type for different feed types', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          twitterRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final popularController = container.read(
        tweetsControllerProvider(TweetFeedType.popular),
      );
      final forYouController = container.read(
        tweetsControllerProvider(TweetFeedType.forYou),
      );

      // Assert
      expect(popularController.type, equals(TweetFeedType.popular));
      expect(forYouController.type, equals(TweetFeedType.forYou));
    });

    test('should refresh paging controller', () {
      // Arrange
      container = ProviderContainer(
        overrides: [
          twitterRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final controller = container.read(
        tweetsControllerProvider(TweetFeedType.popular),
      );

      // Act
      controller.refresh();

      // Assert - refresh should not throw
      expect(controller.pagingController, isNotNull);
    });
  });
}

