// File: utils/cloud_helper_function.dart
import 'package:flutter/material.dart';

class TCloudHelperFunctions {
  /// Helper function to check the state of multiple (list) database records.
  /// 
  /// Returns a Widget based on the state of the snapshot.
  /// If data is still loading, it returns a Circular Progress Indicator.
  /// If no data is found, it returns a generic "No Data Found" message or a custom [nothingFound] widget if provided.
  /// If an error occurs, it returns a generic error message or a custom [error] widget if provided.
  /// Otherwise, it returns null.
  static Widget? checkMultiRecordState<T>({
    required AsyncSnapshot<List<T>> snapshot,
    Widget? loader,
    Widget? error,
    Widget? nothingFound,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loader ?? const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return error ?? const Center(child: Text('Something went wrong.'));
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      return nothingFound ?? const Center(child: Text('No Data Found!'));
    }

    return null;
  }
}
