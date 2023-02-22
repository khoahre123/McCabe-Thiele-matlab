clear;
clc;
% Equilibrium curve data - generated in Aspen 
ethanol_liq = [0	0.02	0.04	0.06	0.08	0.1	0.12	0.14	0.16 ...
    0.18	0.2	0.22	0.24	0.26	0.28	0.3	0.32	0.34	0.36 ...	
    0.38	0.4	0.42	0.44	0.46	0.48	0.5	0.52	0.54	0.56	0.58 ...
    0.6	0.62	0.64	0.66	0.68	0.7	0.72	0.74	0.76	0.78	0.8 ...
    0.82	0.84	0.86	0.88	0.9	0.92	0.94	0.96	0.98	1];

ethanol_vap = [0	0.184325	0.291801	0.361617	0.41029	0.445993	0.473233 ...
    0.494699	0.512097	0.526561	0.538874	0.549595	0.559131	0.56779	...
    0.575806	0.583359	0.590595	0.597628	0.604552	0.611445	0.61837	...
    0.625383	0.63253	0.639851	0.647382	0.655155	0.663199	0.671539	0.680202 ...
    0.68921	0.698585	0.70835	0.718526	0.729134	0.740196	0.751734	0.763771 ...
    0.77633	0.789434	0.803109	0.817381	0.832279	0.847831	0.864068	0.881024 ...
    0.898734	0.917235	0.936568	0.956775	0.977902	1];

% Part a
% top_vap = [0.8198247509 0.7344282907 0.4588127898];
% top_liq = [0 0 0];
% relative_volt_top = [0 0 0];
% bottom_vap = [0 0 0];
% bottom_liq = [0.02640906961 0.01848575858 0.004267479015];
% relative_volt_bot = [0 0 0];
% average_volt = [0 0 0];
% fenske = [0 0 0];
% for i = 1:length(top_vap)
%     top_liq(i) = getIntersect(ethanol_liq, ethanol_vap, top_vap(i), false);
%     bottom_vap(i) = getIntersect(ethanol_liq, ethanol_vap, bottom_liq(i), true);
%     relative_volt_top(i) = (top_vap(i)/top_liq(i))/((1-top_vap(i))/(1-top_liq(i)));
%     relative_volt_bot(i) = (bottom_vap(i)/bottom_liq(i))/((1-bottom_vap(i))/(1-bottom_liq(i)));
%     average_volt(i) = sqrt(relative_volt_top(i)*relative_volt_bot(i));
%     fenske(i) = log10((top_liq(i)/(1 - top_liq(i)))*((1 - bottom_liq(i))/bottom_liq(i)))/log10(average_volt(i)) - 1;
%     McTh(ethanol_liq, ethanol_vap, top_vap(i), bottom_liq(i), 0, 1, 2, 3, true);
% end

% Part b
top_vap = [0.7699878307 0.7785024076 0.7150159601];
top_liq = [0 0 0];
bottom_vap = [0 0 0];
bottom_liq = [0.03051821695 0.03297380992 0.02615242271];
reflux = [10 5 1];
topX = [0 0];
topY = [0 0];
% Data from Aspen
Hf = -283732.493468122;
Hvap = -237901.254818003;
Hliq = -278477.463592330;
q = (Hvap - Hf)/(Hvap - Hliq);
z = 0.1731447796;
yF = (q/(q-1))*0.3 + (1/(1-q))*z;
feedX = [0.3, z];
feedY = [yF, z];
for i = 1:length(top_vap)
    top_liq(i) = getIntersect(ethanol_liq, ethanol_vap, top_vap(i), false);
    bottom_vap(i) = getIntersect(ethanol_liq, ethanol_vap, bottom_liq(i), true);
    topY(1) = top_vap(i)/(reflux(i) + 1);
    topX(2) = top_vap(i);
    topY(2) = top_vap(i);
    McTh(ethanol_liq, ethanol_vap, top_vap(i), bottom_liq(i), topX, topY, feedX, feedY, false);
end


% for i = 1:length(top_vap)
% end
    
% Plotting the equilibrium curve
% x = [0.85, 0.65];
% y = [0.75, 0.75];
% figure
% hold on;
% plot(ethanol_liq, ethanol_vap, ethanol_liq, ethanol_liq)
% set(line(x, y),'Color',[1 0 0], 'LineWidth', 0.75);
% x(1) = 0.65;
% y(1) = 0.85;
% set(line(x, y),'Color',[1 0 0], 'LineWidth', 0.75);
% hold off

function interSect = getIntersect(equilX, equilY, constPoint, isVertical)
if isVertical
    x = [constPoint, constPoint];
    y = [0 1];
    [xCoord, yCoord] = intersections(equilX, equilY, x, y);
    interSect = yCoord;
else
    x = [0 1];
    y = [constPoint, constPoint];
    [xCoord, yCoord] = intersections(equilX, equilY, x, y);
    interSect = xCoord;
end
end

function McTh(ethanol_liq, ethanol_vap, startingY, endingX, tolX, tolY, feedX, feedY, isTotal)
    figure
    hold on;
    plot(ethanol_liq, ethanol_vap, ethanol_liq, ethanol_liq)
    x = [0, startingY];
    y = [startingY, startingY];
    currentX = startingY;
    if isTotal
        while currentX > endingX
            % Set horizontal intersect line
            [xCoord, yCoord] = intersections(ethanol_liq, ethanol_vap, x, y);
            x(1) = xCoord;
            set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
            % Set vertical intersect line
            x(2) = xCoord;
            y(2) = xCoord;
            set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
            currentX = xCoord;
            y(1) = xCoord;
            x(1) = 0;
        end
    else
        [xIntersect, yIntersect] = intersections(tolX, tolY, feedX, feedY);
        set(line(tolX, tolY),'Color', [0 1 0], 'LineWidth', 0.75);
        xBot = [endingX, xIntersect];
        yBot = [endingX, yIntersect];
        set(line(xBot, yBot),'Color', [0 0 1], 'LineWidth', 0.75);
        [xFancy, yFancy] = intersections(feedX, feedY, ethanol_liq, ethanol_vap);
        feedX(1) = xFancy;
        feedY(1) = yFancy;
        set(line(feedX, feedY),'Color', [1 0 1], 'LineWidth', 0.75);
        while currentX > endingX
            % Set horizontal intersect line
            [xCoord, yCoord] = intersections(ethanol_liq, ethanol_vap, x, y);
            x(1) = xCoord;
            set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
            currentX = xCoord;
            if currentX < endingX
                % Set vertical intersect line
                x(2) = xCoord;
                y(2) = xCoord;
                set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
                y(1) = yCoord;
                x(1) = 0;                
            elseif currentX > xIntersect
                % Set vertical intersect line
                x(2) = xCoord;
                y(2) = xCoord;
                [xCoord, yCoord] = intersections(tolX, tolY, x, y);
                y(2) = yCoord;
                set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
                y(1) = yCoord;
                x(1) = 0;
            else
                % Set vertical intersect line
                x(2) = xCoord;
                y(2) = xCoord;
                [xCoord, yCoord] = intersections(xBot, yBot, x, y);
                y(2) = yCoord;
                set(line(x, y),'Color', [1 0 0], 'LineWidth', 0.75);
                y(1) = yCoord;
                x(1) = 0;
            end
        end
    end
    axis([0 1 0 1]);
    xlabel('x_A')
    ylabel('y_A')
    hold off;
end