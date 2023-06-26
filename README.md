## Color logger

```dart   
   // extension
   extension ColorLoggerHelper on Logger {
     
      listenOnColorLogger({
         bool stackTracking = true,
         Map<Level, AnsiColor>? levelColors,
         Map<Level, int>? methodCounts,
         Filter? filter,
         Level? highLightLevel,
      })
   }

   /// default is true
   Logger.root.listenOnColorLogger();
   or
   Logger.root.listenOnColorLogger(false);
```

* Default Using [Level.Fine, Level.Serve]
```dart
   AnsiColor.showColor();
   final levelColors = {
      Level.FINE: AnsiColor.fg(75),
      Level.SEVERE: AnsiColor.fg(196),
      };

   final Map<Level, int> methodCounts = {
      Level.SEVERE: 8,
      Level.FINE: 2,
      };
```

* logger
  <img src="https://github.com/jack-fan1991/flutter_color_logger/blob/main/assets/logger.png?raw=true">