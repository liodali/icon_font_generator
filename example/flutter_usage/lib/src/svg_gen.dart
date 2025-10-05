

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icon_font_generator/icon_font_generator.dart';
import 'package:icon_font_generator_example/src/loader_dialog.dart';

import 'common/platform_get_directly.dart';

class SvgGen extends StatefulWidget {
  const SvgGen({super.key});

  @override
  State<SvgGen> createState() => _SvgGenState();
}

class _SvgGenState extends State<SvgGen> {
  List<PlatformFile> selectedSvgFiles = [];
  final TextEditingController _pathController = TextEditingController();

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }

  void _pickSvgFiles() async {
    final files = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg'],
      allowMultiple: true,
      withData: true,
    );
    if (files != null) {
      setState(() {
        selectedSvgFiles = files.files;
      });
    }
  }

  void _removeSvgFile(int index) {
    setState(() {
      selectedSvgFiles.removeAt(index);
    });
  }

  void _convertToOtf() async {
    if (selectedSvgFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select SVG files first.')),
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => LoaderDialog<bool>(
        job: () async {
          try {
            final svgMap = <String, String>{};
            Future.forEach(selectedSvgFiles, (svg) async {
              final strContent = await svg.xFile.readAsString();
              svgMap.putIfAbsent(svg.name, () => strContent);
            });
            final result = await compute((Map<String, String> svgMap) async {
              return svgToOtf(svgMap: svgMap);
            }, svgMap);
            final basePath = "${await getDownloadsDirectory()}/";
            final path = basePath != "null/"
                ? "${basePath}icon.otf"
                : "icon.otf";
            writeFontFile(path, result.font);

            return true;
          } catch (e, trace) {
            debugPrint('Error converting SVG to OTF: $e');
            debugPrint('Error converting SVG to OTF: $trace');
            return false;
          }
        },
        child: const Dialog(
          constraints: BoxConstraints(maxHeight: 128, maxWidth: 128),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == true
                ? 'OTF file generated successfully.'
                : 'Error generating OTF file.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG to OTF Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input Form Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select SVG Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pathController,
                            decoration: const InputDecoration(
                              labelText: 'SVG Files Path',
                              hintText: 'Enter path or use browse button',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.folder),
                            ),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _pickSvgFiles,
                          icon: const Icon(Icons.browse_gallery),
                          label: const Text('Browse'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected: ${selectedSvgFiles.length} SVG files',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grid View Section
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected SVG Files',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: selectedSvgFiles.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 16,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      spacing: 2,
                                      children: [
                                        Text(
                                          'No SVG files selected',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Use the browse button to select SVG files',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1,
                                    ),
                                itemCount: selectedSvgFiles.length,
                                itemBuilder: (context, index) {
                                  final file = selectedSvgFiles[index];
                                  return Card(
                                    elevation: 2,
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox.square(
                                                dimension: 48,
                                                child: SvgPicture.memory(
                                                  file.bytes!,
                                                  width: 48,
                                                  height: 48,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                child: Text(
                                                  file.name,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removeSvgFile(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Convert Button Section
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: selectedSvgFiles.isNotEmpty ? _convertToOtf : null,
                icon: const Icon(Icons.transform),
                label: const Text(
                  'Convert to OTF',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
