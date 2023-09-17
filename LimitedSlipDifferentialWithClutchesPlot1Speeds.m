% Code to plot simulation results from LimitedSlipDifferentialWithClutches
%% Plot Description:
%
% The plot below shows the performance of an open and a limited slip
% differential on a split surface (ice and tarmac). The limited slip
% differential locks when the left wheel encounters the icy patch, and the
% left and right wheel speeds remain the same.  The open differential does
% not lock and applies the same torque to both shafts. The result is that
% the left wheel loses traction on the icy patch and slips.

% Copyright 2016 The MathWorks, Inc.

% Generate simulation results if they don't exist
if ~exist('simlog_LimitedSlipDifferentialWithClutches', 'var')
    sim('LimitedSlipDifferentialWithClutches')
end

% Reuse figure if it exists, else create new figure
if ~exist('h1_LimitedSlipDifferentialWithClutches', 'var') || ...
        ~isgraphics(h1_LimitedSlipDifferentialWithClutches, 'figure')
    h1_LimitedSlipDifferentialWithClutches = figure('Name', 'LimitedSlipDifferentialWithClutches');
end
figure(h1_LimitedSlipDifferentialWithClutches)
clf(h1_LimitedSlipDifferentialWithClutches)

% Get simulation results
simlog_t = simlog_LimitedSlipDifferentialWithClutches.Limited_Slip_Torque_Source.t.series.time;
simlog_limslipLwhlW = simlog_LimitedSlipDifferentialWithClutches.Tires_Limited_Slip_Differential.Tire_Left.A.w.series.values('rpm');
simlog_limslipRwhlW = simlog_LimitedSlipDifferentialWithClutches.Tires_Limited_Slip_Differential.Tire_Right.A.w.series.values('rpm');
simlog_openLwhlW = simlog_LimitedSlipDifferentialWithClutches.Tires_Open_Differential.Tire_Left.A.w.series.values('rpm');
simlog_openRwhlW = simlog_LimitedSlipDifferentialWithClutches.Tires_Open_Differential.Tire_Right.A.w.series.values('rpm');
simlog_torque = simlog_LimitedSlipDifferentialWithClutches.Limited_Slip_Torque_Source.t.series.values('N*m');

temp_surface = logsout_LimitedSlipDifferentialWithClutches.get('Wheel_Surface');

temp_colororder = get(gca,'defaultAxesColorOrder');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
yyaxis left
plot(simlog_t, simlog_limslipLwhlW, 'LineWidth', 1);
hold on
plot(simlog_t, simlog_limslipRwhlW, '--','LineWidth', 2);
ylabel('Speed (RPM)')
yyaxis right
plot(simlog_t, simlog_openLwhlW, 'LineWidth', 1)
plot(simlog_t, simlog_openRwhlW, 'LineStyle','--', 'LineWidth', 2)
hold off
grid on
title('Wheel Speeds on Split Surface Test')
ylabel('Speed (RPM)')
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
clear simlog_openLwhlW simlog_openRwhlW 
clear simlog_limslipLwhlW simlog_limslipRwhlW
clear temp_colororder temp_surface
