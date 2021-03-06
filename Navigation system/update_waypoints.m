function waypoints = update_waypoints(X, constants)

persistent waypoint_collection waypoint_index

x = X(1);
y = X(2);

position = [x y]';

if (isempty(waypoint_collection))
    
    % Define waypoints
    
	wp_0 = [  0   0]';
	wp_1 = [ 20  10]';
	wp_2 = [ 30  35]';
	wp_3 = [-10  40]';
	wp_4 = [-30  30]';
	wp_5 = [-50  10]';
	wp_6 = [-20 -10]';

	waypoint_collection = [wp_0 wp_1 wp_2 wp_3 wp_4 wp_5 wp_6];

	waypoint_index = 1;
end

waypoints.n_waypoints       = length(waypoint_collection);
waypoints.waypoint_collection        = waypoint_collection;
waypoints.previous_waypoint = waypoint_collection(:, waypoint_index);
waypoints.next_waypoint     = waypoint_collection(:, waypoint_index + 1);

if(norm(waypoints.next_waypoint - position) < constants.approach_distance && waypoint_index < waypoints.n_waypoints - 1)
	waypoint_index              = waypoint_index + 1;
	waypoints.previous_waypoint = waypoint_collection(:, waypoint_index);
	waypoints.next_waypoint     = waypoint_collection(:, waypoint_index + 1);	
end


end