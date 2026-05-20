abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

// Gagal karena tidak ada koneksi internet
class NetworkFailure extends Failure {
  const NetworkFailure() : super('Tidak ada koneksi internet');
}

// Gagal karena response server error (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Gagal karena data di cache/lokal tidak ditemukan atau rusak
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Gagal karena input user tidak valid (sebelum sampai ke server)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Gagal karena token tidak ada atau sudah expired
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Gagal karena timeout — server terlalu lama merespons
class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Koneksi timeout, coba lagi');
}
