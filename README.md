# Logging for Matlab

This simple logging module is a modification of [`log4m`](http://goo.gl/qDUcvZ)
with the following improvements:

* multiple loggers can be created and retrieved by name (à la Python)
* different logging levels appear in different colors if using Matlab in the terminal

Each logger's output can be directed to the standard output and/or to a file.

Each logger is assigned a logging level that will control the amount of output.
The possible levels are, from high to low:

* ALL (highest)
* TRACE
* DEBUG
* INFO (default)
* WARNING
* ERROR
* CRITICAL
* OFF (lowest)

The default level in INFO.
If a logger outputs at a level lower than or equal to its assigned level, the output will be logged.
To silence a logger, set its level to OFF.

All loggers output a string according to the Matlab format `'%-s %-23s %-8s %s\n'`.
Note that a newline is always appended, so there is no need to terminate log lines
with a newline.
The format is as follows:
* `%-s` is used to display the caller name, i.e., the function or method in which
  logging occured
* `%-23s` is used for a time stamp of the form `2016-09-14 14:23:44,271`
* `%-8s` is used for the logging level
* `%s` is used for the message to be logged.

## API

If `logger` is an instance of the `logging` class, the following methods can be used
to log output at different levels:

* `logger.trace(string)`: output `string` at level TRACE.
  This level is mostly used to trace a code path.
* `logger.debug(string)`: output `string` at level DEBUG.
  This level is mostly used to log debugging output that may help identify an issue
  or verify correctness by inspection.
* `logger.info(string)`: output `string` at level INFO.
  This level is intended for general user messages about the progress of the program.
* `logger.warn(string)`: output `string` at level WARNING (unrelated to Matlab's `warning()` function).
  This level is used to alert the user of a possible problem.
* `logger.error(string)`: output `string` at level ERROR (unrelated to Matlab's `error()` function).
  This level is used for non-critical errors that can endanger correctness.
* `logger.critical(string)`: output `string` at level CRITICAL
  This level is used for critical errors that definitely endanger correctness.

## Examples

A logger at default level INFO logs messages at levels INFO, WARNING, ERROR and CRITICAL, but not at levels TRACE or DEBUG:

```matlab
>> addpath('/path/to/logging4matlab')
>> logger = logging.getLogger('mylogger')  % new logger with default level INFO
>> logger.info('life is just peachy')
logging.info 2016-09-14 15:10:06,049 INFO     life is just peachy
>> logger.debug('Easy as pi! (Euclid)')    % produces no output
>> logger.critical('run away!')
logging.critical 2016-09-14 15:12:37,652 CRITICAL run away!
```

A logger's assigned level for the command window (or terminal) can be changed:

```matlab
>> logger.setCommandWindowLevel(logging.logging.WARNING)
```

A logger can also output to file:

```matlab
>> logger2 = logging.getLogger('myotherlogger', struct('path', '/tmp/logger2.log'))
>> logger.setLogLevel(logging.logging.WARNING)
```

Output to either the command window or a file can be suppressed with `logging.logging.OFF`.

# FAQ

1. *Why is there no colored logging in the Matlab command window?*
   I haven't gotten around to evaluating the performance of [`cprintf`](https://goo.gl/Nw5OOy),
   which seems to be the only viable option for colored output in the command window.
   Pull request welcome!
2. *Can I change the colors?*
   Currently, no, but feel free to submit a pull request!
3. *Can I change the format string used by loggers?*
   Currently, no, but feel free to submit a pull request!
