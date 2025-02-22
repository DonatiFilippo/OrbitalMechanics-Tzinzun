function thetaG0 = thetaG0_computation(J0, UT, w_E)

% thetaG0_computation - Compute the Greenwich Local Sideral Time
%
% PROTOTYPE:
%   thetaG0 = thetaG0_computation(J0, UT, w_E)
%
% DESCRIPTION:
%   Compute the Greenwich Local Sideral Time at a given Date and time
%
% INPUT:
%   J0 [1x1]        Julian Day number at 0 UT for the desired Date
%
%   UT [1x1]        Universal Time of the desired Date                 [hr]
%
%   w_E [1x1]       Earth's rotation angular velocity               [rad/s]
%
% OUTPUT:
%   thetaG0 [1x1]   Greenwich Local Sideral Time at a give Date       [rad]
%
% CONTRIBUTORS:
%   Azevedo Da Silva Esteban
%   Gavidia Pantoja Maria Paulina
%   Donati Filippo 
%   Domenichelli Eleonora
%
% -------------------------------------------------------------------------

% Convert w_E from rad/s to deg/hr
w_E = rad2deg(w_E) * 3600;

% Evaluate the number of century passed since J2000
T0 = (J0 - 2451545)/36525;

% Evaluate the desired Greenwich Local Sideral Time
thetaG_t0 = wrapTo360(100.4606184 + 36000.77004*T0 + 0.000387933*(T0^2) - 2.583*(10^-8)*(T0^3));

% Wrap and convert the result to radiants
thetaG0 = wrapTo360(thetaG_t0 + w_E*UT);
thetaG0 = deg2rad(thetaG0);
end