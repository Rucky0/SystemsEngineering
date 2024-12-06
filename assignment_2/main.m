%% First we generate input data
clear all
clc

birthdate =  20010930;  % Write the birth date on format yyyymmdd for oldest member in the group
format compact
[lambdavec,Tvec,cvec] = deal([0.0531,0.0430,0.0474,0.0554,0.0269,0.0503,0.0672,0.0352,0.0170],[6,9,15,29,14,21,39,9,12],[13,15,22,22,11,54,83,35,24]); %getSPOdata(birthdate)   %yyyymmdd  Do not use clear command or change the values of these variables

% -------------------------------------------------------------------------------------------------------------------
%% Marginal Allocation
% Question 1 should be answered in the report

% Question 2 should described in the report, and submitted below
% Enter on the format EBO2 = [EBO_1(2) EBO_2(2) ... EBO_9(2)]      
% EBO_j(2) should be the EBO for two spares of LRU2
% Cost2 should be the total cost for the allocation of spares (scalar) 

EBO2 = lambdavec.*Tvec - R_vec(lambdavec,Tvec,zeros(1,9)) - R_vec(lambdavec,Tvec,ones(1,9));
Cost2 = sum(cvec*2);

Q2 = [EBO2 Cost2]; % Checking both at the same time in grader.

% Question 3, you should describe how the Marginal allocation is
% implemented in your own words in the report, and compute all efficient
% points.

s = zeros(9);

%%
s_vec = zeros(1,9);
s_mat = zeros(1,9);
EBOs_vec = lambdavec.*Tvec;
EBOs_sums = [sum(EBOs_vec)];
counter = 1;

while dot(cvec,s_vec) < 500
    counter = counter+1;
    
    quot = R_vec(lambdavec,Tvec,s_vec)./cvec;
    [maxVal, argMax] = max(quot);
    s_vec(argMax) = s_vec(argMax)+1;

    if dot(cvec,s_vec) > 500
        s_vec(argMax) = s_vec(argMax)-1;
        break
    end

    EBOs_vec(argMax) = EBOs_vec(argMax) - R_vec(lambdavec(argMax),Tvec(argMax),s_vec(argMax)-1);
    EBOs_sums(counter) = sum(EBOs_vec);
    s_mat = [s_mat;s_vec];
end


