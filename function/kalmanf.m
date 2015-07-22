% KALMANF - updates a system state vector estimate based upon an
%           observation, using a discrete Kalman filter.
%
% Version 1.0, June 30, 2004
%
% This tutorial function was written by Michael C. Kleder
%
% INTRODUCTION
%
% Many people have heard of Kalman filtering, but regard the topic
% as mysterious. While it's true that deriving the Kalman filter and
% proving mathematically that it is "optimal" under a variety of
% circumstances can be rather intense, applying the filter to
% a basic linear system is actually very easy. This Matlab file is
% intended to demonstrate that.
%
% An excellent paper on Kalman filtering at the introductory level,
% without detailing the mathematical underpinnings, is:
% "An Introduction to the Kalman Filter"
% Greg Welch and Gary Bishop, University of North Carolina
% http://www.cs.unc.edu/~welch/kalman/kalmanIntro.html
%
% PURPOSE:
%
% The purpose of each iteration of a Kalman filter is to update
% 每次的kalman滤波迭代的目的就是基于一个新的观测信息去更新系统的状态向量（和该向量的协方差）
% the estimate of the state vector of a system (and the covariance
% of that vector) based upon the information in a new observation.
% The version of the Kalman filter in this function assumes that
% 这个函数中实现的卡尔曼滤波版本假设所有的观测来自一个固定的离散时间间隔
% observations occur at fixed discrete time intervals. Also, this
% 并且这个函数假设了一个线性系统，也就是说，状态向量随时间演进的方式是能够通过状态状态转移矩阵计算出来的
% function assumes a linear system, meaning that the time evolution
% of the state vector can be calculated by means of a state transition
% matrix.
%
% USAGE:
%
% s = kalmanf(s)
%
% "s" is a "system" struct containing various fields used as input
% “s”是一个系统结构体，其包含的所有变量域会被用于输入和输出
% and output. The state estimate "x" and its covariance "P" are
% 状态估计“x”和它的协方差“P”将会被函数更新
% updated by the function. The other fields describe the mechanics
% 其他域描述了系统的机械特性并且保持不变。
% of the system and are left unchanged. A calling routine may change
% these other fields as needed if state dynamics are time-dependent;
% 如果状态动力学是时变的，那么调用例程时这些域可能会被改变，否则在初始值被设定之后就不需要关注它们
% otherwise, they should be left alone after initial values are set.
% The exceptions are the observation vectro "z" and the input control
% (or forcing function) "u." If there is an input function, then
% "u" should be set to some nonzero value by the calling routine.
%
% SYSTEM DYNAMICS:
%
% The system evolves according to the following difference equations,
% where quantities are further defined below:
%
% x = Ax + Bu + w  meaning the state vector x evolves during one time
%                  step by premultiplying by the "state transition
%                  matrix" A. There is optionally (if nonzero) an input
%                  vector u which affects the state linearly, and this
%                  linear effect on the state is represented by
%                  premultiplying by the "input matrix" B. There is also
%                  gaussian process noise w.
% z = Hx + v       meaning the observation vector z is a linear function
%                  of the state vector, and this linear relationship is
%                  represented by premultiplication by "observation
%                  matrix" H. There is also gaussian measurement
%                  noise v.
% where w ~ N(0,Q) meaning w is gaussian noise with covariance Q
%       v ~ N(0,R) meaning v is gaussian noise with covariance R
%
% VECTOR VARIABLES:
%
% s.x = state vector estimate. In the input struct, this is the
%       "a priori" state estimate (prior to the addition of the
%       information from the new observation). In the output struct,
%       this is the "a posteriori" state estimate (after the new
%       measurement information is included).
% s.z = observation vector
% s.u = input control vector, optional (defaults to zero).
%
% MATRIX VARIABLES:
%
% s.A = state transition matrix (defaults to identity).
% s.P = covariance of the state vector estimate. In the input struct,
%       this is "a priori," and in the output it is "a posteriori."
%       (required unless autoinitializing as described below).
% s.B = input matrix, optional (defaults to zero).
% s.Q = process noise covariance (defaults to zero).
% s.R = measurement noise covariance (required).
% s.H = observation matrix (defaults to identity).
%
% NORMAL OPERATION:
% 正常的过程
% (1) define all state definition fields: A,B,H,Q,R
% (2) define intial state estimate: x,P
% (3) obtain observation and control vectors: z,u
% (4) call the filter to obtain updated state estimate: x,P
% (5) return to step (3) and repeat
%
% INITIALIZATION:
%
% If an initial state estimate is unavailable, it can be obtained
% 如果一个初始状态估计不可用，那么它将会通过下述第一次观测获得，这样就使得观测变量和状态变量的数目一致
% from the first observation as follows, provided that there are the
% same number of observable variables as state variables. This "auto-
% intitialization" is done automatically if s.x is absent or NaN.
%
% x = inv(H)*z
% P = inv(H)*R*inv(H')
%
% This is mathematically equivalent to setting the initial state estimate
% 这在数学上等价于将初始状态观测矩阵设定为无穷
% covariance to infinity.

function s = kalmanf(s)

% set defaults for absent fields:
if ~isfield(s,'x'); s.x=nan*z; end
if ~isfield(s,'P'); s.P=nan; end
if ~isfield(s,'z'); error('Observation vector missing'); end
if ~isfield(s,'u'); s.u=0; end
if ~isfield(s,'A'); s.A=eye(length(x)); end
if ~isfield(s,'B'); s.B=0; end
if ~isfield(s,'Q'); s.Q=zeros(length(x)); end
if ~isfield(s,'R'); error('Observation covariance missing'); end
if ~isfield(s,'H'); s.H=eye(length(x)); end

if isnan(s.x)
   % s.x是一个NaN，则按照上述方程进行状态向量的估计
   % initialize state estimate from first observation
   if diff(size(s.H))
      % H阵长宽不对
      error('Observation matrix must be square and invertible for state autointialization.');
   end
   s.x = inv(s.H)*s.z;
   s.P = inv(s.H)*s.R*inv(s.H'); 
else

   % This is the code which implements the discrete Kalman filter:
   % 下述代码实现了离散卡尔曼滤波
   % Prediction for state vector and covariance:
   % 状态向量的预测和协方差的预测
   s.x = s.A*s.x + s.B*s.u;
   s.P = s.A * s.P * s.A' + s.Q;

   % Compute Kalman gain factor:
   % 计算卡尔曼增益
   K = s.P*s.H'*inv(s.H*s.P*s.H'+s.R);

   % Correction based on observation:
   % 基于观测对之前的预测进行校正
   s.x = s.x + K*(s.z-s.H*s.x);
   s.P = s.P - K*s.H*s.P;

   % Note that the desired result, which is an improved estimate
   % 注意，一旦系统被明确定义，这里只用了五行代码就将观测得到的向量x和协方差P进行了修正
   % of the sytem state vector x and its covariance P, was obtained
   % in only five lines of code, once the system was defined. (That's
   % how simple the discrete Kalman filter is to use.) Later,
   % we'll discuss how to deal with nonlinear systems.

end

return