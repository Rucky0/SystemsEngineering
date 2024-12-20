clear, clc

[lambdavec,Tvec,cvec] = deal([0.0531,0.0430,0.0474,0.0554,0.0269,0.0503,0.0672,0.0352,0.0170],[6,9,15,29,14,21,39,9,12],[13,15,22,22,11,54,83,35,24]); %getSPOdata(birthdate)   %yyyymmdd  Do not use clear command or change the values of these variables

budget = 500;
n = length(cvec);

values = zeros(n,budget);
comp_bought = zeros(n,budget);
counter = 0;

%intializing
for bud = 0:budget
    x_n = floor(bud/cvec(n));
    values(n,bud+1) = EBO(x_n, Tvec(n), lambdavec(n));
    comp_bought(n,bud+1) = x_n;
end


%%

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
            counter = counter +1;
        end

        [minVal, minArg] = min(step_values);
        
        values(comp,bud+1) = minVal;
        comp_bought(comp,bud+1) = floor((minArg-1)/cvec(comp));

    end
end
disp(counter)
%%
optimal_buy = zeros(n,budget+1);
optimal_value = zeros(1,budget+1);

for j = 0:budget
    optimal_buy(1,j+1) = comp_bought(1,j+1);
    budget_left = j-optimal_buy(1,j+1)*cvec(1);

    for i = 2:n
        optimal_buy(i,j+1) = comp_bought(i,budget_left+1);
        budget_left = budget_left-optimal_buy(i,j+1)*cvec(i);
    end
    optimal_value(j+1) = values(1,j+1);
end 

%%

function ebo = EBO(s, time_vec, lambda_vec)
    if s == 0
        ebo = time_vec.*lambda_vec;
        return
    end

    ebo = EBO(s-1, time_vec, lambda_vec) - R_vec(lambda_vec, time_vec, s-1);
end

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