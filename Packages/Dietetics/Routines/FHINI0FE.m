FHINI0FE	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9474,1)
	;;=0^0^28.571^107.143^^^^21.429^.714^^^357.143^1142.857^^^^^^14.286^.071
	;;^UTILITY(U,$J,112,9474,2)
	;;=.071^1.429^^^^^^^0^^^^121.429^^^^0
	;;^UTILITY(U,$J,112,9474,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9475,0)
	;;=SAUCE,CHILI,HEINZ^BC-02748^tbsp.^15
	;;^UTILITY(U,$J,112,9475,1)
	;;=1.333^0^25.333^113.333^^^^^^^^^1273.333
	;;^UTILITY(U,$J,112,9475,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9476,0)
	;;=SAUCE,CLAM,RED,BUITONI^BC-02749^5-oz.^142
	;;^UTILITY(U,$J,112,9476,1)
	;;=5.634^4.225^19.718^133.803^^^^^^^^267.606^394.366
	;;^UTILITY(U,$J,112,9476,2)
	;;=^^^^^^^^14.085^.704^1.408^2.113
	;;^UTILITY(U,$J,112,9476,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9477,0)
	;;=SAUCE,CLAM,RED,CONTADINA FRESH^BC-02750^6-oz.^170
	;;^UTILITY(U,$J,112,9477,1)
	;;=4.706^13.529^7.647^170.588^^^^71.176^1.894^^^123.529^470.588^^^^^577.059^.588^.029
	;;^UTILITY(U,$J,112,9477,2)
	;;=.106^.647^^^^^^^55.294
	;;^UTILITY(U,$J,112,9477,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9478,0)
	;;=SAUCE,ENCHILADA,GEBARDT^BC-02751^3-tbsp.^43
	;;^UTILITY(U,$J,112,9478,1)
	;;=0^2.326^6.977^58.14^^^^209.302^1.395^^^46.512^395.349^^^^^^2.326^.07
	;;^UTILITY(U,$J,112,9478,2)
	;;=.14^1.628^^^^^^^0^1.628^^.233^104.651^^^^0
	;;^UTILITY(U,$J,112,9478,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9479,0)
	;;=SAUCE,ENCHILADA,HOT,ROSARITA^BC-02752^3-tbsp.^43
	;;^UTILITY(U,$J,112,9479,1)
	;;=0^0^4.651^34.884^^^^16.279^1.163^^^174.419^348.837^^^^^^11.628^.047
	;;^UTILITY(U,$J,112,9479,2)
	;;=.047^.698^^^^^^^0^^^^186.047^^^^0
	;;^UTILITY(U,$J,112,9479,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9480,0)
	;;=SAUCE,FETTUCINI,STOUFFERS^BC-02753^2-oz.^57
	;;^UTILITY(U,$J,112,9480,1)
	;;=5.439^22.982^4.561^247.368^65.088^^^159.649^.105^^^110.526^519.298^^^^^110.526^0^.035
	;;^UTILITY(U,$J,112,9480,2)
	;;=.193^0^^^^^^^64.912
	;;^UTILITY(U,$J,112,9480,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9481,0)
	;;=SAUCE,FORESTIERA,CONTADINA FRESH^BC-02754^7.5-oz.^213
	;;^UTILITY(U,$J,112,9481,1)
	;;=2.817^4.225^7.042^79.812^^^^51.643^.967^^^399.061^389.671^^^^^831.925^5.164^.15
	;;^UTILITY(U,$J,112,9481,2)
	;;=15.493^1.455^^^^^^^7.042
	;;^UTILITY(U,$J,112,9481,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9482,0)
	;;=SAUCE,GRILLING,HEINZ 57^BC-02755^tbsp.^15
	;;^UTILITY(U,$J,112,9482,1)
	;;=2.667^1.333^18^100^^^^^^^^^1766.667
	;;^UTILITY(U,$J,112,9482,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9483,0)
	;;=SAUCE,GRILLING,STOUFFERS^BC-02756^2-oz.^57
	;;^UTILITY(U,$J,112,9483,1)
	;;=1.053^14.035^4.912^150.877^78.947^^^15.789^.193^^^15.789^380.702^^^^^50.877^0^.018
	;;^UTILITY(U,$J,112,9483,2)
	;;=.053^0^^^^^^^80.702
	;;^UTILITY(U,$J,112,9483,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9484,0)
	;;=SAUCE,HOT DOG,CHILI,GEBHARDT^BC-02757^2-tbsp.^26
	;;^UTILITY(U,$J,112,9484,1)
	;;=3.846^3.846^15.385^115.385^^^^30.769^.769^^^307.692^692.308^^^^^^^.077
	;;^UTILITY(U,$J,112,9484,2)
	;;=.077^.385^^^^^^^11.538^1.538^^.385^7.692^^^^0
	;;^UTILITY(U,$J,112,9484,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9485,0)
	;;=SAUCE,HOT (CAYENNE PEPPER),GEBHARDT^BC-02758^1/2-tsp.^2
	;;^UTILITY(U,$J,112,9485,1)
	;;=0^0^0^0^^^^^^^^100^2750
	;;^UTILITY(U,$J,112,9485,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9485,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9486,0)
	;;=SAUCE,HUNTER,MIX,KNORR^BC-02759^1/4-cup^60
	;;^UTILITY(U,$J,112,9486,1)
	;;=1.5^1^61.667^41.667^^^^^^^^^566.667
	;;^UTILITY(U,$J,112,9486,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9487,0)
	;;=SAUCE,LYONNAISE,MIX,KNORR^BC-02760^1/4-cup^60
	;;^UTILITY(U,$J,112,9487,1)
	;;=1^.667^5.667^33.333^^^^^^^^^600
	;;^UTILITY(U,$J,112,9487,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9488,0)
	;;=SAUCE,MADEIRA (TOMATO BASED),PRAGO^BC-02761^4-oz.^113
	;;^UTILITY(U,$J,112,9488,1)
	;;=1.593^3.894^9.823^80.531^^^^28.319^.708^^^384.956^551.327^^^^^750.442^15.929^.071
	;;^UTILITY(U,$J,112,9488,2)
	;;=.044^1.15
	;;^UTILITY(U,$J,112,9488,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9489,0)
	;;=SAUCE,MANDARIN ORANGE,LACHOY^BC-02762^tbsp.^14
	;;^UTILITY(U,$J,112,9489,1)
	;;=0^0^42.857^178.571^^^^^^^^71.429^285.714
