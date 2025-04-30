function out = radarBuilder(MAP, X_INDEX, Y_INDEX, Z_INDEX, RADIUS )
% Yarım küre parametreleri

[ xLim, yLim ] = size(MAP.X);

% Küreyi oluşturmak için açılar
[theta, phi] = meshgrid(linspace(0, 2*pi, xLim), linspace(0, pi/2, yLim));

% Küresel koordinatları Kartezyen'e çevir
X = RADIUS * sin(phi) .* cos(theta) + X_INDEX;
Y = RADIUS * sin(phi) .* sin(theta) + Y_INDEX;
Z = RADIUS * cos(phi) + Z_INDEX;

out = MAP.Z + Z;


% 3D Görselleştirme
surf(X, Y, Z, 'FaceColor', 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
