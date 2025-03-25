%% Cleaning - Temizlik Islemleri
clc; clear; close all;

%% Constants - Sabitler
MAP.X_MIN_LIMIT = -50;
MAP.X_MAX_LIMIT =  50;
MAP.Y_MIN_LIMIT = -50;
MAP.Y_MAX_LIMIT =  50;
MAP.Z_MIN_LIMIT =   0;
MAP.Z_MAX_LIMIT =  20;
MAP.STEP        = 0.1;

%% System Variable - Sistem Degsikenleri 
[MAP.X, MAP.Y]  = meshgrid(MAP.X_MIN_LIMIT:MAP.STEP:MAP.X_MAX_LIMIT, MAP.Y_MIN_LIMIT:MAP.STEP:MAP.Y_MAX_LIMIT);
MAP.Z = zeros(size(MAP.X));

%% 3D MAP Settings - 3D Harita Ayarlari
figure;
hold on;
xlabel('X Ekseni'); ylabel('Y Ekseni'); zlabel('Yükseklik [m x1000]');
title('Test Ortamı');
axis tight;
view(3);

%% 3D MAP BUILD
highlandBuilder(MAP,MAP.X_MAX_LIMIT,0.01,MAP.Y_MAX_LIMIT,0.01,MAP.Z_MAX_LIMIT);
highlandBuilder(MAP,2,2,2,3,4);
highlandBuilder(MAP,4,6,8,3,3);
highlandBuilder(MAP,1,10,12,2,2);
highlandBuilder(MAP,-15,10,-10,2,5);


radarBuilder(MAP,-5,3,0,10);
radarBuilder(MAP,15,3,0,10);



%% OTHER
xx = -20;
yy = -20;
zz =   0;


hPoint = plot3(xx, yy, zz, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'g');

p = pso3D(MAP,[-50,-50,0],[32,45,5]);  
p = p.calculatePosition(); 
while true 
    p = p.calculatePosition(); 




    % Noktayı güncelle
    % set(hPoint, 'XData', xx, 'YData', yy, 'ZData', zz);

    drawnow; % Gerçek zamanlı güncelleme
    pause(0.1); % Küçük bir bekleme süresi ekleyerek animasyonu akıcı hale getir
end

