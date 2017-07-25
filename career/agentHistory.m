function [setup, agent] = agentHistory(setup, agent, ticks)
    for aCount=1:setup.nAgent
        agent(aCount).history.wealth(ticks)=agent(aCount).wealth;
        agent(aCount).history.rent(ticks)=agent(aCount).rent;
        
    end
end