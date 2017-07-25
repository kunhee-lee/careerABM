close all 
clear all
%% Entrepreneur simulator
% kunhee lee

%% start settings

% simulation settings
setup.nTicks = 100;
setup.nAgent = 100;

% agent characteristics
setup.agent.pEntre = 0.05;
setup.agent.speed = 1;

% setup cell automata
setup.cell.grid=100;
setup.cell.neigh = [-1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0];
setup.cell.G = zeros(setup.cell.grid, setup.cell.grid);
setup.cell.Gi = zeros(setup.cell.grid, setup.cell.grid); % agent intensity grid

setup.nEntre=round(setup.nAgent*setup.agent.pEntre,0);
setup.nJobless=setup.nAgent-setup.nEntre;

% intensity range
setup.rangeCountEmployees = 15;

% names
setup.employee='Employee';
setup.jobless='Jobless';
setup.entrepreneur='Entrepreneur';
setup.bankrupt='bankrupt';

% house rent matrix - same as grid and stored through time
setup.rent = ones(setup.cell.grid, setup.cell.grid);

% history of data
history.rent = zeros(setup.cell.grid, setup.cell.grid, setup.nTicks);

%% generate agents
pos=unique([randi(setup.cell.grid,1,setup.nAgent*1.5)' randi(setup.cell.grid,1,setup.nAgent*1.5)'],'rows');
pos=pos(1:setup.nAgent,:);

pos1=pos(:,1);
pos2=pos(:,2);

% 2 = normal
for i=1:setup.nAgent
    setup.cell.G(pos1(i),pos2(i))=2;
end

% random entrepreneur generation
picked=randperm(setup.nAgent);
for i=1:setup.nEntre
    setup.cell.G(pos1(picked(i)),pos2(picked(i)))=1;
end
%% setup agents
% entrepreneur and worker
[x,y]=find(setup.cell.G==1);
counter=1;
for i=1:setup.nEntre
    agent(counter).cellPosition = [x(i) y(i)];
    agent(counter).status = 'Entrepreneur';
    setup.entrePositions(counter,:) = [x(i) y(i)];
    counter = counter+1;
end
clear x y
[x,y]=find(setup.cell.G==2);
% 1 = entrepreneur
for i=1:setup.nJobless
    agent(counter).cellPosition =[x(i) y(i)];
    agent(counter).status = 'Jobless';
    counter = counter+1;
end
% all agent basic
for i=1:setup.nAgent
    agent(i).wealth = 3000;
    agent(i).rent = 0;
    agent(i).move = 0; % decision to move due to high rent
    agent(i).entrePositions = setup.entrePositions;
end

%% cell automata
% 1 tick = 1 quarter
for ticks=1:setup.nTicks
    setup.ticks=ticks;
    % find job
    [setup, agent] = cellAutomata(setup, agent);
    
    % update agent intensity
    [setup, agent] = countEmployees(setup, agent);
    
    % agent income
    [setup, agent] = getMoney(setup, agent, ticks);
    
    % pay rent
    [setup, agent] = payRent(setup, agent);
    history.rent(:,:,ticks)=setup.rent;
    
    % agents predict rent price
    if ticks>4 % delay for prediction
    [setup, agent] = canIpay(setup, agent, history, ticks);
    end
    
    % move house
    [setup, agent] = moveHouse(setup, agent);
    
    % save agent history
    [setup, agent] = agentHistory(setup, agent, ticks);
    
end

%% results viewing

% hand pick some results
[setup, agent, bestWorstIDs] = bestWorst(setup, agent);
IDs=[bestWorstIDs];
% display some results
showLife(IDs, agent);

