FHINI0GY	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,10245,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10246,0)
	;;=PICKLES,DILL,POLISH STYLE,HEINZ^BC-03519^oz.^28
	;;^UTILITY(U,$J,112,10246,1)
	;;=0^0^3.571^14.286^^^^^^^^^1017.857
	;;^UTILITY(U,$J,112,10246,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10247,0)
	;;=PICKLES,DILL,SWEET HALVES,DEL MONTE^BC-03520^oz.^28
	;;^UTILITY(U,$J,112,10247,1)
	;;=.357^.357^28.571^103.571^68.571^^^3.571^.607^3.571^10.714^28.571^1535.714^.107^.1^^^257.143^0^.036
	;;^UTILITY(U,$J,112,10247,2)
	;;=.036^.357
	;;^UTILITY(U,$J,112,10247,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10248,0)
	;;=PICKLES,SOUR,WHOLE,DEL MONTE^BC-03521^oz.^28
	;;^UTILITY(U,$J,112,10248,1)
	;;=.357^.357^2.143^10.714^95.357^^^3.571^.393^3.571^14.286^21.429^1221.429^.036^.082^^^146.429^0
	;;^UTILITY(U,$J,112,10248,2)
	;;=0
	;;^UTILITY(U,$J,112,10248,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10249,0)
	;;=PICKLES,SWEET,CLAUSSEN^BC-03522^oz.^28
	;;^UTILITY(U,$J,112,10249,1)
	;;=.357^1.429^41.429^178.571^55.357^^^46.429^.357^3.571^10.714^121.429^596.429^.179^.071
	;;^UTILITY(U,$J,112,10249,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10250,0)
	;;=PICKLES,SWEET MIXED,DEL MONTE^BC-03523^oz.^28
	;;^UTILITY(U,$J,112,10250,1)
	;;=.357^.357^36.071^132.143^61.786^^^3.571^.821^3.571^10.714^21.429^1232.143^.071^.093^^^153.571^0^0
	;;^UTILITY(U,$J,112,10250,2)
	;;=.036^.357
	;;^UTILITY(U,$J,112,10250,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,10251,0)
	;;=TAPIOCA,MINUTE^BC-03524^tbsp.^9
	;;^UTILITY(U,$J,112,10251,1)
	;;=1.111^0^86.667^355.556^12.222^^^11.111^.444^0^11.111^22.222^0^^.056^^^0^0^0
	;;^UTILITY(U,$J,112,10251,2)
	;;=0^0^0^0^0^0^^^0^0^^0
	;;^UTILITY(U,$J,112,10251,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
