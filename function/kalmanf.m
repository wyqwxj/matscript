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
% ÿ�ε�kalman�˲�������Ŀ�ľ��ǻ���һ���µĹ۲���Ϣȥ����ϵͳ��״̬�������͸�������Э���
% the estimate of the state vector of a system (and the covariance
% of that vector) based upon the information in a new observation.
% The version of the Kalman filter in this function assumes that
% ���������ʵ�ֵĿ������˲��汾�������еĹ۲�����һ���̶�����ɢʱ����
% observations occur at fixed discrete time intervals. Also, this
% �����������������һ������ϵͳ��Ҳ����˵��״̬������ʱ���ݽ��ķ�ʽ���ܹ�ͨ��״̬״̬ת�ƾ�����������
% function assumes a linear system, meaning that the time evolution
% of the state vector can be calculated by means of a state transition
% matrix.
%
% USAGE:
%
% s = kalmanf(s)
%
% "s" is a "system" struct containing various fields used as input
% ��s����һ��ϵͳ�ṹ�壬����������б�����ᱻ������������
% and output. The state estimate "x" and its covariance "P" are
% ״̬���ơ�x��������Э���P�����ᱻ��������
% updated by the function. The other fields describe the mechanics
% ������������ϵͳ�Ļ�е���Բ��ұ��ֲ��䡣
% of the system and are left unchanged. A calling routine may change
% these other fields as needed if state dynamics are time-dependent;
% ���״̬����ѧ��ʱ��ģ���ô��������ʱ��Щ����ܻᱻ�ı䣬�����ڳ�ʼֵ���趨֮��Ͳ���Ҫ��ע����
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
% �����Ĺ���
% (1) define all state definition fields: A,B,H,Q,R
% (2) define intial state estimate: x,P
% (3) obtain observation and control vectors: z,u
% (4) call the filter to obtain updated state estimate: x,P
% (5) return to step (3) and repeat
%
% INITIALIZATION:
%
% If an initial state estimate is unavailable, it can be obtained
% ���һ����ʼ״̬���Ʋ����ã���ô������ͨ��������һ�ι۲��ã�������ʹ�ù۲������״̬��������Ŀһ��
% from the first observation as follows, provided that there are the
% same number of observable variables as state variables. This "auto-
% intitialization" is done automatically if s.x is absent or NaN.
%
% x = inv(H)*z
% P = inv(H)*R*inv(H')
%
% This is mathematically equivalent to setting the initial state estimate
% ������ѧ�ϵȼ��ڽ���ʼ״̬�۲�����趨Ϊ����
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
   % s.x��һ��NaN�������������̽���״̬�����Ĺ���
   % initialize state estimate from first observation
   if diff(size(s.H))
      % H�󳤿���
      error('Observation matrix must be square and invertible for state autointialization.');
   end
   s.x = inv(s.H)*s.z;
   s.P = inv(s.H)*s.R*inv(s.H'); 
else

   % This is the code which implements the discrete Kalman filter:
   % ��������ʵ������ɢ�������˲�
   % Prediction for state vector and covariance:
   % ״̬������Ԥ���Э�����Ԥ��
   s.x = s.A*s.x + s.B*s.u;
   s.P = s.A * s.P * s.A' + s.Q;

   % Compute Kalman gain factor:
   % ���㿨��������
   K = s.P*s.H'*inv(s.H*s.P*s.H'+s.R);

   % Correction based on observation:
   % ���ڹ۲��֮ǰ��Ԥ�����У��
   s.x = s.x + K*(s.z-s.H*s.x);
   s.P = s.P - K*s.H*s.P;

   % Note that the desired result, which is an improved estimate
   % ע�⣬һ��ϵͳ����ȷ���壬����ֻ�������д���ͽ��۲�õ�������x��Э����P����������
   % of the sytem state vector x and its covariance P, was obtained
   % in only five lines of code, once the system was defined. (That's
   % how simple the discrete Kalman filter is to use.) Later,
   % we'll discuss how to deal with nonlinear systems.

end

return