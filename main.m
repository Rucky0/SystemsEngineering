birthdate = 20010930;   % Write the birth date on format yyyymmdd for oldest member
format compact
[lambda1,lambda2,mu1,mu2,V1,V2,V] = deal(15,9,15,19,10,14,21);%getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

%% ANALYTIC SOLUTION
% Question 1 should be answered in the report

% Question 2 should be answered in the report, and submitted below
Q = @(n1, n2)[-(lambda1+lambda2), lambda2, lambda1, 0; ...
       3* mu2, -(lambda2+3*mu2), 0, lambda1; ...
       3 * mu1, 0, -(3*mu1+lambda2), lambda2; ...
       0, n1*mu1, n2*mu2, -(n1*mu1+n2*mu2)];

Qi = Q(3,0);
Qieig=sort(eig(Qi)); % We compare the eigenvalues
% To make sure that the order of your states will not change the result
Qii = Q(2,1);
Qiieig=sort(eig(Qii));
Qiii = Q(1,2); 
Qiiieig=sort(eig(Qiii));
Qiv = Q(0,3); 
Qiveig=sort(eig(Qiv));

%%

% Question 3 should be answered in the report

% Question 4 should be answered in the report, describe how you do it, and  
PIi  = stationary_states(Qi);
PIisort=sort(PIi); % We compare the sorted vectors
PIii = stationary_states(Qii);
PIiisort=sort(PIii);
PIiii = stationary_states(Qiii);
PIiiisort=sort(PIiii);
PIiv = stationary_states(Qiv);
PIivsort=sort(PIiv);

% Question 5 should be answered in the report, describe how you do it, and  
velocity = [V, V1, V2, 0];
AVi = dot(PIi,velocity);
AVii = dot(PIii,velocity);
AViii = dot(PIiii,velocity);
AViv = dot(PIiv,velocity);

AV= [AVi AVii AViii AViv];

%% CONTINUOUS TIME SIMULATION
% Question 6a should be answered in the report
% When starting at state V, we take 2 random samples from each exponential
% distribution and go to the state depending of the engine that failed
% first. When at the new engine, we again take 2 samples from the opposing
% engine failing and us fixing the broken engine. Because of the
% memory-less attribute of the exponational distribution, it makes sense to
% resample (restart) from the opposite engine breaking. If both engine fail, 
% and the technicians are working on engine 2, they will be reallocated to engine 1.

% Question 7a should be answered in the report, describe how you do it, and check that the result agrees with the analytic result

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below

AVtTF = 0.316136753867189;   % This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 

%% DISCRETE TIME SIMULATION
% Question 6b should be answered in the report, describe how you determine the transition matrix and enter below

P = expm(Qi*h);
P1 = eye(4) + h*Qi;

% Question 7b should be answered in the report, describe how you do it, and check that the result agrees with the analytic result
N = 1e5;

state = [1,0,0,0];

state = state*P^N;



% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below


% Question 9a should be answered in the report, describe how you do it, do the calculations and enter results below

Probfail10 = "to do"

ETtTF = "to do"


% Some of the following commands may be useful for the implementation when repeating steps over and over
% for, while, switch, break     

function pi = stationary_states(Q)
    
    b = [zeros(4,1);1];
    A = [Q'; ones(1, size(Q, 1))];
    pi  = A\b;
    pi = pi';

end