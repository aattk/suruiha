function out = highlandBuilder(MAP, X_INDEX,X_WIDTH, Y_INDEX,Y_WIDTH, HEIGHT )
% HIGHLANDBUILDER - @alpaslantetik
%   3D plotta dag olusturmak icin kullanilir. 

[X, Y] = meshgrid(MAP.X_MIN_LIMIT:MAP.STEP:MAP.X_MAX_LIMIT, MAP.Y_MIN_LIMIT:MAP.STEP:MAP.Y_MAX_LIMIT);

% Noise ekleyerek gerçekçilik artırıldı
Z = exp(-( ( X - X_INDEX ) / X_WIDTH ).^2 - ( ( Y - Y_INDEX) / Y_WIDTH).^2 ) * HEIGHT + rand( size( X ) ) * 0.001;

% Carpisma Tespiti Icin Yuzey Koplayama Islemi
out = MAP.Z + Z;


% 3D Dağ Görselleştirme
surf(X, Y, Z);

colormap(parula);  % Doğal renkler
shading interp;    % Yüzeyi yumuşak yap
light;             % Işık kaynağı ekle
lighting phong;    % Daha iyi ışık efektleri
shading interp;
end

