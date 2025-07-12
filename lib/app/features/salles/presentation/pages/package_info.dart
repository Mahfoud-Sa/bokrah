import 'package:bokrah/github_releses.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateScreen extends StatefulWidget {
  final PackageInfo packageInfo;

  const AppUpdateScreen({super.key, required this.packageInfo});

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  late Future<Map<String, dynamic>?> _releaseFuture;
  bool _isUpdateAvailable = false;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _fetchLatestRelease();
  }

  void _fetchLatestRelease() {
    setState(() {
      _releaseFuture = _getLatestRelease();
    });
  }

  Future<Map<String, dynamic>?> _getLatestRelease() async {
    try {
      final releases = await GitHubApiService.listReleases(
        'Mahfoud-Sa',
        'bokrah',
      );
      if (releases.isEmpty) return null;

      // Get the latest release (first one in the list)
      final latestRelease = releases.first;

      // Compare versions
      final currentVersion = _parseVersion(widget.packageInfo.version);
      final latestVersion = _parseVersion(
        latestRelease['tag_name']?.replaceFirst('v', '') ?? '0.0.0',
      );

      setState(() {
        _isUpdateAvailable =
            _compareVersions(currentVersion, latestVersion) < 0;
        _downloadUrl = _findInstallerUrl(latestRelease['assets']);
      });

      return latestRelease;
    } catch (e) {
      throw Exception('Failed to fetch releases: $e');
    }
  }

  // Parse version string into comparable numbers
  List<int> _parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  // Compare version numbers (returns -1 if current < latest)
  int _compareVersions(List<int> current, List<int> latest) {
    for (int i = 0; i < current.length; i++) {
      if (i >= latest.length) return 0;
      if (current[i] < latest[i]) return -1;
      if (current[i] > latest[i]) return 1;
    }
    return 0;
  }

  // Find the Windows installer URL in release assets
  String? _findInstallerUrl(List<dynamic> assets) {
    if (assets == null) return null;
    for (final asset in assets) {
      if (asset['name'].toString().endsWith('.exe')) {
        return asset['browser_download_url'];
      }
    }
    return null;
  }

  // Future<void> _launchDownload(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packageInfo.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLatestRelease,
            tooltip: 'Check for updates',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current version info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Current Version: ${widget.packageInfo.version}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Build: ${widget.packageInfo.buildNumber}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Update status
            FutureBuilder<Map<String, dynamic>?>(
              future: _releaseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return _buildNoUpdatesState();
                }

                final release = snapshot.data!;
                return _buildReleaseCard(release);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReleaseCard(Map<String, dynamic> release) {
    return Card(
      color: _isUpdateAvailable ? Colors.blue[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isUpdateAvailable ? Icons.system_update : Icons.check_circle,
                  color: _isUpdateAvailable ? Colors.blue : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  _isUpdateAvailable ? 'Update Available!' : 'Youre up to date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isUpdateAvailable ? Colors.blue : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              release['name'] ?? 'No Name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Version: ${release['tag_name']}'),
            Text(
              'Published: ${release['published_at']?.split('T').first ?? 'Unknown'}',
            ),
            if (release['body'] != null && release['body'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(release['body']),
            ],
            if (_isUpdateAvailable && _downloadUrl != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Download Update'),
                  onPressed: () {
                    //  _launchDownload(_downloadUrl!)
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Failed to check for updates',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLatestRelease,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoUpdatesState() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            SizedBox(height: 16),
            Text(
              'No updates available',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('You have the latest version of the app.'),
          ],
        ),
      ),
    );
  }
}
