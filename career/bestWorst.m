function [setup, agent, bestWorstIDs] = bestWorst(setup, agent)
    richEntrepreneurID=0;
    richEmployeeID=0;
    poorJoblessID=0;
    
    richEntrepreneurWealth=0;
    richEmployeeWealth=0;
    poorJoblessWealth=10000;
    for aCount=1:setup.nAgent
        if strcmp(agent(aCount).status,setup.entrepreneur)==1
            if agent(aCount).wealth>richEntrepreneurWealth
                richEntrepreneurID=aCount;
                richEntrepreneurWealth=agent(aCount).wealth;
            end
        else if strcmp(agent(aCount).status,setup.employee)==1
                if agent(aCount).wealth>richEmployeeWealth
                    richEmployeeID=aCount;
                    richEmployeeWealth=agent(aCount).wealth;
                end
            
            else if strcmp(agent(aCount).status,setup.jobless)==1
                    if agent(aCount).wealth<poorJoblessWealth
                        poorJoblessID=aCount;
                        poorJoblessWealth=agent(aCount).wealth;
                    end
                else if strcmp(agent(aCount).status,setup.bankrupt)==1
                        if agent(aCount).wealth<poorJoblessWealth
                            poorJoblessID=aCount;
                            poorJoblessWealth=agent(aCount).wealth;
                        end
                    end
                end
            end
        end
    end
    
    % save best worst ID
    bestWorstIDs=[richEntrepreneurID, richEmployeeID, poorJoblessID];
end