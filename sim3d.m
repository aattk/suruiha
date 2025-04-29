%% Cleaning - Temizlik Islemleri
clc; clear; close all;

%% MAP
% Constants - Sabitler
MAP.X_MIN_LIMIT = -100;
MAP.X_MAX_LIMIT =  100;
MAP.Y_MIN_LIMIT = -100;
MAP.Y_MAX_LIMIT =  100;
MAP.Z_MIN_LIMIT =    0;
MAP.Z_MAX_LIMIT =   12;
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
highlandBuilder(MAP,MAP.X_MAX_LIMIT,0.01,MAP.Y_MAX_LIMIT,0.01,MAP.Z_MAX_LIMIT);
highlandBuilder(MAP,2,2,2,3,4);
highlandBuilder(MAP,4,6,8,3,3);
highlandBuilder(MAP,1,10,12,2,2);
highlandBuilder(MAP,-15,10,-10,2,5);
radarBuilder(MAP,-5,3,0,10);
radarBuilder(MAP,15,3,0,10);


%% OTHER
N = 100; % Gösterilecek geçmiş adım sayısı
pathX = [-50]; % Başlangıç X koordinatını diziye ekle
pathY = [-50]; % Başlangıç Y koordinatını diziye ekle
pathZ = [0];   % Başlangıç Z koordinatını diziye ekle


plot3(21, 8, 8, 'ro', 'MarkerSize',3, 'MarkerFaceColor', 'r');
hPoint = plot3(-50, -50, 0, 'ro', 'MarkerSize', 3, 'MarkerFaceColor', 'g');

p = pso3D(MAP,[-50,-50,0],[21,8,8]);  
p = p.calculatePosition();

while true 
    p = p.calculatePosition(); 
    
    % Geçmiş konumları diziye ekle
    pathX = [pathX, p.gBestLocation.x];
    pathY = [pathY, p.gBestLocation.y];
    pathZ = [pathZ, p.gBestLocation.z];
    
    % Yalnızca son N noktayı göster
    if length(pathX) > N
        pathX = pathX(end-N+1:end);
        pathY = pathY(end-N+1:end);
        pathZ = pathZ(end-N+1:end);
    end
    

        % Noktayı güncelle
        set(hPoint, 'XData', p.gBestLocation.x, 'YData', p.gBestLocation.y, 'ZData', p.gBestLocation.z);
        % Yolu çiz (her iterasyonda çizgiyi güncelle)
        plot3(pathX, pathY, pathZ, 'g-', 'LineWidth', 2);  % Geçmiş yol çizgisi
        drawnow; % Gerçek zamanlı güncelleme

    % pause(0.1); % Küçük bir bekleme süresi ekleyerek animasyonu akıcı hale getir

end

