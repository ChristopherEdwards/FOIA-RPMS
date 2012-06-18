FHINI0DO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,8633,2)
	;;=.453^4.922^.328^.039^11.719^.258^^^113.281^.781^1.563^1.563
	;;^UTILITY(U,$J,112,8633,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8634,0)
	;;=PASTA,LASAGNE,MUELLER'S (DRY)^BC-01907^2-oz.^57
	;;^UTILITY(U,$J,112,8634,1)
	;;=14.035^2.281^73.333^368.421^9.123^^^^3.158^^^^7.018^^^^^^^.877
	;;^UTILITY(U,$J,112,8634,2)
	;;=.351^5.263^^^^^^^0
	;;^UTILITY(U,$J,112,8634,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8635,0)
	;;=PASTA,NOODLES, CHOW MEIN, NARROW/WIDE,LACHOY^BC-01908^1/2-cup^28
	;;^UTILITY(U,$J,112,8635,1)
	;;=10.714^28.571^57.143^535.714^^^^21.429^6.429^^^125^946.429^^^^^^^.857
	;;^UTILITY(U,$J,112,8635,2)
	;;=.5^7.143^^^^^^^0^4.286^^17.857^^^^^0
	;;^UTILITY(U,$J,112,8635,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8636,0)
	;;=PASTA,NOODLES,EGG,GOLDEN GRAIN (DRY)^BC-01909^2-oz.^57
	;;^UTILITY(U,$J,112,8636,1)
	;;=14.386^3.86^68.947^368.421^11.053^^^36.842^4.754^57.895^217.544^187.719^17.544^2.228^1.211^.754^^0^0^1.07
	;;^UTILITY(U,$J,112,8636,2)
	;;=.526^7.895^.842^.14^47.368^.351^^^114.035^1.404^1.228^1.579^^^^^3.158
	;;^UTILITY(U,$J,112,8636,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8637,0)
	;;=PASTA,NOODLES,EGG,MUELLER'S (DRY)^BC-01910^2-oz.^57
	;;^UTILITY(U,$J,112,8637,1)
	;;=14.211^4.386^69.649^385.965^10.351^^^35.088^3.158^^^^14.035^^^^^^^.877
	;;^UTILITY(U,$J,112,8637,2)
	;;=.351^5.263^^^^^^^96.491
	;;^UTILITY(U,$J,112,8637,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8638,0)
	;;=PASTA,NOODLES,RICE,LACHOY^BC-01911^1/2-cup^120
	;;^UTILITY(U,$J,112,8638,1)
	;;=1.667^4.167^17.5^108.333^^^^3.333^.583^^^29.167^350^^^^^^^.05
	;;^UTILITY(U,$J,112,8638,2)
	;;=.025^1^^^^^^^0^^^^^^^^0
	;;^UTILITY(U,$J,112,8638,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8639,0)
	;;=PASTA,SPAGHETTI,MUELLER'S (DRY)^BC-01912^2-oz.^57
	;;^UTILITY(U,$J,112,8639,1)
	;;=13.333^1.93^73.86^368.421^9.474^^^14.035^3.158^^^^5.263^^^^^^^.877
	;;^UTILITY(U,$J,112,8639,2)
	;;=.351^5.263^^^^^^^0
	;;^UTILITY(U,$J,112,8639,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8640,0)
	;;=PASTA,SUPER SHAPES,MUELLER'S (DRY)^BC-01913^2-oz.^57
	;;^UTILITY(U,$J,112,8640,1)
	;;=13.333^1.93^73.86^368.421^9.474^^^14.035^3.158^^^^5.263^^^^^^^.877
	;;^UTILITY(U,$J,112,8640,2)
	;;=.351^5.263^^^^^^^0
	;;^UTILITY(U,$J,112,8640,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8641,0)
	;;=PASTA,TWISTS,TRI COLOR,MUELLER'S (DRY)^BC-01914^2-oz.^57
	;;^UTILITY(U,$J,112,8641,1)
	;;=13.86^2.105^72.456^368.421^10^^^14.035^3.158^^^^17.544^^^^^^^.877
	;;^UTILITY(U,$J,112,8641,2)
	;;=.351^5.263^^^^^^^0
	;;^UTILITY(U,$J,112,8641,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8642,0)
	;;=CRUST,PASTRY POCKETS,PILLSBURY^BC-01915^pocket^67
	;;^UTILITY(U,$J,112,8642,1)
	;;=6.269^19.701^37.015^344.776^32.836^^^16.418^2.224^^382.09^225.373^820.896^^^^^0^0^.284
	;;^UTILITY(U,$J,112,8642,2)
	;;=.194^2.537
	;;^UTILITY(U,$J,112,8642,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8643,0)
	;;=CRUST,PIE,CHOC,KEEBLER READY^BC-01916^1/8-crust^20
	;;^UTILITY(U,$J,112,8643,1)
	;;=6^21^67^480^^^^25^3.1^^^310^535^^^^^^^.3
	;;^UTILITY(U,$J,112,8643,2)
	;;=.8^3^^^^^^^0^3^^1
	;;^UTILITY(U,$J,112,8643,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8644,0)
	;;=CRUST,PIE,GRAHAM,KEEBLER READY^BC-01917^1/8-crust^20
	;;^UTILITY(U,$J,112,8644,1)
	;;=5^24^66^500^^^^10^2.5^^^135^620^^^^^^^.1
	;;^UTILITY(U,$J,112,8644,2)
	;;=.4^2.5^^^^^^^0^4^^1
	;;^UTILITY(U,$J,112,8644,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8645,0)
	;;=CRUST,PIE,MRS. SMITH'S^BC-01918^1/8-crust^26
	;;^UTILITY(U,$J,112,8645,1)
	;;=7.692^26.923^46.154^461.538^^^^^^^^96.154^615.385
	;;^UTILITY(U,$J,112,8645,2)
	;;=^^^^^^^^0^7.692^15.385^3.846
	;;^UTILITY(U,$J,112,8645,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8646,0)
	;;=CRUST,PIE,PILLSBURY ALL READY^BC-01919^1/8-crust^53
	;;^UTILITY(U,$J,112,8646,1)
	;;=3.208^27.547^44.906^445.283^22.83^^^7.547^.472^^32.075^58.491^396.226^^^^^58.491^0^0
	;;^UTILITY(U,$J,112,8646,2)
	;;=0^.189
	;;^UTILITY(U,$J,112,8646,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,8647,0)
	;;=CRUST,PIZZA,PILLSBURY ALL READY^BC-01920^1/8-crust^35
	;;^UTILITY(U,$J,112,8647,1)
	;;=9.143^3.143^45.429^251.429^41.429^^^17.143^3^^57.143^60^491.429^^^^^0^0^.371
