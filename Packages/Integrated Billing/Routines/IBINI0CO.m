IBINI0CO	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIE",1228,"%D",1,0)
	;;=Used to position a copied block onto a form.
	;;^UTILITY(U,$J,"DIE",1228,"DIAB",5,0,357.1,0)
	;;=.06;T;REQ
	;;^UTILITY(U,$J,"DIE",1228,"DIAB",7,0,357.1,0)
	;;=.07;T;REQ
	;;^UTILITY(U,$J,"DIE",1228,"DR",1,357.1)
	;;=.04;S IBY=X;.05;S IBX=X;.06R~T~;I (X+IBX)>$G(IBFORMW) W !,"WARNING!, The block extends past the right margin!";.07R~T~;I (X+IBY)>$G(IBFORMHT) W !,"WARNING!, The block extends past the bottom margin!";S IBDONE=1;
	;;^UTILITY(U,$J,"DIE",1229,0)
	;;=IBDF EDIT HEADER&OUTLINE^2930415.0801^^357.1^^^2940309^
	;;^UTILITY(U,$J,"DIE",1229,"%D",0)
	;;=^^1^1^2940308^
	;;^UTILITY(U,$J,"DIE",1229,"%D",1,0)
	;;=Used to edit a block's header and outline.
	;;^UTILITY(U,$J,"DIE",1229,"DIAB",2,0,357.1,0)
	;;=.13;T
	;;^UTILITY(U,$J,"DIE",1229,"DIAB",3,0,357.1,0)
	;;=.11;T
	;;^UTILITY(U,$J,"DIE",1229,"DIAB",5,0,357.1,0)
	;;=.12;T
	;;^UTILITY(U,$J,"DIE",1229,"DIAB",7,0,357.1,0)
	;;=.1;T
	;;^UTILITY(U,$J,"DIE",1229,"DR",1,357.1)
	;;=.01////^S X=IBNAME;.13T~;.11T~;I $P(^IBE(357.1,D0,0),U,11)="" S Y="@1";.12T~;@1;.1T~;
	;;^UTILITY(U,$J,"DIE",1230,0)
	;;=IBDF EDIT DATA FIELD^2930617.1514^^357.5^^^2940302^
	;;^UTILITY(U,$J,"DIE",1230,"%D",0)
	;;=^^1^1^2940308^
	;;^UTILITY(U,$J,"DIE",1230,"%D",1,0)
	;;=Used to edit a data field.
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",1,0,357.5,1)
	;;=.1;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",1,1,357.52,1)
	;;=.09;"Select Subfield's Data"
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",2,0,357.5,1)
	;;=.12;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",3,0,357.5,1)
	;;=.13;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",4,0,357.5,1)
	;;=.14;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",4,1,357.52,0)
	;;=.03;T
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",9,0,357.5,0)
	;;=.05;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",10,0,357.5,0)
	;;=.04;T
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",13,0,357.5,0)
	;;=.06;T
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",15,0,357.5,0)
	;;=.07;T
	;;^UTILITY(U,$J,"DIE",1230,"DIAB",17,0,357.5,0)
	;;=.11;T;REQ
	;;^UTILITY(U,$J,"DIE",1230,"DR",1,357.5)
	;;=.01;I IBOLD S Y="@1";.02////^S X=$G(IBBLK);.03////^S X=$G(IBRTN);D DATATYPE^IBDF9B(+$G(IBRTN));D RESET^VALM4:VALMCC,REFRESH^VALM;@1;I '$G(IBLIST) S Y="@2";.05R~T~;.04T~;@2;I '$G(IBWP) S Y="@5";.06T~;S:X="" Y="@4";.07T~;@4;.11R~T~;
	;;^UTILITY(U,$J,"DIE",1230,"DR",1,357.5,1)
	;;=.1R~T~;.12R~T~;.13R~T~;.14R~T~;S Y="@99";@5;D FULL^VALM1;D HELP3^IBDFU5;S (IBY,IBX)=1;2;@99;S IBDELETE=0;
	;;^UTILITY(U,$J,"DIE",1230,"DR",2,357.52)
	;;=.01;S:X="" Y="@99" S IBW=$L(X);D RESET^VALM4:VALMCC,REFRESH^VALM;.03T~;I X["I" S Y="@7",IBW=0;.05//^S X=+IBY;S IBY=X+1;.04//^S X=+IBX;S IBX=X+2+IBW;@7;I $G(IBMF) S Y="@8";.09////^S X=1;S IBP=1;S Y="@9";@8;D HELP1^IBDFU5;
	;;^UTILITY(U,$J,"DIE",1230,"DR",2,357.52,1)
	;;=.09Select Subfield's Data~;I 'X S Y="@10";S IBP=X;@9;.08//^S X=$G(IBLEN(IBP));S IBW=+X;.06//^S X=+IBY;S IBY=X+1;.07//^S X=+IBX;S IBX=X+2+IBW;@10;D FULL^VALM1;D HELP3^IBDFU5;
	;;^UTILITY(U,$J,"DIE",1230,"ROU")
	;;=^IBXFI5
	;;^UTILITY(U,$J,"DIE",1230,"ROUOLD")
	;;=IBXFI5
	;;^UTILITY(U,$J,"DIE",1231,0)
	;;=IBDF EDIT FORM HEADER^2930730.1158^^357.5^^^2940308^
	;;^UTILITY(U,$J,"DIE",1231,"%D",0)
	;;=^^1^1^2940308^
	;;^UTILITY(U,$J,"DIE",1231,"%D",1,0)
	;;=Used to edit the data field that is the form header.
	;;^UTILITY(U,$J,"DIE",1231,"DIAB",1,1,357.52,0)
	;;=.01;"HEADER LINE"
	;;^UTILITY(U,$J,"DIE",1231,"DIAB",2,1,357.52,0)
	;;=.03;"HOW SHOULD THE HEADER LINE APPEAR? CHOOSE FROM {B=bold,U=underline}"
	;;^UTILITY(U,$J,"DIE",1231,"DIAB",3,0,357.5,0)
	;;=2;"HEADER LINE"
	;;^UTILITY(U,$J,"DIE",1231,"DR",1,357.5)
	;;=W !!,"***** Each subfield entered here will be a header line *****",!;W "**** Lines will appear in the order entered ****",!;2HEADER LINE~;
