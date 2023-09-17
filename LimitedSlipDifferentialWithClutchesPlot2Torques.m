% Code to plot simulation results from LimitedSlipDifferentialWithClutches
%% Plot Description:
%
% The plot below shows the performance of open and a limited slip
% differential on a split surface (ice and tarmac). The limited slip
% differential locks instantly when the left wheel encounters the icy
% patch.  As a result, the wheels turn at the same speed and more torque is
% applied to the wheel on the high friction surface.  The open differential
% does not lock.  The same torque is applied to both wheels, resulting in
% the right wheel slipping extensively on the icy patch.

% Copyright 2016 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_LimitedSlipDifferentialWithClutches', 'var')
    sim('LimitedSlipDifferentialWithClutches')
end

% Reuse figure if it exists, else create new figure
if ~exist('h2_LimitedSlipDifferentialWithClutches', 'var') || ...
        ~isgraphics(h2_LimitedSlipDifferentialWithClutches, 'figure')
    h2_LimitedSlipDifferentialWithClutches = figure('Name', 'LimitedSlipDifferentialWithClutches');
end
figure(h2_LimitedSlipDifferentialWithClutches)
clf(h2_LimitedSlipDifferentialWithClutches)

% Get simulation results
simlog_t = simlog_LimitedSlipDifferentialWithClutches.Limited_Slip_Torque_Source.t.series.time;
simlog_limitslipLwhlTrq = simlog_LimitedSlipDifferentialWithClutches.Tires_Limited_Slip_Differential.Sensor_Left.Torque_Sensor.t.series.values('N*m');
simlog_limitslipRwhlTrq = simlog_LimitedSlipDifferentialWithClutches.Tires_Limited_Slip_Differential.Sensor_Right.Torque_Sensor.t.series.values('N*m');
simlog_openLwhlTrq = simlog_LimitedSlipDifferentialWithClutches.Open_Differential.sun_planet_left.t_S.series.values('N*m');
simlog_openRwhlTrq = simlog_LimitedSlipDifferentialWithClutches.Open_Differential.sun_planet_left.t_S.series.values('N*m');
simlog_torque = simlog_LimitedSlipDifferentialWithClutches.Limited_Slip_Torque_Source.t.series.values('N*m');

temp_surface = logsout_LimitedSlipDifferentialWithClutches.get('Wheel_Surface');

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
plot(simlog_t, simlog_limitslipLwhlTrq, 'LineWidth', 1,'Color',temp_colororder(1,:));
hold on
plot(simlog_t, simlog_limitslipRwhlTrq, '--','LineWidth', 2,'Color',temp_colororder(1,:));
ylabel('Torque (N*m)')
plot(simlog_t, -simlog_openLwhlTrq, 'LineWidth', 1,'Color',temp_colororder(2,:))
plot(simlog_t, -simlog_openRwhlTrq, 'LineStyle','--', 'LineWidth', 2,'Color',temp_colororder(2,:))
hold off
grid on
title('Shaft Torques on Split Surface Test')
ylabel('Torque (N*m)')
legend({'Limited Slip Left','Limited Slip Right','Open Left','Open Right'},'Location','NorthWest');

simlog_handles(2) = subplot(2, 1, 2);
yyaxis left
plot(temp_surface.Values.Time, temp_surface.Values.Data, 'LineWidth', 1,'Color',temp_colororder(4,:))
ylabel('Surface')
set(gca,'YLim',[0.9 2.1],'YTick',1:2)
set(gca,'YTickLabel',{'Ice' 'Dry'})
set(gca,'YColor',temp_colororder(4,:))
yyaxis right
plot(simlog_t, simlog_torque, 'LineWidth', 1,'Color',temp_colororder(5,:))
set(gca,'YColor',temp_colororder(5,:))
grid on
title('Surface and Engine Torque')
ylabel('Engine Torque (N*m)')
xlabel('Time (s)')
legend({'Left Surface','Right Surface','Engine Torque'},'Location','West');

linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles
clear simlog_torque 
clear simlog_openLwhlTrq simlog_openRwhlTrq 
clear simlog_limitslipLwhlTrq simlog_limitslipRwhlTrq
clear temp_colororder temp_surface
