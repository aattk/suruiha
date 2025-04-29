classdef pso3D
    properties
        pNumber =  30;   % Parçacık Sayısı
        w       = 0.7;  % Atalet katsayısı
        c1      = 1.5;  % Bireysel en iyi katsayı
        c2      = 1.5;  % Küresel en iyi katsayı
        xStep   = 5;    % Ucak X Eksen Hareket Limiti   Parcacik Hiz Limiti
        yStep   = 5;    % Ucak Y Eksen Hareket Limiti   Parcacik Hiz Limiti
        zStep   = 4;    % Ucak Z Eksen Hareket Limiti Parcacik Hiz Limiti


        startPos = [0, 0, 0];  % Başlangıç Konumu
        goalPos  = [0, 0, 0];  % Hedef Konumu


        MAP;              % Harita ve engel verisi
        pLocations;       % Parçacık Konumları
        pSpeeds;          % Parçacık Hızları
        pBestLocations;   % Kendi en iyi konumlar
        pBestScores;      % Kendi en iyi skorlar
        gBestLocation;    % Küresel en iyi konum
        gBestScore;       % Küresel en iyi skor

    end

    methods
        function this = pso3D(map,startPosition,goalPosition)
            % Harita verisini yükle
            this.MAP = map;
            this.startPos = startPosition;
            this.goalPos  = goalPosition;
            this.pBestScores = inf(1, this.pNumber);
            this.gBestScore = inf;

            % Parçacıkları başlat
            for i = 1:this.pNumber
                this.pLocations(i).x = rand * this.xStep + this.MAP.X_MIN_LIMIT;
                this.pLocations(i).y = rand * this.yStep + this.MAP.Y_MIN_LIMIT;
                this.pLocations(i).z = rand * this.zStep + this.MAP.Z_MIN_LIMIT;

                this.pSpeeds(i).x = 0;
                this.pSpeeds(i).y = 0;
                this.pSpeeds(i).z = 0;

                this.pBestLocations(i).x = this.pLocations(i).x;
                this.pBestLocations(i).y = this.pLocations(i).y;
                this.pBestLocations(i).z = this.pLocations(i).z;
            end
            this.gBestLocation = this.pLocations(1); % İlk küresel en iyi parçacık
        end

        function this = updatePartical(this,pNum)
            r1 = rand();
            r2 = rand();

            % Hız güncelleme formülü
            this.pSpeeds(pNum).x = this.w * this.pSpeeds(pNum).x ...
                + this.c1 * r1 * (this.pBestLocations(pNum).x - this.pLocations(pNum).x) ...
                + this.c2 * r2 * (this.gBestLocation.x - this.pLocations(pNum).x);

            this.pSpeeds(pNum).y = this.w * this.pSpeeds(pNum).y ...
                + this.c1 * r1 * (this.pBestLocations(pNum).y - this.pLocations(pNum).y) ...
                + this.c2 * r2 * (this.gBestLocation.y - this.pLocations(pNum).y);

            this.pSpeeds(pNum).z = this.w * this.pSpeeds(pNum).z ...
                + this.c1 * r1 * (this.pBestLocations(pNum).z - this.pLocations(pNum).z) ...
                + this.c2 * r2 * (this.gBestLocation.z - this.pLocations(pNum).z);

            % Parcacik hizlari limitlenir.
            this.pSpeeds(pNum).x = max(min(this.pSpeeds(pNum).x,this.xStep),-this.xStep);
            this.pSpeeds(pNum).y = max(min(this.pSpeeds(pNum).y,this.yStep),-this.yStep);
            this.pSpeeds(pNum).z = max(min(this.pSpeeds(pNum).z,this.zStep),-this.zStep);


            % Konumları güncelle
            this.pLocations(pNum).x = this.pLocations(pNum).x + this.pSpeeds(pNum).x;
            this.pLocations(pNum).y = this.pLocations(pNum).y + this.pSpeeds(pNum).y;
            this.pLocations(pNum).z = this.pLocations(pNum).z + this.pSpeeds(pNum).z;

            % Sınırları aşan parçacıkları düzelt
            this.pLocations(pNum).x = max(min(this.pLocations(pNum).x, this.MAP.X_MAX_LIMIT), this.MAP.X_MIN_LIMIT);
            this.pLocations(pNum).y = max(min(this.pLocations(pNum).y, this.MAP.Y_MAX_LIMIT), this.MAP.Y_MIN_LIMIT);
            this.pLocations(pNum).z = max(min(this.pLocations(pNum).z, this.MAP.Z_MAX_LIMIT), this.MAP.Z_MIN_LIMIT);

        end


        function this = calculatePosition(this)
            for i = 1:1:this.pNumber

                this = this.updatePartical(i);

                if this.checkCollision(this.pLocations(i).x, this.pLocations(i).y, this.pLocations(i).z)
                    fitness = inf; % Engel varsa cezalandır
                else
                    fitness = sqrt((this.pLocations(i).x - this.goalPos(1))^2 + (this.pLocations(i).y - this.goalPos(2))^2 + (this.pLocations(i).z - this.goalPos(3))^2);
                end
                % Kendi en iyi konumu güncelle
                if fitness < this.pBestScores(i)
                    this.pBestLocations(i) = this.pLocations(i);
                    this.pBestScores(i) = fitness;
                end

                % Küresel en iyi konumu güncelle
                if fitness < this.gBestScore
                    this.gBestLocation = this.pLocations(i);
                    this.gBestScore    = fitness;
                end

            end

            fprintf('GBEST:%f X:%f  Y:%f Z:%f \n', this.gBestScore, this.gBestLocation.x,this.gBestLocation.y,this.gBestLocation.z );

        end

        function collision = checkCollision(this, x, y, z)
            % (x, y) konumundaki yükseklik değeri
            mapHeight = interp2(this.MAP.X, this.MAP.Y, this.MAP.Z, x, y, 'linear', max(this.MAP.Z(:)));

            % Eğer parçacığın yüksekliği harita yüksekliğinden küçükse çakışma var
            collision = (z <= mapHeight);
        end
    end
end
