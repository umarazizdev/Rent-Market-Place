class SupabaseConfig {
  static const String url = 'https://bvmpllkikwigvszmbbbn.supabase.co';
  /// Legacy anon JWT key required by supabase_flutter 2.9.0.
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2bXBsbGtpa3dpZ3Zzem1iYmJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE4ODQ3NDUsImV4cCI6MjEwNzQ2MDc0NX0.G8iQPnlBmw8GsgPKQGCiC37EWUaPHjq3ijQL-7MqeVk';
  static const String bucket = 'media';
  /// Folder prefix so multiple apps can share one bucket.
  static const String appFolder = 'rent-market';
}
