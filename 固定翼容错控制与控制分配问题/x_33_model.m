function [sys,x0,str,ts,simStateCompliance] = x_33_model(t,x,u,flag)
Alat = [-0.099170  0.020570  2.805001  0.000001 0.000001;
        -0.002640 -0.031920 -0.674200  0        0;
        -0.108500 -0.994000 -0.029750  0.010210 0.000034;
         1.0       0.016090 -0.000148  0.000016 0;
         0         1.0       0.000120 -0.000013 0.000122];
Alon = [-0.064190   1.000001 0.000844 -0.000130;
        -1.424000  -0.051730 0.000001  0;
        -0.0000138  1.0      0.000014  0.000003;
        -0.550041   0       -0.559090 -0.013375];
A = [Alat zeros(5,4);
     zeros(4,5) Alon];
B = [-0.2883  0.2883 -0.8654  0.8654 -0.0000  0.0025 -0.2883  0.2883;
     -0.0959  0.0959  0.2079 -0.2079 -0.0045 -0.0051 -0.0959  0.0959;
      0.0000  0.0000  0.0003 -0.0003 -0.0001  0       0       0;
      0       0       0       0       0       0       0       0;
      0       0       0       0       0       0       0       0;
     -0.0005 -0.0005 -0.0019 -0.0019 -0.0005  0.0004 -0.0005 -0.0005;
     -0.0857 -0.0857 -0.5263 -0.5263  0.0098 -0.0073 -0.0857 -0.0857;
      0       0       0       0       0       0       0       0;
     -0.0034 -0.0034 -0.1285 -0.1285  0.0011 -0.0011 -0.0041 -0.0041];
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,A,B);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 9;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 17;
sizes.NumInputs      = 8;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [0 0 0 0 0 6.23 0 0.922 3.16*340/0.3048];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,A,B)

sys = A*x + B*u;

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
% sys = [x u];
sys = [x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9) u(1) u(2) u(3) u(4) u(5) u(6) u(7) u(8)];

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
