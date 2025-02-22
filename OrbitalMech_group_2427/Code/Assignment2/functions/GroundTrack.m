function [alpha, delta, lon, lat] = GroundTrack(s, thetaG0, tv, wE)

% GroundTrack - Computation of latitude, longitude and ground track plot 
% over time interval tv.
%
% PROTOTYPE:
%   [alpha, delta, lon, lat] = GroundTrack(r, thetaG0, tv, wE)
%
% DESCRIPTION:
%   The function computes latitude, longitude, right ascension and
%   declination and plots the ground track of an object over the time span
%   tv. s can be both the object's position in Cartesian coordinates or
%   the Keplerian elements, propagated over the time span.
%
% INPUT: 
%   s [3xn]         Position over time span tv 
%                   in Cartesian coordinates (rx, ry, rz)      [km]
%     or
%
%   s[6xn]          Keplerian elements over time span tv
%                   (a, e, i, OM, om, theta)                   [km, -, rad]
%
%   thetaG0 [1x1]   Greenwich sidereal time at t0              [rad]
%                   (beginning of computation)
%   tv [1xn]        Time span of orbit propagation             [s]
%   wE [1x1]        Earth's rotation velocity                  [rad/s]
%
% OUTPUT:
%   alpha [1xn]     Right ascension in ECI in time span tv        [rad]
%   delta [1xn]     Declination in ECI in time span tv            [rad]
%   lon [1xn]       Longitude with respect to rotating Earth      [deg]
%   lat [1xn]       Latitude with respect to rotating Earth       [deg]
%
% CONTRIBUTORS:
%   Azevedo Da Silva Esteban
%   Gavidia Pantoja Maria Paulina
%   Donati Filippo 
%   Domenichelli Eleonora
%
%-------------------------------------------------------------------------

% Variable extraction
n = length(tv);

if size(s, 1) == 6
    kep = s;
    r = zeros(3,n);
    
    % Obtain r
    for k = 1:n
        r(:,k) = parorb2rv (kep(1,k), kep(2,k), kep(3,k), kep(4,k), kep(5,k), kep(6,k), muE);
    end

elseif size(s,1) == 3
    r = s;
end

% Vectors initialization
delta = zeros(1, n);
alpha = zeros (1, n);
lon = zeros (1, n);

% Computation of outputs
for i = 1:n
    r_norm = norm(r(:, i));

    % Right ascension and declination
    delta(i) = asin(r(3,i)/r_norm);
    alpha(i) = atan2(r(2,i), r(1, i));

    % Greenwich sidereal time at every time sted
    thetaG = thetaG0 + wE*tv(i);

    % Longitude, wrapped between [-pi, +pi]
    lon(i) = (alpha(i) - thetaG);

    if ((lon(i) < -pi) || (lon(i) > pi))
        lon(i) = mod(lon(i)+pi, 2*pi) - pi;
    end

end

% Latitude 
lat = delta;

% Conversion to deg for plot and results readability
lon = rad2deg(lon);
lat = rad2deg(lat);

% Ground track plot
S = imread("EarthTexture.jpg");

figure
image([-180, 180], [90, -90], S);
hold on;
grid minor;

plot(lon, lat, 'g', 'LineStyle','none','Marker','.');
plot(lon(1,1), lat(1,1), 'ro', 'LineWidth', 2)
plot(lon(1,end), lat(1,end), 'rs', 'LineWidth', 2)
set(gca, 'YDir', 'normal')

xlabel("Longitude [deg]");
ylabel("Latitude [deg]");
legend("Ground track", "Initial point", "Final point");
end

