## Color logger

* How to use

```dart
   Logger.root.onRecord.listen(ColorLogger.output);
```
* disable stack trace

```dart
   ColorLogger.logStack =false;
   or
   Logger.root.onRecord.listen(ColorLogger.outputWithoutStack);
```