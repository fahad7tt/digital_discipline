import '../../domain/entities/stats.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_local_datasource.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsLocalDatasource localDataSource;

  StatsRepositoryImpl(this.localDataSource);

  @override
  List<Stats> getAllStats() {
    return localDataSource.getStats();
  }
}
