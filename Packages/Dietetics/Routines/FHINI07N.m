FHINI07N	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,2654,2)
	;;=.092^.499^.085^.042^14.7^0^.041^.066^0^.047^.008^.108^13^.53^^^1.8
	;;^UTILITY(U,$J,112,2654,3)
	;;=.019^.079^.066^.111^.087^.022^.018^.066^.042^.089^.073^.034^.083^.253^.186^.065^.067^.099
	;;^UTILITY(U,$J,112,2654,4)
	;;=^^0^.039^0^.007^.008
	;;^UTILITY(U,$J,112,2654,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2655,0)
	;;=BEANS, WHITE, CANNED^16-051^cups^262^100^N
	;;^UTILITY(U,$J,112,2655,1)
	;;=7.26^.29^21.94^117^70.1^^^73^2.99^51^91^454^5^1.12^.232^.515^^0^0^.096
	;;^UTILITY(U,$J,112,2655,2)
	;;=.037^.113^.185^.075^65.4^0^.067^.056^0^.074^.025^.123^0^.42^^^5.5
	;;^UTILITY(U,$J,112,2655,3)
	;;=.086^.305^.32^.579^.498^.109^.079^.392^.204^.38^.449^.202^.304^.878^1.106^.283^.308^.395
	;;^UTILITY(U,$J,112,2655,4)
	;;=^^0^.069^^.004^.025
	;;^UTILITY(U,$J,112,2655,20)
	;;=USDA Std. Reference, Release 10;HCF Nutrition Research Foundation, Inc, 1990
	;;^UTILITY(U,$J,112,2656,0)
	;;=BEANS, YELLOW, BOILED, WO/SALT^16-048^cups^176^100^N
	;;^UTILITY(U,$J,112,2656,1)
	;;=9.16^1.08^25.27^144^62.98^^^62^2.48^74^183^325^5^1.06^.186^.455^^2^1.8^.187
	;;^UTILITY(U,$J,112,2656,2)
	;;=.103^.708^.229^.129^80.9^0^.253^.212^0^.279^.094^.466^0^1.5
	;;^UTILITY(U,$J,112,2656,3)
	;;=.108^.386^.405^.732^.629^.138^.1^.496^.258^.479^.567^.255^.384^1.108^1.397^.358^.388^.498
	;;^UTILITY(U,$J,112,2656,4)
	;;=^^.001^.262^^.017^.094
	;;^UTILITY(U,$J,112,2656,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2657,0)
	;;=BEAR, SIMMERED^17-147^oz.^28.3^100^N
	;;^UTILITY(U,$J,112,2657,1)
	;;=32.42^13.39^0^259^53.55^^^5^10.73^^170^^^^^^^0^0^.1
	;;^UTILITY(U,$J,112,2657,2)
	;;=.82^3.35^^^^^^^^^^^0^1.13^^^0
	;;^UTILITY(U,$J,112,2657,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2658,0)
	;;=BEAVER, ROASTED^17-151^oz.^28.3^100^N
	;;^UTILITY(U,$J,112,2658,1)
	;;=34.85^6.96^0^212^57.92^^^22^10^29^292^403^59^^^^^0^3^.05
	;;^UTILITY(U,$J,112,2658,2)
	;;=.31^2.2^.93^.43^11^8.3^^^121^^^^0^1.45^^^0
	;;^UTILITY(U,$J,112,2658,3)
	;;=^1.327^1.489^2.749^3.24^.792^^1.417^1.087^1.422^2.141^1.372^1.617^2.772^4.98^1.322^1.249^1.154
	;;^UTILITY(U,$J,112,2658,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2659,0)
	;;=BEEF, BRAIN, SIMMERED^13-320^oz.^28.3^86^N
	;;^UTILITY(U,$J,112,2659,1)
	;;=11.07^12.53^0^160^73.32^^^9^2.21^14^352^240^120^1.25^.24^.035^^0^1^.08
	;;^UTILITY(U,$J,112,2659,2)
	;;=.17^2.18^.57^.24^7^8.6^.03^0^2054^2.92^2.5^1.44^0^1.27^^^0
	;;^UTILITY(U,$J,112,2659,3)
	;;=.09^.526^.429^.831^.662^.23^.197^.56^.393^.544^.604^.282^.613^.992^1.351^.522^.459^.641
	;;^UTILITY(U,$J,112,2659,4)
	;;=0^0^.06^1.51^.1^1.27^2^.3
	;;^UTILITY(U,$J,112,2659,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2660,0)
	;;=BEEF, GROUND, EXTRA LEAN, PAN-FRIED, MEDIUM^13-300^oz.^28.3^75^N
	;;^UTILITY(U,$J,112,2660,1)
	;;=24.96^16.42^0^255^57.59^^^7^2.36^21^160^312^70^5.42^.087^.016^^0^0^.06
	;;^UTILITY(U,$J,112,2660,2)
	;;=.26^4.71^.25^.27^9^2^.45^.07^81^6.45^7.19^.61^0^1.03^^^0
	;;^UTILITY(U,$J,112,2660,3)
	;;=.28^1.09^1.122^1.973^2.077^.639^.28^.975^.839^1.214^1.578^.855^1.506^2.281^3.75^1.362^1.102^.955
	;;^UTILITY(U,$J,112,2660,4)
	;;=.02^.02^.47^3.72^.61^1.94^6.28^.07
	;;^UTILITY(U,$J,112,2660,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2661,0)
	;;=BEEF, GROUND, EXTRA LEAN, PAN-FRIED, WELL-DONE^13-301^oz.^28.3^65^N
	;;^UTILITY(U,$J,112,2661,1)
	;;=27.99^15.95^0^263^53.93^^^8^2.73^24^185^360^81^6.27^.101^.018^^0^0^.07
	;;^UTILITY(U,$J,112,2661,2)
	;;=.3^5.44^.29^.31^10^2.32^.44^.07^93^6.27^6.98^.6^0^1.19^^^0
	;;^UTILITY(U,$J,112,2661,3)
	;;=.313^1.222^1.258^2.212^2.329^.716^.313^1.093^.94^1.361^1.769^.958^1.688^2.557^4.205^1.527^1.236^1.07
	;;^UTILITY(U,$J,112,2661,4)
	;;=.02^.02^.45^3.61^.6^1.88^6.1^.06
	;;^UTILITY(U,$J,112,2661,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2662,0)
	;;=BEEF, SUET, RAW^13-335^oz.^28.3^100^N
	;;^UTILITY(U,$J,112,2662,1)
	;;=1.5^94^0^854^4^^^2^.17^1^15^16^7^.22^.007^.001^^0^0^.007
	;;^UTILITY(U,$J,112,2662,2)
	;;=.013^.259^.025^.03^1^.27^2.15^.86^68^52.3^31.52^3.17^0^.1^^^0
	;;^UTILITY(U,$J,112,2662,3)
	;;=.017^.041^.029^.084^.073^.019^.017^.051^.03^.054^.095^.021^.137^.105^.195^.252^.066^.059
	;;^UTILITY(U,$J,112,2662,4)
	;;=0^.07^2.8^22.57^2.18^24.68^28.86^0
	;;^UTILITY(U,$J,112,2662,20)
	;;=USDA Std. Reference, Release 10
	;;^UTILITY(U,$J,112,2663,0)
	;;=BEEF, TRIPE, PICKLED^2317-0^oz.^28.3^100^N
	;;^UTILITY(U,$J,112,2663,1)
	;;=11.8^1.3^0^62^86.5^^^127^1.6^^86^19^46^^^^^0^0^0
	;;^UTILITY(U,$J,112,2663,2)
	;;=.15^1.6^^^^^0^^68^.5^^^^.3
	;;^UTILITY(U,$J,112,2663,4)
	;;=^^^^^^.3