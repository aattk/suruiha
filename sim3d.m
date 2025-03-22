%% Cleaning - Temizlik Islemleri
clc; clear; close all;

%% Constants - Sabitler
MAP.X_MIN_LIMIT = -20;
MAP.X_MAX_LIMIT =  20;
MAP.Y_MIN_LIMIT = -20;
MAP.Y_MAX_LIMIT =  20;
MAP.STEP        = 0.1;

%% System Variable - Sistem Degsikenleri 
MAP.Z           = meshgrid(MAP.X_MIN_LIMIT:MAP.STEP:MAP.X_MAX_LIMIT, MAP.Y_MIN_LIMIT:MAP.STEP:MAP.Y_MAX_LIMIT) ;

%% 3D MAP
figure;
hold on;
xlabel('X Ekseni'); ylabel('Y Ekseni'); zlabel('Yükseklik [m x1000]');
title('Test Ortamı');
axis tight;
view(3);

%% 3D MAP BUILD
highlandBuilder(MAP,2,2,2,3,0.5);
highlandBuilder(MAP,4,6,8,3,0.5);
highlandBuilder(MAP,1,10,12,2,0.65);
highlandBuilder(MAP,-15,10,-10,2,0.2);

%% OTHER
xx = -20;
yy = -20;
zz =   0;


hPoint = plot3(xx, yy, zz, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% highlandBuilder()

while true 
   
    xx = xx + rand(1)*0.001;
    yy = yy + rand(1)*0.001;
    zz = zz + rand(1)*0.001;

    % Noktayı güncelle
    set(hPoint, 'XData', xx, 'YData', yy, 'ZData', zz);
    
    drawnow; % Gerçek zamanlı güncelleme
    pause(0.01); % Küçük bir bekleme süresi ekleyerek animasyonu akıcı hale getir
end