function [setup, agent] = countEmployees(setup, agent)
    
    Gi = setup.cell.Gi;
    G = setup.cell.G;
    N = setup.cell.grid;
    range = setup.rangeCountEmployees;
    nEmployees=0;
    % search number of employees in a grid centered on entrepreneur
    for aCount=1:setup.nAgent 
        if strcmp(agent(aCount).status,setup.entrepreneur)==1
            entPosition=agent(aCount).cellPosition;
            for i=entPosition-range:entPosition+range
                for j=entPosition-range:entPosition+range
                    if ( i>=1 && j>=1 && i<=N && j<=N )
                        nEmployees=nEmployees+G(i,j);
                    end
                end
            end
            agent(aCount).employees=nEmployees-2;
        end
    end
    
end