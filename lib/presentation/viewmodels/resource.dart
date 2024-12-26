abstract class Resource<T> {}

class ResourceLoading<T> extends Resource<T> {}

class ResourceSuccess<T> extends Resource<T> {
  final T data;

  ResourceSuccess(this.data);
}

class ResourceError<T> extends Resource<T> {
  final Error error;

  ResourceError(this.error);
}
