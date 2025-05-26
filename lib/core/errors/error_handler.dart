import '../errors/exceptions.dart';
import '../errors/failures.dart';

Failure handleError(dynamic error) {
  if (error is ServerException) {
    return ServerFailure(error.message);
  } else if (error is CacheException) {
    return CacheFailure(error.message);
  } else if (error is NetworkException) {
    return NetworkFailure(error.message);
  } else {
    return ServerFailure('Unexpected error occurred');
  }
}