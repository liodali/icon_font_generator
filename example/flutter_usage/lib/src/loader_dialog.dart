import 'package:flutter/material.dart';

class LoaderDialog<T> extends StatefulWidget {
  const LoaderDialog({
    super.key,
    required this.job,
    this.onPostJob,
    required this.child,
  });
  final Future<T> Function() job;
  final Function(BuildContext, T)? onPostJob;
  final Widget child;

  @override
  State<LoaderDialog> createState() => _LoaderDialogState();
}

class _LoaderDialogState extends State<LoaderDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _runJob);
  }

  Future<void> _runJob() async {
    final result = await widget.job();
    if (!mounted) {
      return;
    }
    if (widget.onPostJob != null) {
      widget.onPostJob!(context, result);
    } else {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
