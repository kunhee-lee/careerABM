function [setup, agent] = cellAutomata(setup, agent)

employee='Employee';
jobless='Jobless';
entrepreneur='Entrepreneur';

% turn to local
N = setup.cell.grid;
neigh = setup.cell.neigh;
G = setup.cell.G;

for aCount=setup.nEntre+1:setup.nAgent
    entrePositions = agent(aCount).entrePositions;
    for k=1:length(neigh)
        i2 = agent(aCount).cellPosition(1)+neigh(k, 1);
        j2 = agent(aCount).cellPosition(2)+neigh(k, 2);
        if ( i2>=1 && j2>=1 && i2<=N && j2<=N )
            % found entrepreneur
%             if (G(i2,j2))==1;
%                 agent(aCount).status = 'Employee';
%             end
            if (G(i2,j2)==0);
                 % find empty neigh
                emptyNeigh(k)=1;
            else
                emptyNeigh(k)=0;
            end
        end   
    end
    % still jobless
    if strcmp(agent(aCount).status,jobless)==1
        for i=1:length(entrePositions(:,1))
            vel(i,:) = [entrePositions(i,1)-agent(aCount).cellPosition(1) ...
            entrePositions(i,2)-agent(aCount).cellPosition(2)];
        end
        [mag,magPos] = min(sqrt(vel(:,1).^2 + vel(:,2).^2));
        vel = sign(vel);
        vel=vel(magPos,:);
        
        setup.cell.neigh = [-1 -1; 0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0];
        localNeigh = [setup.cell.neigh(:,1).*emptyNeigh' setup.cell.neigh(:,2).* emptyNeigh'];
        tempNeigh = [setup.cell.neigh(:,1).*emptyNeigh' setup.cell.neigh(:,2).* emptyNeigh'];
        for i=1:length(setup.cell.neigh(:,1))
            if (vel(1)==setup.cell.neigh(i,1) && vel(2)==setup.cell.neigh(i,2))
                localNeighSwitch=i;
                break;
            end
        end
        switch localNeighSwitch
            case 1
                tempNeigh=[tempNeigh(end-1,:); tempNeigh(end,:); tempNeigh(1,:); tempNeigh(2,:); tempNeigh(3,:)];
                vel=tempNeigh(randi([1,5],1),:);
            case 2
                tempNeigh=[tempNeigh(end,:); tempNeigh(1,:); tempNeigh(2,:); tempNeigh(3,:); tempNeigh(4,:)];
                vel=tempNeigh(randi([1,5],1),:);
            case 3
                vel=tempNeigh(randi([1,5],1),:);
            case 4
                vel=tempNeigh(randi([2,6],1),:);
            case 5
                vel=tempNeigh(randi([3,7],1),:);
            case 6
                vel=tempNeigh(randi([4,8],1),:);
            case 7
                tempNeigh=[tempNeigh(end-3,:); tempNeigh(end-2,:); tempNeigh(end-1,:); tempNeigh(end,:); tempNeigh(1,:)];
                vel=tempNeigh(randi([1,5],1),:);
            case 8
                tempNeigh=[tempNeigh(end-2,:); tempNeigh(end-1,:); tempNeigh(end,:); tempNeigh(1,:); tempNeigh(2,:)];
                vel=tempNeigh(randi([1,5],1),:);
        end
               
        agent(aCount).employer=magPos;
        agent(aCount).jobDistance=mag;
        
        i3 = (agent(aCount).cellPosition(1) + vel(1));
        j3 = (agent(aCount).cellPosition(2) + vel(2));
        if ( i3>=1 && j3>=1 && i3<=N && j3<=N )
        if ( G((agent(aCount).cellPosition(1) + vel(1)),(agent(aCount).cellPosition(2) + vel(2)))==0)
            agent(aCount).cellPosition=agent(aCount).cellPosition + vel;
        
        % if surrounded by '3', count as employed, if not wait for traffic
        % to clear
        else
            countNeigh=0;
            for k=1:length(neigh)
                i2 = agent(aCount).cellPosition(1)+neigh(k, 1);
                j2 = agent(aCount).cellPosition(2)+neigh(k, 2);
                if ( i2>=1 && j2>=1 && i2<=N && j2<=N )
                    countNeigh=countNeigh+G(i2,j2);
                end
            end
            if (countNeigh>3 && agent(aCount).jobDistance<15)
                    agent(aCount).status = 'Employee';
            end
        end
        end
        
        % moveJump
        if agent(aCount).move==2;
            i3 = (agent(aCount).cellPosition(1) + vel(1).*5);
            j3 = (agent(aCount).cellPosition(2) + vel(2).*5);
            if ( i3>=1 && j3>=1 && i3<=N && j3<=N )
            if ( G((agent(aCount).cellPosition(1) + vel(1).*5),(agent(aCount).cellPosition(2) + vel(2).*5))==0)
            agent(aCount).cellPosition=agent(aCount).cellPosition + vel.*5;
            agent(aCount).move=0;
            end
            end
        end
                
    end
end
   

% update grid
G=zeros(N,N);
for aCount=1:setup.nAgent
    if strcmp(agent(aCount).status,employee)==1
        G(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=2;
        if agent(aCount).wealth<0
               G(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=3;
               agent(aCount).status='bankrupt';
        end
    else if strcmp(agent(aCount).status,jobless)==1
            if agent(aCount).wealth<0
               G(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=3;
               agent(aCount).status='bankrupt';
            else
                G(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=2;
            end
            
        else if strcmp(agent(aCount).status,entrepreneur)==1
                G(agent(aCount).cellPosition(1),agent(aCount).cellPosition(2))=1;
            end
        end
    end
end
setup.cell.G = G;

% Animate
clf                          
imagesc(G)                   % Display grid
pause(0.1)                         % Pause for 0.01 s
colormap([1 1 1; 0 1 0; 0 0 1 ]);    

end