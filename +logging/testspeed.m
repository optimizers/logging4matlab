function testspeed(logPath)

  opts.path = logPath;
  L = logging.getLogger('testlogger', opts);

  L.setCommandWindowLevel(L.TRACE);
  L.setLogLevel(L.OFF);
  tic;
  for i=1:1e2
    L.trace('test');
  end
  disp('1e2 logs when logging only to command window');
  toc;

  L.setCommandWindowLevel(L.OFF);
  L.setLogLevel(L.OFF);
  tic;
  for i=1:1e3
    L.trace('test');
  end
  disp('1e3 logs when logging is off');
  toc;

  L.setCommandWindowLevel(L.OFF);
  L.setLogLevel(L.TRACE);
  tic;
  for i=1:1e2
    L.trace('test');
  end
  disp('1e2 logs when logging to file');
  toc;
end
