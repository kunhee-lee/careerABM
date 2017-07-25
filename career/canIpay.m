function [setup, agent] = canIpay(setup, agent, history, ticks)
    alpha=1.0;
    for aCount=1:setup.nAgent
        dRent = alpha.*(((agent(aCount).rent)/(history.rent(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2),ticks-4)))-1);
        predictedRent = agent(aCount).rent + dRent;
        predictedRent = predictedRent ./ agent(aCount).wealth; % proportion of rent to wealth
        if predictedRent > 1
            agent(aCount).move=1;
        end
    end
end