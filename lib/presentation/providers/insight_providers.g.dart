// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InsightsNotifier)
final insightsProvider = InsightsNotifierProvider._();

final class InsightsNotifierProvider
    extends $StreamNotifierProvider<InsightsNotifier, List<Insight>> {
  InsightsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsNotifierHash();

  @$internal
  @override
  InsightsNotifier create() => InsightsNotifier();
}

String _$insightsNotifierHash() => r'137d526bd05178205141fec80aaea457c815517c';

abstract class _$InsightsNotifier extends $StreamNotifier<List<Insight>> {
  Stream<List<Insight>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Insight>>, List<Insight>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Insight>>, List<Insight>>,
              AsyncValue<List<Insight>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(latestInsightReport)
final latestInsightReportProvider = LatestInsightReportProvider._();

final class LatestInsightReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<InsightReport?>,
          InsightReport?,
          FutureOr<InsightReport?>
        >
    with $FutureModifier<InsightReport?>, $FutureProvider<InsightReport?> {
  LatestInsightReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestInsightReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestInsightReportHash();

  @$internal
  @override
  $FutureProviderElement<InsightReport?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InsightReport?> create(Ref ref) {
    return latestInsightReport(ref);
  }
}

String _$latestInsightReportHash() =>
    r'c41090f2c1539bc63ef73ee37bb26b17655299f0';

@ProviderFor(insightEngine)
final insightEngineProvider = InsightEngineProvider._();

final class InsightEngineProvider
    extends $FunctionalProvider<InsightEngine, InsightEngine, InsightEngine>
    with $Provider<InsightEngine> {
  InsightEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightEngineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightEngineHash();

  @$internal
  @override
  $ProviderElement<InsightEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InsightEngine create(Ref ref) {
    return insightEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightEngine>(value),
    );
  }
}

String _$insightEngineHash() => r'29af7b529026d2dc3bc448818eed9fd0b9c93a75';
