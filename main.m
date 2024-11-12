clc
clear all

birthdate = 20010930;   % Write the birth date on format yyyymmdd for oldest member
format compact
[lambda1,lambda2,mu1,mu2,V1,V2,V] = deal(15,9,15,19,10,14,21);%getFerrydata(birthdate);  % Do not clear or redefine these variables.
h=0.001; % Discretization step

%% ANALYTIC SOLUTION
% Question 1 should be answered in the report

% Question 2 should be answered in the report, and submitted below
Q = @(n1, n2)[-(lambda1+lambda2), lambda2, lambda1, 0; ...
       3* mu2, -(lambda1+3*mu2), 0, lambda1; ...
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

T = 1e3;
t = 0;
state = 1;

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

AVtTF = total_time_before_failure/M;   
% This will be the answer to the new question, I will describe it in the pdf.
% Describe in the report how you do this. 


%% DISCRETE TIME SIMULATION
% Question 6b should be answered in the report, describe how you determine the transition matrix and enter below

P = expm(Qi*h);
P1 = eye(4) + h*Qi;

% Question 7b should be answered in the report, describe how you do it, and check that the result agrees with the analytic result


states = zeros(2,4);

s = [1,0,0,0];
state = 1;


for k = 1:2
    N = 10^(5+k);

    for i = 1:N
        transition_probabilities = P(state,:);
        cumulative_probs = cumsum(transition_probabilities);
        sample = rand;
    
        for j = 1:length(cumulative_probs)
            if sample <= cumulative_probs(j)
                state = j;
                break;
            end
        end

        states(k,state) = states(k,state) + 1;
    end

    states(k,:) = states(k,:)/N;
end
error = norm(states(1,:)-states(2,:));

% Analytic
% for i=1:2
%     N = 10^(3+i);
%     state = [1,0,0,0];
%     state = state*P^N;
%     states(i,:) = state;
% end
% 
% error = norm(states(1,:)-states(2,:));


% Question 8a should be answered in the report, describe how you do it, do the calculations and enter results below

average_speed = state*[V; V1; V2; 0];

%%
% Question 9a should be answered in the report, describe how you do it, do the calculations and enter results below
P
state = [1,0,0,0];

state10 = state*P^10;

P10 = expm(10*Qi);

Probfail10 = state10(4);

Ptime = expm(Qi);

A = [0, P(1,3), P(1,2); 
    P(3,1), 0, 0;
    P(2,1), 0, 0];
A = (eye(3) - A);
b = [1,1,1]';
my = A\b;

ETtTF = my(1);
% Some of the following commands may be useful for the implementation when repeating steps over and over
% for, while, switch, break


%% sim for 9b
clc
average_steps_untill_failure = 0;
steps = 0;
state = 1;
resets = 0;

for i = 1:N
    transition_probabilities = P(state,:);
    cumulative_probs = cumsum(transition_probabilities);
    sample = rand;

    for j = 1:length(cumulative_probs)
        if sample <= cumulative_probs(j)
            state = j;
            break;
        end
    end
    steps = steps + 1;

    if state == 4
        state = 1;
        average_steps_untill_failure = average_steps_untill_failure + steps;
        steps = 0;
        resets = resets + 1;
    end
end
disp("average time untill total failure is " +average_steps_untill_failure/resets)

%% funcitons
function pi = stationary_states(Q)
    
    b = [zeros(4,1);1];
    A = [Q'; ones(1, size(Q, 1))];
    pi  = A\b;
    pi = pi';

end

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