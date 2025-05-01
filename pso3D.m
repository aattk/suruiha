classdef pso3D < handle
    properties
        pNumber =  30;  % Parçacık Sayısı
        w       = 0.7;  % Atalet katsayısı
        c1      = 1.5;  % Bireysel en iyi katsayı
        c2      = 1.5;  % Küresel en iyi katsayı
        xStep   = 2;    % Ucak X Eksen Hareket Limiti   Parcacik Hiz Limiti
        yStep   = 2;    % Ucak Y Eksen Hareket Limiti   Parcacik Hiz Limiti
        zStep   = 0.1;  % Ucak Z Eksen Hareket Limiti Parcacik Hiz Limiti

        startPos = [0, 0, 0];  % Başlangıç Konumu
        goalPos  = [0, 0, 0];  % Hedef Konumu

        MAP;              % Harita ve engel verisi
        pLocations;       % Parçacık Konumları
        pSpeeds;          % Parçacık Hızları
        pBestLocations;   % Kendi en iyi konumlar
        pBestScores;      % Kendi en iyi skorlar
        gBestLocation;    % Küresel en iyi konum
        gBestScore;       % Küresel en iyi skor
        lgBestScore = 0;


        maxLenght   = 0;
        maxAltitude = 0;

        % ORANLAR
        rateChangeCounter = 0;
        rateChangeLimit   = 20;
        rLENGTH           = 1.0;
        rMinLENGTH        = 0.01;
        rMaxLENGTH        = 1.0;
        rALTITUDE         = 0.2;
        rMinALTITUDE      = 0.01;
        rMaxALTITUDE      = 1.0;
        STATUS            = 0;

    end

    methods
        function this = pso3D(map,startPosition,goalPosition)
            % Harita verisini yükle
            this.MAP = map;
            this.startPos = startPosition;
            this.goalPos  = goalPosition;
            this.pBestScores = inf(1, this.pNumber);
            this.gBestScore = inf;

            this.maxLenght   = sqrt((this.startPos(1) - this.goalPos(1))^2 + (this.startPos(2) - this.goalPos(2))^2 );
            this.maxAltitude = sqrt((this.startPos(3) - this.goalPos(3))^2 );

            % Parçacıkları başlat
            for i = 1:this.pNumber
                this.pLocations(i).x = rand() * this.xStep + this.startPos(1);
                this.pLocations(i).y = rand() * this.yStep + this.startPos(2);
                this.pLocations(i).z = rand() * this.zStep + this.startPos(3);

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
            this.pLocations(pNum).x = max(min(this.pLocations(pNum).x, this.MAP.X_MAX_LIMIT - this.xStep), this.MAP.X_MIN_LIMIT + this.xStep);
            this.pLocations(pNum).y = max(min(this.pLocations(pNum).y, this.MAP.Y_MAX_LIMIT - this.yStep), this.MAP.Y_MIN_LIMIT + this.xStep);
            this.pLocations(pNum).z = max(min(this.pLocations(pNum).z, this.MAP.Z_MAX_LIMIT - this.zStep), this.MAP.Z_MIN_LIMIT + this.xStep);
        end


        function this = calculatePosition(this)
            for i = 1:1:this.pNumber

                this = this.updatePartical(i);

                fitness = this.rLENGTH * cLength(this,i) + this.rALTITUDE * cAltitude(this,i) + 10 * cCollision(this,i);

                % fitness = constantFitnessStabilizer(this,i);

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

                [ this.lgBestScore, this.rLENGTH, this.rALTITUDE ] = this.updateFitnessRatio();

            end

            fprintf('GBEST:%f X:%f  Y:%f Z:%f rL:%f rA:%f\n', this.gBestScore, this.gBestLocation.x,this.gBestLocation.y,this.gBestLocation.z, this.rLENGTH ,this.rALTITUDE );

        end

        function out = constantFitnessStabilizer(this,i)
            if ( this.gBestScore == this.pBestScores(i) )
                out = inf;
            end
        end

        function out = cLength(this,i)
            out = sqrt((this.pLocations(i).x - this.goalPos(1))^2 + (this.pLocations(i).y - this.goalPos(2))^2 ) / this.maxLenght;
        end

        function out = cAltitude(this,i)
            out = sqrt((this.pLocations(i).z - this.goalPos(3))^2 ) / this.maxAltitude;
        end

        function out = cCollision(this,i)
            mapHeight = interp2(this.MAP.X, this.MAP.Y, this.MAP.Z, this.pLocations(i).x, this.pLocations(i).y, 'linear', max(this.MAP.Z(:)));
            out = (this.pLocations(i).z <= mapHeight);
        end

        function out = cArea(this,i)

        end

        function [lastbestScore,ratioLength,ratioAltitude] = updateFitnessRatio(this)
            if ( this.gBestScore == this.lgBestScore )
                this.rateChangeCounter = this.rateChangeCounter + 1;

                if ( this.rateChangeLimit <= this.rateChangeCounter )
                    if ( this.STATUS == 0 )
                        ratioLength   = min( (this.rLENGTH   + 0.01), this.rMaxLENGTH   );
                        ratioAltitude = max(this.rALTITUDE   - 0.01, this.rMinALTITUDE );
                    else
                        ratioLength   = max( (this.rLENGTH   - 0.01), this.rMinLENGTH   );
                        ratioAltitude = min(this.rALTITUDE   + 0.01, this.rMaxALTITUDE );
                    end

                    if ( this.rLENGTH == this.rMaxLENGTH )
                        this.STATUS = 1;
                    end
                    if ( this.rALTITUDE == this.rMaxLENGTH )
                        this.STATUS = 0;
                    end

                    this.rateChangeCounter = 0;
                    lastbestScore = this.lgBestScore;
                    return
                end

                ratioLength   = this.rLENGTH ;
                ratioAltitude = this.rALTITUDE;
                lastbestScore = this.lgBestScore;

            else
                this.rateChangeCounter = 0;
                ratioLength   = this.rLENGTH ;
                ratioAltitude = this.rALTITUDE;
                lastbestScore = this.gBestScore;
            end
        end

    end
end
