FHINI0NB	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",335,0)
	;;=FHPROD^2881202^^116.2^^^2950703^
	;;^UTILITY(U,$J,"DIPT",335,"%D",0)
	;;=^^3^3^2880709^
	;;^UTILITY(U,$J,"DIPT",335,"%D",1,0)
	;;=This template lists the production diets contained in the
	;;^UTILITY(U,$J,"DIPT",335,"%D",2,0)
	;;=Production Diet file (116.2) along with the associated
	;;^UTILITY(U,$J,"DIPT",335,"%D",3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"DIPT",335,"F",1)
	;;=8;"TALLY ORDER";R4~1;"CODE";R3;C8~.01;"DIET";L30;C14~99;"INACT";C47~3;"REV";R3;C55~7;R4;C61~7.5;"DAILY MENU";R4;C68~10;"COMBO";R4;C75~
	;;^UTILITY(U,$J,"DIPT",335,"F",2)
	;;=11,.01;"TALLIED PROD. DIETS";L30;C82~
	;;^UTILITY(U,$J,"DIPT",335,"H")
	;;=PRODUCTION DIET LIST
	;;^UTILITY(U,$J,"DIPT",336,0)
	;;=FHPSTO^2861208^^113.1^^^2950626^
	;;^UTILITY(U,$J,"DIPT",336,"%D",0)
	;;=^^3^3^2880709^
	;;^UTILITY(U,$J,"DIPT",336,"%D",1,0)
	;;=This template lists all of the storage locations contained
	;;^UTILITY(U,$J,"DIPT",336,"%D",2,0)
	;;=in the Storage Location file (113.1) along with the
	;;^UTILITY(U,$J,"DIPT",336,"%D",3,0)
	;;=associated data elements.
	;;^UTILITY(U,$J,"DIPT",336,"F",2)
	;;=.01~1;C20~2;C30~
	;;^UTILITY(U,$J,"DIPT",336,"H")
	;;=STORAGE LOCATION LIST
	;;^UTILITY(U,$J,"DIPT",337,0)
	;;=FHRECC^2950428.1057^^114.1^479^^2950705
	;;^UTILITY(U,$J,"DIPT",337,"%D",0)
	;;=^^3^3^2930119^^
	;;^UTILITY(U,$J,"DIPT",337,"%D",1,0)
	;;=This template lists the recipe categories contained in the
	;;^UTILITY(U,$J,"DIPT",337,"%D",2,0)
	;;=Recipe Category file (114.1) along with the associated
	;;^UTILITY(U,$J,"DIPT",337,"%D",3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"DIPT",337,"F",2)
	;;=.01~1;C20~2;"PRINT ORDER";C30~99;C45~
	;;^UTILITY(U,$J,"DIPT",337,"H")
	;;=RECIPE CATEGORY LIST
	;;^UTILITY(U,$J,"DIPT",338,0)
	;;=FHPROP^2880407^^114.2^^^2950706^
	;;^UTILITY(U,$J,"DIPT",338,"%D",0)
	;;=^^3^3^2880709^
	;;^UTILITY(U,$J,"DIPT",338,"%D",1,0)
	;;=This template lists the preparation areas contained in the
	;;^UTILITY(U,$J,"DIPT",338,"%D",2,0)
	;;=Preparation Area file (114.2) along with the associated
	;;^UTILITY(U,$J,"DIPT",338,"%D",3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"DIPT",338,"F",2)
	;;=.01~1;C20~2;C30~
	;;^UTILITY(U,$J,"DIPT",338,"H")
	;;=PREPARATION AREA LIST
	;;^UTILITY(U,$J,"DIPT",339,0)
	;;=FHSYP1^2900123.1544^^119.9^^^2950717^
	;;^UTILITY(U,$J,"DIPT",339,"%D",0)
	;;=^^2^2^2900317^
	;;^UTILITY(U,$J,"DIPT",339,"%D",1,0)
	;;=This template is used to list the laboratory tests selected as
	;;^UTILITY(U,$J,"DIPT",339,"%D",2,0)
	;;=those of interest to dietetics.
	;;^UTILITY(U,$J,"DIPT",339,"F",2)
	;;=80,.01~80,1;L15~80,4;C52~80,2;C60;"PRINT ON ASSESS"~80,3;C70;"PRINT ON SCREEN"~
	;;^UTILITY(U,$J,"DIPT",339,"H")
	;;=FH SITE PARAMETERS LIST
	;;^UTILITY(U,$J,"DIPT",340,0)
	;;=FHSYP2^2900123.1558^^119.9^^^2950717^
	;;^UTILITY(U,$J,"DIPT",340,"%D",0)
	;;=^^2^2^2900317^
	;;^UTILITY(U,$J,"DIPT",340,"%D",1,0)
	;;=This template is used to list the drugs contained in a set of
	;;^UTILITY(U,$J,"DIPT",340,"%D",2,0)
	;;=drug classifications selected as those of interest to dietetics.
	;;^UTILITY(U,$J,"DIPT",340,"DXS",1,9.2)
	;;=S I(1,0)=$S($D(D1):D1,1:""),I(0,0)=$S($D(D0):D0,1:""),DIP(1)=$S($D(^FH(119.9,D0,"P",D1,0)):^(0),1:""),D0=$P(DIP(1),U,1) S:'$D(^PS(50.605,+D0,0)) D0=-1
	;;^UTILITY(U,$J,"DIPT",340,"F",1)
	;;=85,.01;"DRUG CLASS"~
	;;^UTILITY(U,$J,"DIPT",340,"F",2)
	;;=85,X DXS(1,9.2) S DIP(101)=$S($D(^PS(50.605,D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) W X K DIP;C12;"TITLE";Z;"DRUG CLASSIFICATIONS:CLASSIFICATION"~
	;;^UTILITY(U,$J,"DIPT",340,"H")
	;;=FH SITE PARAMETERS LIST
	;;^UTILITY(U,$J,"DIPT",341,0)
	;;=FHSELIST^2940726.1218^@^115.2^479^@^2950703
	;;^UTILITY(U,$J,"DIPT",341,"%D",0)
	;;=^^2^2^2880901^
	;;^UTILITY(U,$J,"DIPT",341,"%D",1,0)
	;;=This template is used to list the patient preference items
	;;^UTILITY(U,$J,"DIPT",341,"%D",2,0)
	;;=contained in the Patient Preferences file (115.2).
	;;^UTILITY(U,$J,"DIPT",341,"F",2)
	;;=.01;S1~1;"TYPE";L3;C32~99;"INA";C38~20;"DEF";L3;C43~21;"MEAL";L3;C48~3;"RECIPE";C54~10,.01;"EXCLUDED RECIPES";C54~
	;;^UTILITY(U,$J,"DIPT",341,"H")
	;;=PATIENT PREFERENCES LIST
	;;^UTILITY(U,$J,"KEY",42,0)
	;;=FHMGR
	;;^UTILITY(U,$J,"KEY",42,1,0)
	;;=^^3^3^2890623^^^
	;;^UTILITY(U,$J,"KEY",42,1,1,0)
	;;=This key allows deletion of Dietetics file entries as well as the
	;;^UTILITY(U,$J,"KEY",42,1,2,0)
	;;=ability to select inactivated entries for re-activation or
	;;^UTILITY(U,$J,"KEY",42,1,3,0)
	;;=deletion.
	;;^UTILITY(U,$J,"OPT",1408,0)
	;;=FHDMP^Patient Data Log^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1408,1,0)
	;;=^^4^4^2880908^^
	;;^UTILITY(U,$J,"OPT",1408,1,1,0)
	;;=This option will dump all of the dietetic data for a particular
