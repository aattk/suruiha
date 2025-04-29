function [] = highlandBuilder(MAP, X_INDEX,X_WIDTH, Y_INDEX,Y_WIDTH, HEIGHT )
% HIGHLANDBUILDER - GPU üzerinde 3D dağ yüzeyi oluşturur ve MAP.Z'ye ekler
% @alpaslantetik

% GPU'da meshgrid oluştur
x = gpuArray(MAP.X_MIN_LIMIT:MAP.STEP:MAP.X_MAX_LIMIT);
y = gpuArray(MAP.Y_MIN_LIMIT:MAP.STEP:MAP.Y_MAX_LIMIT);
[X, Y] = meshgrid(x, y);

% Gaussian dağ yüzeyi + düşük noise (GPU üzerinde)
Z = exp(-((X - X_INDEX) ./ X_WIDTH).^2 - ((Y - Y_INDEX) ./ Y_WIDTH).^2) * HEIGHT;
Z = Z + rand(size(X), 'gpuArray') * 0.01;

% Sonucu CPU belleğine aktar
Z = gather(Z);

% MAP'e ekle (CPU tarafında)
MAP.Z = MAP.Z + Z;

% 3D Dağ Görselleştirme
surf(X, Y, Z);

colormap(parula);  % Doğal renkler
shading interp;    % Yüzeyi yumuşak yap
light;             % Işık kaynağı ekle
lighting phong;    % Daha iyi ışık efektleri
shading interp;

end

