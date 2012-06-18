FHINI0FF	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,9489,2)
	;;=^^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,9489,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9490,0)
	;;=SAUCE,MANWICH,HUNT-WESSON,CHILI FIXINS^BC-02763^5.3-oz.^150
	;;^UTILITY(U,$J,112,9490,1)
	;;=4^0^13.333^73.333^^^^40^1.933^^^400^600^^^^^^16^.127
	;;^UTILITY(U,$J,112,9490,2)
	;;=.087^1.133^^^^^^^0^^^^47.333
	;;^UTILITY(U,$J,112,9490,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9491,0)
	;;=SAUCE,MANWICH,HUNT-WESSON,EXTRA THICK & CHUNKY^BC-02764^2.5-oz.^71
	;;^UTILITY(U,$J,112,9491,1)
	;;=1.408^0^21.127^84.507^^^^18.31^.563^^^394.366^901.408^^^^^^5.634^.099
	;;^UTILITY(U,$J,112,9491,2)
	;;=.07^1.408^^^^^^^0^^^^211.268^^^^2.817
	;;^UTILITY(U,$J,112,9491,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9492,0)
	;;=SAUCE,MANWICH,HUNT-WESSON,MEXICAN^BC-02765^2.5-oz.^71
	;;^UTILITY(U,$J,112,9492,1)
	;;=1.408^1.408^12.676^63.38^^^^18.31^2.535^^^295.775^647.887^^^^^^2.817^.042
	;;^UTILITY(U,$J,112,9492,2)
	;;=.07^1.69^^^^^^^0^^^^281.69^^^^1.408
	;;^UTILITY(U,$J,112,9492,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9493,0)
	;;=SAUCE,MANWICH,HUNT-WESSON,SLOPPY JOE^BC-02766^2.5-oz.^71
	;;^UTILITY(U,$J,112,9493,1)
	;;=1.408^0^14.085^56.338^^^^12.676^1.268^^^309.859^549.296^^^^^^7.042^.07
	;;^UTILITY(U,$J,112,9493,2)
	;;=.099^1.127^^^^^^^0^^^^211.268^^^^1.408
	;;^UTILITY(U,$J,112,9493,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9494,0)
	;;=SAUCE,MARINARA,BUITONI^BC-02767^4-floz.^113
	;;^UTILITY(U,$J,112,9494,1)
	;;=.885^2.655^9.735^61.947^^^^^^^^327.434^504.425
	;;^UTILITY(U,$J,112,9494,2)
	;;=^^^^^^^^0^.442^.442^1.77
	;;^UTILITY(U,$J,112,9494,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9495,0)
	;;=SAUCE,MARINARA,CONTADINA FRESH^BC-02768^7.5-oz.^213
	;;^UTILITY(U,$J,112,9495,1)
	;;=1.878^1.878^5.634^46.948^^^^34.272^1.211^^^380.282^328.638^^^^^969.953^9.39^.103
	;;^UTILITY(U,$J,112,9495,2)
	;;=.211^1.033^^^^^^^0
	;;^UTILITY(U,$J,112,9495,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9496,0)
	;;=SAUCE,MARINARA,PREGO^BC-02769^4-oz.^113
	;;^UTILITY(U,$J,112,9496,1)
	;;=1.593^4.513^9.027^83.186^^^^31.858^.796^^^384.956^547.788^^^^^861.947^16.814^.062
	;;^UTILITY(U,$J,112,9496,2)
	;;=.044^1.239
	;;^UTILITY(U,$J,112,9496,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9497,0)
	;;=SAUCE,MARINARA,STOUFFERS^BC-02770^2-oz.^57
	;;^UTILITY(U,$J,112,9497,1)
	;;=1.404^3.684^7.018^66.667^85.965^^^35.088^.702^^^259.649^400^^^^^470.175^50.877^.035
	;;^UTILITY(U,$J,112,9497,2)
	;;=.035^.702
	;;^UTILITY(U,$J,112,9497,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9498,0)
	;;=SAUCE,MUSTARD,MILD,HEINZ^BC-02771^tsp.^5
	;;^UTILITY(U,$J,112,9498,1)
	;;=6^4^10^100^^^^80^2^^^^1420
	;;^UTILITY(U,$J,112,9498,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9499,0)
	;;=SAUCE,NAPOLI,MIX KNORR^BC-02772^1/2-cup^120
	;;^UTILITY(U,$J,112,9499,1)
	;;=2.5^2.5^14.167^83.333^^^^^^^^^800
	;;^UTILITY(U,$J,112,9499,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9500,0)
	;;=SAUCE,NEWBURG, STOUFFERS^BC-02773^2-oz.^57
	;;^UTILITY(U,$J,112,9500,1)
	;;=2.632^14.035^5.263^157.895^77.018^^^80.702^.105^^^119.298^370.175^^^^^89.474^0^.035
	;;^UTILITY(U,$J,112,9500,2)
	;;=.14^0^^^^^^^38.596
	;;^UTILITY(U,$J,112,9500,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9501,0)
	;;=SAUCE,PEPPER,MIX,KNORR^BC-02774^1/4-cup^60
	;;^UTILITY(U,$J,112,9501,1)
	;;=1.167^1^5^33.333^^^^^^^^^633.333
	;;^UTILITY(U,$J,112,9501,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9502,0)
	;;=SAUCE,PESTO,CONTADINA FRESH^BC-02775^2.3-oz.^65
	;;^UTILITY(U,$J,112,9502,1)
	;;=9.231^52.308^9.231^538.462^^^^307.692^1.031^^^353.846^646.154^^^^^338.462^0^.123
	;;^UTILITY(U,$J,112,9502,2)
	;;=.262^.462^^^^^^^15.385
	;;^UTILITY(U,$J,112,9502,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9503,0)
	;;=SAUCE,PESTO,STOUFFERS^BC-02776^2-oz.^57
	;;^UTILITY(U,$J,112,9503,1)
	;;=12.982^22.982^3.86^275.439^58.07^^^289.474^1.105^^^229.825^429.825^^^^^1100^5.263^.053
	;;^UTILITY(U,$J,112,9503,2)
	;;=.298^.526^^^^^^^24.561
	;;^UTILITY(U,$J,112,9503,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,9504,0)
	;;=SAUCE,PICANTE,HOT CHUNKY,ROSARITA^BC-02777^3-tbsp.^57
	;;^UTILITY(U,$J,112,9504,1)
	;;=0^0^7.018^31.579^^^^24.561^1.053^^^157.895^903.509^^^^^^17.544^.07
