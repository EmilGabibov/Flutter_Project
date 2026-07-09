// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(searchEngine)
final searchEngineProvider = SearchEngineProvider._();

final class SearchEngineProvider
    extends $FunctionalProvider<SearchEngine, SearchEngine, SearchEngine>
    with $Provider<SearchEngine> {
  SearchEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchEngineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchEngineHash();

  @$internal
  @override
  $ProviderElement<SearchEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SearchEngine create(Ref ref) {
    return searchEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchEngine>(value),
    );
  }
}

String _$searchEngineHash() => r'b3975a93cc67290714478532e341195f2eff6632';

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryFamily._();

final class SearchQueryProvider
    extends $AsyncNotifierProvider<SearchQuery, List<SearchResult>> {
  SearchQueryProvider._({
    required SearchQueryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchQueryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @override
  String toString() {
    return r'searchQueryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  @override
  bool operator ==(Object other) {
    return other is SearchQueryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchQueryHash() => r'c039ea5aadd93e1556e8adbe9d827086a5818d8c';

final class SearchQueryFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchQuery,
          AsyncValue<List<SearchResult>>,
          List<SearchResult>,
          FutureOr<List<SearchResult>>,
          String
        > {
  SearchQueryFamily._()
    : super(
        retry: null,
        name: r'searchQueryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchQueryProvider call(String query) =>
      SearchQueryProvider._(argument: query, from: this);

  @override
  String toString() => r'searchQueryProvider';
}

abstract class _$SearchQuery extends $AsyncNotifier<List<SearchResult>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<SearchResult>> build(String query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SearchResult>>, List<SearchResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SearchResult>>, List<SearchResult>>,
              AsyncValue<List<SearchResult>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
