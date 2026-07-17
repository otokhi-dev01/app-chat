mixin MockServiceDelay {
  Future<void> simulateDelay({
    int milliseconds = 250,
  }) async {
    await Future<void>.delayed(
      Duration(
        milliseconds: milliseconds,
      ),
    );
  }
}