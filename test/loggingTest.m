classdef (SharedTestFixtures={ ...
        matlab.unittest.fixtures.PathFixture('..'),...
        matlab.unittest.fixtures.WorkingFolderFixture}) ...
    loggingTest < matlab.unittest.TestCase
    %LOGGINGTEST unit tests for the logging class
    % Adding parent folder to path
    % Changing working directory to a temporary folder since we may
    % create files
    
    properties
        l; % instance of logging.logging
        logger_name = 'testVariableMessages';
        logging_methods = {@trace, @debug, @info, @warn, @error, @critical}
    end
    
    methods(TestMethodSetup)
        function createFigure(testCase)
            testCase.l = logging.getLogger(testCase.logger_name);
        end
    end
 
    methods(TestMethodTeardown)
        function closeFigure(testCase)
            % loggers can be persistent. Delete logger so that tests are
            % independent
            logging.clearLogger(testCase.logger_name);
        end
    end
    
    methods (Test)
        
        function testGetMessageWithVariableNumberOfInputs(testCase)            
            testCase.verifyEqual(testCase.l.getMessage('Hello'), 'Hello');
            
            testCase.verifyEqual(testCase.l.getMessage('Hello %s', 'world'),...
                'Hello world');
            
            testCase.verifyEqual(testCase.l.getMessage('Hello %s %d', 'world', 2),...
                'Hello world 2');
        end
        
        function testLoggingWithVariableNumberOfInputs(testCase)
            % Warning: this test does not check the actual outputs logging
            % prints using fprintf. However, the test would fail if any
            % error occurs, so is still useful and can be used for manual
            % verification. TODO log in a file so that we can automatically
            % test.
            
            logfile_name = [testCase.logger_name '.log'];
                        
            testCase.l.setFilename(logfile_name);
            testCase.l.setLogLevel(logging.logging.CRITICAL);
            
            for i=1:length(testCase.logging_methods)
                method_to_test = testCase.logging_methods{i};
                method_to_test(testCase.l, 'Hello');
                method_to_test(testCase.l, 'Hello %s', 'world');
                method_to_test(testCase.l, '%d', 2);
            end
            
            % For each of the logged lines, only retrive the logged message
            loggedStrings = loggingTest.getLogMessagesFromFile(logfile_name,...
                '^.* CRITICAL (?<t0>.*)$');
            
            testCase.verifyEqual(loggedStrings, {...
                'Hello', 'Hello world', '2'});
            
        end
        
    end
    
    methods(Static = true)
        function ret = getLogMessagesFromFile(fileName, token)
            lines = strsplit(fileread(fileName), '\n');
            
            % Last line is a empty new line.
            ret = regexp(lines(1:end-1), token, 'names');
            
            % Only the ``t0'' token is required.
            ret = cellfun(@(p)p.t0, ret, 'UniformOutput', false);
        end
    end
    
end

