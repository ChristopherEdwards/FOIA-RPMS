FHINI08W	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,6004,1)
	;;=4.8^6.7^22.6^170^64.6^^^155^1.9^42^155^226^85^1.6^.21^.5^3.2^530^6.4^.16
	;;^UTILITY(U,$J,112,6004,2)
	;;=.18^2.1^1.06^.21^42^.64^2.5^.15^3.5^1.05^2.98^2.65
	;;^UTILITY(U,$J,112,6004,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE:073084 
	;;^UTILITY(U,$J,112,6005,0)
	;;=ISOCAL^^ml.^1
	;;^UTILITY(U,$J,112,6005,1)
	;;=3.4^4.4^13.3^106^84.3^^^63^1^21^53^132^53^1^.1^.3^4^264^15.8^.21
	;;^UTILITY(U,$J,112,6005,2)
	;;=.2^2.6^1.3^.3^21^.8^1.96^.27^1^.53^.85^2.23
	;;^UTILITY(U,$J,112,6005,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE: 073084 #516
	;;^UTILITY(U,$J,112,6006,0)
	;;=ISOCAL HCN^^ml.^1
	;;^UTILITY(U,$J,112,6006,1)
	;;=7.5^9.1^22.5^200^70.9^^^67^1.2^27^67^140^80^2^.2^.33^5^333^20^.25
	;;^UTILITY(U,$J,112,6006,2)
	;;=.29^3.3^1.67^.33^27^1^3.26^.43^2.7^1.81^2.91^3.69
	;;^UTILITY(U,$J,112,6006,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE: 073084 #516
	;;^UTILITY(U,$J,112,6007,0)
	;;=MODUCAL^^tbsp.^8
	;;^UTILITY(U,$J,112,6007,1)
	;;=0^0^95^380^5^^^0^0^0^0^5^70^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6007,2)
	;;=0^0^0^0^0^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6007,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE:073084 #516
	;;^UTILITY(U,$J,112,6008,0)
	;;=CASEC^^tbsp.^4.7
	;;^UTILITY(U,$J,112,6008,1)
	;;=88^2^0^370^5.5^^^1600^0^0^800^0^150^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6008,2)
	;;=0^0^0^0^0^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6008,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE:073084 #516
	;;^UTILITY(U,$J,112,6009,0)
	;;=MCT OIL^DS-043^tbsp.^15
	;;^UTILITY(U,$J,112,6009,1)
	;;=0^92.2^0^830^0^^^0^0^0^0^0^0^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6009,2)
	;;=0^0^0^0^0^0^0^0^0^0^0^0
	;;^UTILITY(U,$J,112,6009,20)
	;;=Sherwood Inc., 1987.
	;;^UTILITY(U,$J,112,6011,0)
	;;=LONALAC (RECONSTITUTED)^^cups^47
	;;^UTILITY(U,$J,112,6011,1)
	;;=27.1^28.2^37.8^510^79.7^^^899^^71.8^798^958^20^^^^^745^^.32
	;;^UTILITY(U,$J,112,6011,2)
	;;=1.38^.64
	;;^UTILITY(U,$J,112,6011,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE: 073084 #516
	;;^UTILITY(U,$J,112,6012,0)
	;;=SUSTACAL HC^^ml.^1
	;;^UTILITY(U,$J,112,6012,1)
	;;=6.1^5.8^19^150^77.5^^^85^1.5^34^85^148^85^1.3^.17^.25^2.5^423^7.6^.19
	;;^UTILITY(U,$J,112,6012,2)
	;;=.21^2.5^1.3^.25^51^.76^2.16^.13^1.5^.91^2.58^2.29
	;;^UTILITY(U,$J,112,6012,20)
	;;=Mead-Johnson Prod. Lit., Oct 82. DOE: 073084 #516
	;;^UTILITY(U,$J,112,6013,0)
	;;=MERITENE LIQUID^DS-016^ml.^1
	;;^UTILITY(U,$J,112,6013,1)
	;;=5.76^3.2^11.04^96^84^^^120^1.44^32^120^160^88^1.2^.16^.32^2.4^400^7.2^.18
	;;^UTILITY(U,$J,112,6013,2)
	;;=.21^1.6^.8^.24^32^.48^^^2^^^^120
	;;^UTILITY(U,$J,112,6013,20)
	;;=Doyle (Sandoz Nutrition) Prod. Lit. 1990.
	;;^UTILITY(U,$J,112,6014,0)
	;;=MERITENE POWDER (DRY)^^oz.^32.3
	;;^UTILITY(U,$J,112,6014,1)
	;;=29^.6^59^358^^^^860^13.6^194^830^1.17^490^8.95^1.45^3.09^22.8^2810^40.1^.96
	;;^UTILITY(U,$J,112,6014,2)
	;;=.86^14.8^5.25^1.23^310^1.85
	;;^UTILITY(U,$J,112,6014,20)
	;;=Doyle (Sandoz Nutrition) 1982. DOE: 073084 #516
	;;^UTILITY(U,$J,112,6015,0)
	;;=ISOTEIN HN (RECONSTITUTED)^DS-019^ml.^1
	;;^UTILITY(U,$J,112,6015,1)
	;;=6.8^3.4^15.8^119^85.4^^^57^1.03^22.6^57^107.5^62^.85^.11^.23^1.71^282^5.1^.13
	;;^UTILITY(U,$J,112,6015,2)
	;;=.15^1.13^.57^.17^22.6^.34^^^15.3^^^^85
	;;^UTILITY(U,$J,112,6015,20)
	;;=Doyle (Sandoz Nutrition), 1990.
	;;^UTILITY(U,$J,112,6017,0)
	;;=COMPLEAT MODIFIED^DS-015^ml.^1
	;;^UTILITY(U,$J,112,6017,1)
	;;=4.3^3.7^14^106^83^^^67^1.2^26.7^87^140^100^1.5^.13^.27^3^333^6^.15
	;;^UTILITY(U,$J,112,6017,2)
	;;=.17^2^.67^.2^26.7^.6^^^5.2^^^^100^^^^.42
	;;^UTILITY(U,$J,112,6017,4)
	;;=^^^^^^^^6.7^6.7
	;;^UTILITY(U,$J,112,6017,20)
	;;=Doyle (Sandoz Nutrition), 1990.
	;;^UTILITY(U,$J,112,6018,0)
	;;=ENSURE PLUS^DS-066^ml.^1
	;;^UTILITY(U,$J,112,6018,1)
	;;=5.49^5.33^20^150^76^^^69.5^1.25^27.9^69.5^191.6^104.1^1.562^.16^.345^3.12^347.5^20.8^20.8
	;;^UTILITY(U,$J,112,6018,2)
	;;=.237^2.77^1.39^2.79^55.83^.83^2.865^.066^2^.78^^2.93
	;;^UTILITY(U,$J,112,6018,3)
	;;=.06^.214^.269^.499^.389^.148^.027^.258^.225^.334^.214^.148^.17^.417^1.076^.115^.559^.279
	;;^UTILITY(U,$J,112,6018,4)
	;;=.003^.005^.02^.597^^.122^1.134^.03^5
	;;^UTILITY(U,$J,112,6018,20)
	;;=Ross Lab. Product Lit. Sept 1990.
	;;^UTILITY(U,$J,112,6019,0)
	;;=OSMOLITE HN^DS-069^ml.^1
	;;^UTILITY(U,$J,112,6019,1)
	;;=4.44^3.68^14.1^106^82.9^^^74.5^1.34^29.79^74.5^154.1^91.6^1.67^.15^.37^3.42^372^22.3^.17
	;;^UTILITY(U,$J,112,6019,2)
	;;=.19^2.23^1.11^.23^45^.72^1.171^.031^2^1.77^^1.2
	;;^UTILITY(U,$J,112,6019,3)
	;;=.049^.173^.217^.404^.315^.119^.022^.208^.182^.27^.173^.12^.138^.337^.87^.093^.542^.226
	;;^UTILITY(U,$J,112,6019,4)
	;;=.905^.066^.028^.258^^.052^.52^0^5.41