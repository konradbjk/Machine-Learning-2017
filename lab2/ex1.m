Sky = [1,2,3];                  %['Sunny','Rainy','Cloudy'];
AirTemp = [1,2];                %['Warm','Cold'];
Humidity =[1,2];                %['Normal','High'];
Wind = [1,2];                   %['Strong','Weak'];
Water = [1,2];                  %['Warm','Cool'];
Forecast =[1,2];                %['Same','Change'];
Enjoy = [0,1];                  %['No','Yes'];

%Features: Sky, AirTemp, Humidity, Wind, Water, Forecast
X = [1,1,1,1,1,1;
    1,1,2,1,1,1;
    2,2,2,1,1,2;
    1,1,2,1,2,2];

C = [1;1;0;1];

%The FIND-S algorithm:
H = findS(X,C);

printf('Hypothesis inducted by Find-S algorithm: \n');
H
fprintf('Program paused. Press enter to continue.\n');
pause;

