function [] = radarBuilder(MAP, X_INDEX, Y_INDEX, Z_INDEX, RADIUS )
% Yarım küre parametreleri

% Küreyi oluşturmak için açılar
[theta, phi] = meshgrid(linspace(0, 2*pi, 360), linspace(0, pi/2, 360));

% Küresel koordinatları Kartezyen'e çevir
X = RADIUS * sin(phi) .* cos(theta) + X_INDEX;
Y = RADIUS * sin(phi) .* sin(theta) + Y_INDEX;
Z = RADIUS * cos(phi) + Z_INDEX;


% 3D Görselleştirme
surf(X, Y, Z, 'FaceColor', 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
