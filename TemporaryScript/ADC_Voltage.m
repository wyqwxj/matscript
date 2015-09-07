close;
Vref = 1.9;
ADC_range = 2^12 - 1;
VoltageOfPowerSource = [3.5 3.6 3.7 3.4 3.3 3.2 3.1];
ADC_reading = [2726 2725 2727 2726 2724 2726 2727; 2807 2807 2805 2807 2806 2805 2807;
                          2883 2884 2883 2883 2884 2883 2883; 2642 2643 2646 2645 2644 2647 2642;
                          2564 2566 2562 2564 2563 2568 2567; 2484 2483 2485 2481 2487 2485 2482;
                          2406 2400 2399 2399 2406 2401 2402;]';
ADC_voltage = zeros(1, size(ADC_reading, 2));

for i = 1:size(ADC_voltage, 2);
    ADC_voltage(i) =  mean(ADC_reading(:,i)) / 4095 * Vref;
end

plot(ADC_voltage, VoltageOfPowerSource, '*r');
hold on;

xx = 1:0.1:1.9;
BAT_voltage_estimate = zeros(1, size(xx, 2));
[P, s] = polyfit(ADC_voltage, VoltageOfPowerSource, 1);

for i = 1:size(BAT_voltage_estimate, 2)
    BAT_voltage_estimate(i) = P(1) * xx(i) + P(2);
end

plot(xx, BAT_voltage_estimate);