function showLife(IDs, agent)
    
for i=1:length(IDs)
    figure(i)
    plot(1:1:length(agent(IDs(i)).history.wealth),agent(IDs(i)).history.wealth,'k-');
    plot(1:1:length(agent(IDs(i)).history.wealth),agent(IDs(i)).history.wealth,'k-');
end
figure(1)
title('Richest Entrepreneur')
ylabel('Wealth')
xlabel('Quarters')
figure(2)
title('Richest Employee')
ylabel('Wealth')
xlabel('Quarters')
figure(3)
title('Poorest Jobless')
ylabel('Wealth')
xlabel('Quarters')
end