clear, clc

[lambdavec,Tvec,cvec] = deal([0.0531,0.0430,0.0474,0.0554,0.0269,0.0503,0.0672,0.0352,0.0170],[6,9,15,29,14,21,39,9,12],[13,15,22,22,11,54,83,35,24]); %getSPOdata(birthdate)   %yyyymmdd  Do not use clear command or change the values of these variables

budget = 500;
n = length(cvec);

weight_left = zeros(n,floor(budget/min(cvec)));
values = zeros(n,floor(budget/min(cvec)));

%intializing
for x_comp = 0:floor(budget/cvec(n))
    all_ebos = EBO(x_comp, Tvec, lambdavec);
    values(n,x_comp+1) = all_ebos(n);
    weight_left(n,x_comp+1) = budget-x_comp*cvec(n);
end

%recursion for rest of components (loop backwards)
for i = 1:n-1
    comp = n-i;
    
    %computing the vector with all different function values to then look for minimums
    all_values = zeros(1, floor(budget/cvec(comp)));
    comp_ebo = lambdavec(comp)*Tvec(comp);
    for x_comp = 0:floor(budget/cvec(comp))
        all_values(x_comp+1) = comp_ebo + values(comp+1,floor(budget-x_comp*cvec(comp)/cvec(comp+1) te));
        comp_ebo = comp_ebo - R_vec(lambdavec(comp),Tvec(comp),x_comp);
    end
    
    break

end


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