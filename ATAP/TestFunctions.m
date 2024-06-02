function Problem = TestFunctions(testfunc)
%GETPROBLEM_INF 此处显示有关此函数的摘要
%   此处显示详细说明
switch testfunc
    case  'DCF1'
        Problem.Name    = 'DCF1';        % name of test problem
        Problem.od      = 2;            % number of objectives
        Problem.pd      = 10;
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];  % lower boundary of decision variables, it also defines the number of decision variables
       %Problem.XUpp    = ones(12,1);   % upper boundary of decision variables
        Problem.func    = @DCF1;          % Objective function, please read the definition
    case 'DCF2'
        Problem.Name    = 'DCF2';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [zeros(10,1) ones(10,1)];   % upper boundary of decision variables
        Problem.func    = @DCF2;          % Objective function, please read the definition
    case  'DCF3'
        Problem.Name    = 'DCF3';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF3;          % Objective function, please read the definition
    case  'DCF4'
        Problem.Name    = 'DCF4';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF4;          % Objective function, please read the definition
    case 'DCF5'
        Problem.Name    = 'DCF5';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF5;          % Objective function, please read the definition
    case 'DCF6'
        Problem.Name    = 'DCF6';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF6;          % Objective function, please read the definition
    case 'DCF7'
        Problem.Name    = 'DCF7';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF7;          % Objective function, please read the definition
    case 'DCF8'
        Problem.Name    = 'DCF8';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF8;          % Objective function, please read the definition
    case 'DCF9'
        Problem.Name    = 'DCF9';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];   % upper boundary of decision variables
        Problem.func    = @DCF9;          % Objective function, please read the definition
    case  'DCF10'
        Problem.Name    = 'DCF10';        % name of test problem
        Problem.od      = 2;            % number of objectives                               
        Problem.pd      = 10;  % lower boundary of decision variables, it also defines the number of decision variables
        Problem.domain  = [0 1;-1*ones(9,1) ones(9,1)];  % upper boundary of decision variables
        Problem.func    = @DCF10;          % Objective function, please read the definition
    
end

end

