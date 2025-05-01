%% Cleaning - Temizlik Islemleri
clc; clear; close all;

%% MAP
% Constants - Sabitler
MAP.X_MIN_LIMIT = -100;
MAP.X_MAX_LIMIT =  100;
MAP.Y_MIN_LIMIT = -100;
MAP.Y_MAX_LIMIT =  100;
MAP.Z_MIN_LIMIT =    0;
MAP.Z_MAX_LIMIT =   15;
MAP.STEP        =    1;

% System Variable - Sistem Degsikenleri
[MAP.X, MAP.Y]  = meshgrid(MAP.X_MIN_LIMIT:MAP.STEP:MAP.X_MAX_LIMIT, MAP.Y_MIN_LIMIT:MAP.STEP:MAP.Y_MAX_LIMIT);
MAP.Z = zeros(size(MAP.X));

% 3D MAP Settings - 3D Harita Ayarlari
figure;
hold on;
xlabel('X Ekseni [km]'); ylabel('Y Ekseni[km]'); zlabel('Yükseklik [km]');
title('Test Ortamı');
axis tight;
view(3);

% 3D MAP BUILD
MAP.Z = highlandBuilder(MAP,MAP.X_MAX_LIMIT,0.01,MAP.Y_MAX_LIMIT,0.01,MAP.Z_MAX_LIMIT);
MAP.Z = highlandBuilder(MAP,16,20,2,3,12);
MAP.Z = highlandBuilder(MAP,-30,20,-20,30,8);
MAP.Z = highlandBuilder(MAP,60,10,60,4,10);
MAP.Z = highlandBuilder(MAP,80,10,-60,2,5);
% MAP.Z = radarBuilder(MAP,-5,3,0,10);
% MAP.Z = radarBuilder(MAP,-60,60,0,10);


%% OTHER
N = 100; % Gösterilecek geçmiş adım sayısı
path1X = [-95];
path1Y = [-95];
path1Z = [0];
path2X = [100];
path2Y = [-97];
path2Z = [0];

plot3(42, 33, 4, 'ro', 'MarkerSize',3, 'MarkerFaceColor', 'r');
hPoint = plot3(-95, -95, 0, 'ro', 'MarkerSize', 3, 'MarkerFaceColor', 'g');

p1 = pso3D(MAP,[-95,-95,0],[42,33,4]);
p2 = pso3D(MAP,[100,-97,0],[42,33,4]);
while true
    p1 = p1.calculatePosition();
    p2 = p2.calculatePosition();

    % Geçmiş konumları diziye ekle
    path1X = [path1X, p1.gBestLocation.x];
    path1Y = [path1Y, p1.gBestLocation.y];
    path1Z = [path1Z, p1.gBestLocation.z];

    path2X = [path2X, p2.gBestLocation.x];
    path2Y = [path2Y, p2.gBestLocation.y];
    path2Z = [path2Z, p2.gBestLocation.z];

    % Yalnızca son N noktayı göster
    if length(path1X) > N
        path1X = path1X(end-N+1:end);
        path1Y = path1Y(end-N+1:end);
        path1Z = path1Z(end-N+1:end);
    end


    if length(path2X) > N
        path2X = path2X(end-N+1:end);
        path2Y = path2Y(end-N+1:end);
        path2Z = path2Z(end-N+1:end);
    end

    % Noktayı güncelle
    set(hPoint, 'XData', p1.gBestLocation.x, 'YData', p1.gBestLocation.y, 'ZData', p1.gBestLocation.z);
    % Yolu çiz (her iterasyonda çizgiyi güncelle)
    plot3(path1X, path1Y, path1Z, 'g-', 'LineWidth', 2);  % Geçmiş yol çizgisi
    plot3(path2X, path2Y, path2Z, 'b-', 'LineWidth', 2);  % Geçmiş yol çizgisi
    drawnow; % Gerçek zamanlı güncelleme

    pause(0.1); % Küçük bir bekleme süresi ekleyerek animasyonu akıcı hale getir

end

