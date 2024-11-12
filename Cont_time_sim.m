clc
clear all

birthdate = 20010930;   % Write the birth date on format yyyymmdd for oldest member
format compact
[lambda1,lambda2,mu1,mu2,V1,V2,V] = deal(15,9,15,19,10,14,21);%getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

T = 1e3;
t = 0;
state = 1;

Q = @(n1, n2)[-(lambda1+lambda2), lambda2, lambda1, 0; ...
       3* mu2, -(lambda1+3*mu2), 0, lambda1; ...
       3 * mu1, 0, -(3*mu1+lambda2), lambda2; ...
       0, n1*mu1, n2*mu2, -(n1*mu1+n2*mu2)];

Qi = Q(3,0);
state_params = 1./Qi;

avg_times = zeros(2,4);

% Question 7a should be answered in the report, describe how you do it, and check that the result agrees with the analytic result
for i = 1:2
    state_time = zeros(1,4);
    while sum(state_time)<T
        [state, state_time] = update_state(state, state_time, state_params);
    end
    avg_times(i,:) = state_time./T;
end

error = norm(avg_times(1,:)-avg_times(2,:));

% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below
state_time = zeros(1, 4);
M = 1e4;
for i=1:M
    state = 1;
    while state ~= 4
        [state, state_time] = update_state(state, state_time, state_params);
    end
end
total_time_before_failure = sum(state_time);

AVtTF = total_time_before_failure/M;   % This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 

function [state, state_time] = update_state(state, state_time, state_params)
    params = state_params(state, :);
    params = params(params > 0 & isfinite(params));

    if state == 1
        to = [exprnd(params(1)); exprnd(params(2))];
        [time, min_arg] = min(to);
        state_time(state) = state_time(state) + time;
        if min_arg == 1
            state = 2;
        else
            state = 3;
        end

    elseif state == 2
        to = [exprnd(params(1)); exprnd(params(2))];
        [time, min_arg] = min(to);
        state_time(state) = state_time(state) + time;
        if min_arg == 1
            state = 1;
        else
            state = 4;
        end

    elseif state == 3
        to = [exprnd(params(1)); exprnd(params(2))];
        [time, min_arg] = min(to);
        state_time(state) = state_time(state) + time;
        if min_arg == 1
            state = 1;
        else
            state = 4;
        end

    else
        to = exprnd(params);
        state_time(state) = state_time(state) + to;
        state = 2;
    end
end