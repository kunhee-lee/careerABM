function [setup, agent] = getMoney(setup, agent, ticks)
    
    for aCount=1:setup.nAgent
        % entrepreneur earns money depending on number of employees
        % capped value at 10 employees
        if strcmp(agent(aCount).status,setup.entrepreneur)==1
            agent(aCount).wealth=agent(aCount).wealth+ticks.*log(max(agent(aCount).employees+1,10));
        % employee salary inversely proportional to job distance
        else if strcmp(agent(aCount).status,setup.employee)==1
                salary=(3./(agent(aCount).jobDistance+1)).*100;
                agent(aCount).wealth=agent(aCount).wealth+salary;
            end
        end
        if strcmp(agent(aCount).status,setup.bankrupt)==1
            agent(aCount).wealth=-1;
        end
    end
    
end