function output_guidance_system = guidance_system(X, previous_waypoint, next_waypoint)

persistent cross_track_error_last waypoint_index waypoint_collection

approach_distance = evalin('base', 'approach_distance');

x     = X(1);
y     = X(2);

d_x   = X(4);
d_y   = X(5);

position = [x y]';
velocity = [d_x d_y]';

%% Navigation calculations

delta_waypoint = next_waypoint - previous_waypoint;

alpha = atan2(delta_waypoint(2), delta_waypoint(1));

R = [cos(alpha) -sin(alpha);
     sin(alpha)  cos(alpha)];

delta_position = position - previous_waypoint;

epsilon = R' * delta_position;

cross_track_error = epsilon(2);

if(isempty(cross_track_error_last))
	cross_track_error_last = cross_track_error;
end	

d_cross_track_error    = cross_track_error - cross_track_error_last;

%% Select suitable controller

if (norm(next_waypoint - position) < approach_distance)
	theta_wb_c = position_hold_controller(X, alpha, next_waypoint);
else
	theta_wb_c = tracking_controller(X, alpha, cross_track_error, d_cross_track_error);
end

cross_track_error_last = cross_track_error;

output_guidance_system = [theta_wb_c' cross_track_error]';

end