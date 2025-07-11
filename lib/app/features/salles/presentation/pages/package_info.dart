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
  late Future<List<Map<String, dynamic>>> _releasesFuture;

  @override
  void initState() {
    super.initState();
    _fetchReleases();
  }

  void _fetchReleases() {
    setState(() {
      _releasesFuture = GitHubApiService.listReleases('Mahfoud-Sa', 'bokrah');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.packageInfo.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchReleases, // Add refresh functionality
            tooltip: 'Refresh releases',
          ),
        ],
      ),
      body: Column(
        children: [
          // Always display package info and icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Icon(Icons.system_update, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'App Name: ${widget.packageInfo.appName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Package Name: ${widget.packageInfo.packageName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Version: ${widget.packageInfo.version} (${widget.packageInfo.buildNumber})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'GitHub Releases:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          // Conditional display for releases or error
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _releasesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error fetching releases: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchReleases,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final release = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                release['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Tag: ${release['tag_name']}'),
                              Text('Published: ${release['published_at']}'),
                              if (release['body'] != null &&
                                  release['body'].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(release['body']),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No releases found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