% Question 4 should be answered in the report, with a figure and a table with
% all efficient points
% Furthermore, a table with first five efficient points should be submitted below
eff_sols = s_mat(1:5,:);
fig1 = figure(1);
plot(s_mat*cvec',EBOs_sums,'.-k','LineWidth',2,'MarkerSize',20)
hold on   % Keeps old plots and adds new plots on top of the old
hold off  % Replaces old plots with the new one
grid on
set(gca,'FontSize',20,'TickLabelInterpreter','latex')
xlabel("Total Cost [-]",'FontSize',20,'interpreter','latex')
ylabel("EBO [-]",'FontSize',20,'interpreter','latex')
title('Efficient Solutions Curve','FontSize',20,'interpreter','latex')

% Enter on the format EPtable = [ x0 EBO(x0) C(x0); x1 EB0(x1) C(x1); ... x4 EBO(x4) C(x4)]
% Where xj is the row vector with number of spare parts of each kind
% corresponding to the efficient points generated by the Marginal allocation algorithm
% EBO and C are the total values (scalars) for each allocation xj
c5 = s_mat(1:5,:)*cvec';

EPtable = [s_mat(1:5,:), EBOs_sums(1:5)', c5];

% Question 5 should be discussed in the report

final_EBO_q2 = sum(EBO2);
final_EBO_q3 = EBOs_sums(end);

final_EBOs=[final_EBO_q2,final_EBO_q3;
            Cost2, dot(cvec,s_mat(end,:))];


% -------------------------------------------------------------------------------------------------------------------
%% Dynamic Programming
% Question 6 should be answered in the report

% Question 7 should be answered in the report, and submitted below
% as a row vector with numbers of LRU1 used for budget 0 to 50.

budget = 50;
[LRU1, LRU1_EBO] = optimal_problem(budget, cvec(1), Tvec(1), lambdavec(1));

fig2 = figure(2);
plot(0:1:50,LRU1_EBO,'.-k','LineWidth',2,'MarkerSize',5)
hold on   % Keeps old plots and adds new plots on top of the old
hold off  % Replaces old plots with the new one
grid on
set(gca,'FontSize',20,'TickLabelInterpreter','latex')
xlabel("BUDGET [-]",'FontSize',20,'interpreter','latex')
ylabel("EBO [-]",'FontSize',20,'interpreter','latex')
title('EBO for LRU1','FontSize',20,'interpreter','latex')

%%

% Question 8 should be answered in the report, and submitted below
% Enter on the format DynPtable = [ x0 EBO(x0) C(x0); x1 EB0(x1) C(x1); ... x4 EBO(x4) C(x4)]
% Where x0 to x4 are the row vectors with number of spare parts of each kind
% corresponding to the points optimal for budgets 0,100,150, 350, 500.
budget = 500;
[LRU, LRU_EBO] = optimal_problem(budget, cvec, Tvec, lambdavec);

counter = 1;
DynPtable = zeros(1,11);
for i = [1,101,151, 351, 501]
    DynPtable(counter,:) = [LRU(:,i)', LRU_EBO(i), dot(LRU(:,i),cvec)];
    counter = counter +1;
end
DynPtable

fig3 = figure(3);
plot(0:1:500,LRU_EBO,'.-k','LineWidth',2,'MarkerSize',5)
hold on   % Keeps old plots and adds new plots on top of the old
hold off  % Replaces old plots with the new one
grid on
set(gca,'FontSize',20,'TickLabelInterpreter','latex')
xlabel("BUDGET [-]",'FontSize',20,'interpreter','latex')
ylabel("EBO [-]",'FontSize',20,'interpreter','latex')
title('EBO for LRUs','FontSize',20,'interpreter','latex')


% Question 9 should be answered in the report

% Question 10 should be answered in the report, and submitted below
NumberOfConfigurations = 6^9;


%% functions

function r_vec = R_vec(lambdavec,Tvec,s_vec)
    l = lambdavec.*Tvec;
    s_vec = [s_vec];

    prob_sum = zeros(1,length(s_vec));
    for j =1:length(s_vec)
        for i = 0:s_vec(j)
            prob_sum(j) = prob_sum(j) + (l(j).^i).*exp(-l(j))/factorial(i);
        end
    end
    r_vec = 1 - prob_sum;
end

function [optimal_buy, optimal_values] = optimal_problem(budget, cvec, Tvec, lambdavec)
        
    n = length(cvec);
    
    values = zeros(n,budget);
    comp_bought = zeros(n,budget);
    
    %intializing
    for bud = 0:budget
        x_n = floor(bud/cvec(n));
        values(n,bud+1) = EBO(x_n, Tvec(n), lambdavec(n));
        comp_bought(n,bud+1) = x_n;
    end
    
    
    %recursion for rest of components (loop backwards)
    for i = 1:n-1
        comp = n-i;
        disp(comp)
        
        %for every state s (resterande budget)
        for bud = 0:budget
    
            step_values = 99*ones(1,bud);
            x_k_old = -inf;

            for s = 0:bud
                x_k = floor(s/cvec(comp));
                if x_k == x_k_old
                    continue
                end
                step_values(s+1) = EBO(x_k,Tvec(comp),lambdavec(comp)) + values(comp+1, bud-x_k*cvec(comp)+1);
                x_k_old = x_k;
            end
    
            [minVal, minArg] = min(step_values);
            
            values(comp,bud+1) = minVal;
            comp_bought(comp,bud+1) = floor((minArg-1)/cvec(comp));
    
        end
    end

    optimal_buy = zeros(n,budget+1);
    optimal_values = zeros(1,budget+1);
    
    for j = 0:budget
        optimal_buy(1,j+1) = comp_bought(1,j+1);
        budget_left = j-optimal_buy(1,j+1)*cvec(1);
    
        for i = 2:n
            optimal_buy(i,j+1) = comp_bought(i,budget_left+1);
            budget_left = budget_left-optimal_buy(i,j+1)*cvec(i);
        end
        optimal_values(j+1) = values(1,j+1);
    end 

end

function ebo = EBO(s, time_vec, lambda_vec)
    if s == 0
        ebo = time_vec.*lambda_vec;
        return
    end

    ebo = EBO(s-1, time_vec, lambda_vec) - R_vec(lambda_vec, time_vec, s-1);
end



function [value, s_vec] = Recursion_old(lambdavec,Tvec,s_vec,budget,cvec,argMax)
    cost = dot(s_vec ,cvec);
    
    if cost > budget
        s_vec(argMax) = s_vec(argMax)-1;
        value = -1;
        return
    end

    r_vec = R_vec(lambdavec, Tvec, s_vec);

    [value, argMax] = max(r_vec);
    
    s_vec(argMax) = s_vec(argMax) + 1;
    
    [value_next, s_vec] = Recursion_old(lambdavec,Tvec, s_vec, budget, cvec, argMax);
    
    if value_next < 0
        value_next = -value;
    end

    value = value + value_next;
end