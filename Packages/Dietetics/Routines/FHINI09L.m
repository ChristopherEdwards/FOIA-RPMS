FHINI09L	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6608,20)
	;;=BAY PINES RECIPE 5/16/86
	;;^UTILITY(U,$J,112,6609,0)
	;;=COLONIAL CUCUMBERS^^servings^85
	;;^UTILITY(U,$J,112,6609,1)
	;;=.6^.12^3.5^14.2^95.2^^^18.6^.45^10.1^16^134^263^.21^.03^.06^^567^8.09^.02
	;;^UTILITY(U,$J,112,6609,2)
	;;=.02^.24^.2^.05^11.1^^^^^^^^^^^^.35
	;;^UTILITY(U,$J,112,6609,20)
	;;=BAY PINES STD RECIPE 5/16/86
	;;^UTILITY(U,$J,112,6610,0)
	;;=HOLLAND SALAD^^servings^86.5
	;;^UTILITY(U,$J,112,6610,1)
	;;=1.04^10.7^18.9^167^68.5^^^25.2^.64^13.4^35.3^267^227^.17^.08^.38^2.9^11166^6.8^.08
	;;^UTILITY(U,$J,112,6610,2)
	;;=.05^.58^.16^.18^10.6^.03^6.8^.5^7.8^1.16^1.7^7.3^^^^^.7
	;;^UTILITY(U,$J,112,6610,20)
	;;=BAY PINES STD RECIPE 5/16/86
	;;^UTILITY(U,$J,112,6613,0)
	;;=SHAKE N BAKE^^tbsp.^5
	;;^UTILITY(U,$J,112,6613,1)
	;;=10^12^62^600^^^^60^2^^40^60^3320^^^^^20^0^0
	;;^UTILITY(U,$J,112,6613,2)
	;;=0^0
	;;^UTILITY(U,$J,112,6613,20)
	;;=Bowes & Church, 13th ed.,c.1980. DOE:6/86  #516
	;;^UTILITY(U,$J,112,6614,0)
	;;=PUDDING, BANANA CREAM (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6614,1)
	;;=2.6^3.5^23.8^132^^^^70.4^0^^141^141^185^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6614,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6614,20)
	;;=General Foods Prod. Lit.  Sept. 1985. DOE:6/86 #516. Vit/min. calc from %RDA.
	;;^UTILITY(U,$J,112,6615,0)
	;;=PUDDING, BUTTER PECAN (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6615,1)
	;;=3.5^3.5^24.6^141^^^^105.6^0^^141^150^202^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6615,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6615,20)
	;;=General Foods Prod. Lit. Sept. 1985. DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6616,0)
	;;=PUDDING, BUTTERSCOTCH (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6616,1)
	;;=2.6^3.5^23.8^132^^^^70.4^0^^141^141^229^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6616,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6616,20)
	;;=General Foods Prod. Lit. Sept. 1985. DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6617,0)
	;;=PUDDING, CHOCOLATE (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6617,1)
	;;=3.5^3.5^22^123.2^^^^70.4^0^^141^141^185^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6617,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6617,20)
	;;=General Foods Prod. Lit. Sept. 1985. DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6618,0)
	;;=PUDDING, LEMON (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6618,1)
	;;=2.6^3.5^23.8^132^^^^70.4^0^^141^141^185^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6618,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6618,20)
	;;=General Foods Prod. Lit, Sept. 1985 DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6619,0)
	;;=PUDDING, PISTACHIO (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6619,1)
	;;=3.5^4.4^24.6^150^^^^105.6^0^^141^150^194^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6619,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6619,20)
	;;=General Foods Prod. Lit., Sept. 1985 DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6620,0)
	;;=PUDDING, VANILLA (JELLO)^^half-cups^113
	;;^UTILITY(U,$J,112,6620,1)
	;;=2.6^3.5^23.8^132^^^^70.4^0^^141^141^185^^^^^88^0^.02
	;;^UTILITY(U,$J,112,6620,2)
	;;=.12^0
	;;^UTILITY(U,$J,112,6620,20)
	;;=General Foods Prod. Lit., Sept. 1985. DOE: 6/86 #516. Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6621,0)
	;;=PUDDING POPS, CHOCOLATE (JELLO)^^pops^47.2
	;;^UTILITY(U,$J,112,6621,1)
	;;=4.2^4.2^27.6^170^^^^101.8^0^^68^191^170^^^^^0^0^0
	;;^UTILITY(U,$J,112,6621,2)
	;;=.18^0
	;;^UTILITY(U,$J,112,6621,20)
	;;=General Foods Prod Lit. Sept. 1985. DOE: 6/86. #516 Vit/min. calc. from %RDA.
	;;^UTILITY(U,$J,112,6622,0)
	;;=PUDDING POPS, VANILLA W/CHOC COAT (JELLO)^^pops^48.8
	;;^UTILITY(U,$J,112,6622,1)
	;;=4.1^16.4^30.8^267^^^^98.4^0^^66^164^103^^^^^0^0^0
	;;^UTILITY(U,$J,112,6622,2)
	;;=.17^0
	;;^UTILITY(U,$J,112,6622,20)
	;;=General Foods Prod Lit. Sept 1985.. DOE: 6/86 #516. Vit/min calc. from %RDA.
	;;^UTILITY(U,$J,112,6623,0)
	;;=PUDDING POPS, CHOC/VAN SWIRL (JELLO)^^pops^47.2
	;;^UTILITY(U,$J,112,6623,1)
	;;=4.2^4.2^27.6^170^^^^101.8^0^^68^170^138^^^^^0^0^0
	;;^UTILITY(U,$J,112,6623,2)
	;;=.18^0
	;;^UTILITY(U,$J,112,6623,20)
	;;=General Foods Prod Lit. Sept. 1985. DOE: 6/86 #516. Vit/min calc. from %RDA.
	;;^UTILITY(U,$J,112,6624,0)
	;;=PUDDING POPS, VANILLA (JELLO)^^pops^47.2
	;;^UTILITY(U,$J,112,6624,1)
	;;=4.2^4.2^27.6^148^^^^101.8^0^^68^138^106^^^^^0^0^0
	;;^UTILITY(U,$J,112,6624,2)
	;;=.18^0
	;;^UTILITY(U,$J,112,6624,20)
	;;=General Foods Prod Lit. Sept 1985. DOE: 6/86 #516. Vit/min calc. from %RDA.
	;;^UTILITY(U,$J,112,6625,0)
	;;=POSTUM^^cups^240
	;;^UTILITY(U,$J,112,6625,1)
	;;=0^0^1.3^5^^^^0^0^^6.7^40^0^^^^^0^0^0
	;;^UTILITY(U,$J,112,6625,2)
	;;=0^.27
	;;^UTILITY(U,$J,112,6625,20)
	;;=GENERAL FOODS PRODUCT LITERATURE.  SEPTEMBER, 1985.
