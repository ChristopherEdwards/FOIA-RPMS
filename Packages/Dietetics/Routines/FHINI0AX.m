FHINI0AX	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQR(112)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,112,7263,0)
	;;=PUDDINGS,CHOC SUNDAE,RTE,SWISS MISS^BC-00536^4-oz.^113
	;;^UTILITY(U,$J,112,7263,1)
	;;=1.77^6.195^31.858^194.69^^^^68.142^1.239^^^194.69^123.894^^^^^^^.018
	;;^UTILITY(U,$J,112,7263,2)
	;;=.08^.088^^^^^^^.885^1.504^^.885
	;;^UTILITY(U,$J,112,7263,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7264,0)
	;;=PUDDINGS,CHOC TAPIOCA (REG MIX),JELL-O AMERICANA^BC-00537^1/2-cup^147
	;;^UTILITY(U,$J,112,7264,1)
	;;=3.197^3.129^18.776^114.966^73.81^^^102.041^.333^21.088^97.279^199.32^114.286^.456^.084^^^106.122^.68^.034
	;;^UTILITY(U,$J,112,7264,2)
	;;=.143^.136^.265^.041^4.082^.299^^^11.565^1.973^^.136
	;;^UTILITY(U,$J,112,7264,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7265,0)
	;;=PUDDINGS,CHOC-VANILLA,RTE,JELL-O^BC-00538^4-oz.^113
	;;^UTILITY(U,$J,112,7265,1)
	;;=2.655^1.77^18.584^92.035^^^^76.991^.177^13.274^66.372^143.363^102.655^^.044^^^182.301^.885^.027
	;;^UTILITY(U,$J,112,7265,2)
	;;=.106^.088^.204^.027^3.54^.265^^^4.425
	;;^UTILITY(U,$J,112,7265,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7266,0)
	;;=PUDDINGS,CHOC-VANILLE SWIRL,RTE,JELL-O^BC-00539^4-oz.^113
	;;^UTILITY(U,$J,112,7266,1)
	;;=2.655^5.31^24.779^154.867^^^^93.805^.354^16.814^88.496^203.54^110.619^^.08^^^149.558^.885^.027
	;;^UTILITY(U,$J,112,7266,2)
	;;=.106^.088^.248^.035^3.54^.265^^^1.77
	;;^UTILITY(U,$J,112,7266,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7267,0)
	;;=PUDDINGS,CHOC-VANILLA SWIRL,RTE,JELL-O^BC-00540^5.5-oz.^156
	;;^UTILITY(U,$J,112,7267,1)
	;;=2.564^5.128^25^153.846^^^^92.949^.321^17.308^87.821^202.564^110.897^.641^.077^^^159.615^.641^.026
	;;^UTILITY(U,$J,112,7267,2)
	;;=.109^.128^.244^.032^3.205^.256^^^1.282
	;;^UTILITY(U,$J,112,7267,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7268,0)
	;;=PUDDINGS,COCONUT CREAM (INST MIX),JELL-O^BC-00541^1/2-cup^147
	;;^UTILITY(U,$J,112,7268,1)
	;;=2.925^4.354^18.163^121.088^73.333^^^100^.15^12.925^191.156^138.095^219.048^.68^.026^^^104.762^.68^.034
	;;^UTILITY(U,$J,112,7268,2)
	;;=.136^.068^.279^.041^4.082^.299^^^11.565^3.061^^.136
	;;^UTILITY(U,$J,112,7268,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7269,0)
	;;=PUDDINGS,COCONUT CREAM (REG MIX),JELL-O^BC-00542^1/2-oz.^113
	;;^UTILITY(U,$J,112,7269,1)
	;;=3.982^5.31^21.239^147.788^^^^137.168^.133^20.354^107.965^188.496^185.841^^.044^^^203.54^1.77^.044
	;;^UTILITY(U,$J,112,7269,2)
	;;=.177^.177^.345^.044^5.31^.398^^^15.044
	;;^UTILITY(U,$J,112,7269,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7270,0)
	;;=PUDDINGS,FRENCH VAN (INST MIX),JELL-O^BC-00543^1/2-oz.^147
	;;^UTILITY(U,$J,112,7270,1)
	;;=2.721^2.925^19.32^112.245^73.673^^^100.68^.061^11.565^206.122^126.531^275.51^.32^.007^^^104.762^.68^.034
	;;^UTILITY(U,$J,112,7270,2)
	;;=.136^.068^.259^.034^4.082^.299^^^11.565^1.769^^.136
	;;^UTILITY(U,$J,112,7270,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7271,0)
	;;=PUDDINGS,FRENCH VAN (REG MIX),JELL-O^BC-00544^1/2-cup^113
	;;^UTILITY(U,$J,112,7271,1)
	;;=3.54^3.54^26.549^149.558^^^^131.858^.088^15.929^101.77^164.602^163.717^^.018^^^136.283^.885^.044
	;;^UTILITY(U,$J,112,7271,2)
	;;=.177^.088^.336^.044^5.31^.354^^^15.044
	;;^UTILITY(U,$J,112,7271,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7272,0)
	;;=PUDDINGS,LEMON (INST MIX),JELL-O^BC-00545^1/2-cup^147
	;;^UTILITY(U,$J,112,7272,1)
	;;=2.721^2.925^19.796^114.286^73.265^^^99.32^.068^10.884^205.442^126.531^246.259^.313^.013^^^104.762^.68^.034
	;;^UTILITY(U,$J,112,7272,2)
	;;=.136^.068^.259^.034^4.082^.299^^^11.565^1.769^^.136
	;;^UTILITY(U,$J,112,7272,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7273,0)
	;;=PUDDINGS,LEMON (REG MIX),JELL-O^BC-00546^1/2-cup^113
	;;^UTILITY(U,$J,112,7273,1)
	;;=2.655^2.655^50.442^232.743^^^^13.274^.531^4.425^39.823^30.973^126.549^^.027^^^115.929^^.018
	;;^UTILITY(U,$J,112,7273,2)
	;;=.071^^.389^.027^14.159^.398^^^121.239
	;;^UTILITY(U,$J,112,7273,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7274,0)
	;;=PUDDINGS,LEMON,RTE,SNACK PACK^BC-00547^4.25-oz.^120
	;;^UTILITY(U,$J,112,7274,1)
	;;=0^3.333^25^125^^^^5.833^.083^^^8.333^62.5
	;;^UTILITY(U,$J,112,7274,2)
	;;=^^^^^^^^0^.667^^.5^^^^^0
	;;^UTILITY(U,$J,112,7274,20)
	;;=Bowes & Church's Food Values, Sixteenth Edition.
	;;^UTILITY(U,$J,112,7275,0)
	;;=PUDDINGS,MILK CHOC & CHOC FUDGE SWIRL,RTE,JELL-O^BC-00548^4-oz.^113