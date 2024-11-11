birthdate = 20010930;   % Write the birth date on format yyyymmdd for oldest member
format compact
[lambda1,lambda2,mu1,mu2,V1,V2,V] = getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

%% ANALYTIC SOLUTION
% Question 1 should be answered in the report

% Question 2 should be answered in the report, and submitted below

Qi = [-(lambda1+lambda2), lambda2, lambda1, 0; ...
       mu2, -(lambda2+mu2), 0, lambda1; ...
       mu1, 0, -(mu1+lambda2), lambda2; ...
       0, mu1, mu2, -(mu1+mu2)];
Qieig=sort(eig(Qi)); % We compare the eigenvalues
% To make sure that the order of your states will not change the result
Qii = Qi^2;
Qiieig=sort(eig(Qii));
Qiii = Qi^3; 
Qiiieig=sort(eig(Qiii));
Qiv = Qi^4; 
Qiveig=sort(eig(Qiv));

%%

% Question 3 should be answered in the report

% Question 4 should be answered in the report, describe how you do it, and  

PIi  = "to do" 
PIisort=sort(PIi); % We compare the sorted vectors
PIii = "to do" 
PIiisort=sort(PIii);
PIiii = "to do" 
PIiiisort=sort(PIiii);
PIiv = "to do" 
PIivsort=sort(PIiv);

% Question 5 should be answered in the report, describe how you do it, and  

AVi = "to do" 
AVii = "to do" 
AViii = "to do" 
AViv = "to do" 

AV= [AVi AVii AViii AViv];

%% CONTINUOUS TIME SIMULATION
% Question 6a should be answered in the report

% Question 7a should be answered in the report, describe how you do it, and check that the result agrees with the analytic result

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below

AVtTF = "to do"   % This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 

%% DISCRETE TIME SIMULATION
% Question 6b should be answered in the report, describe how you determine the transition matrix and enter below

P = "to do"

% Question 7b should be answered in the report, describe how you do it, and check that the result agrees with the analytic result

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below


% Question 9a should be answered in the report, describe how you do it, do the calculations and enter results below

Probfail10 = "to do"

ETtTF = "to do"


% Some of the following commands may be useful for the implementation when repeating steps over and over
% for, while, switch, break     
