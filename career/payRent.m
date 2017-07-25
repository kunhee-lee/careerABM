function [setup, agent] = payRent(setup, agent)
    % calculate this quarter's rent
    for aCount=1:setup.nAgent
        % rent proportional to wealth, minimum=5
        if strcmp(agent(aCount).status,setup.jobless)==0
            setup.rent(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=max(agent(aCount).wealth*0.05,5);
        else
            rent=(1./(agent(aCount).jobDistance./2)).*80;
            setup.rent(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=rent;
        end
        agent(aCount).rent=setup.rent(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2));
        agent(aCount).wealth=agent(aCount).wealth-setup.rent(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2));
    end
end