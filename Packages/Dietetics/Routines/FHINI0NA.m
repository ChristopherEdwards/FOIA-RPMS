FHINI0NA	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"DIPT",326,"H")
	;;=FOOD NUTRIENTS
	;;^UTILITY(U,$J,"DIPT",327,0)
	;;=FHSFMENU^2850316^^118.1^^^2950712^
	;;^UTILITY(U,$J,"DIPT",327,"%D",0)
	;;=^^3^3^2880709^
	;;^UTILITY(U,$J,"DIPT",327,"%D",1,0)
	;;=This template lists all of the supplemental menus listed in
	;;^UTILITY(U,$J,"DIPT",327,"%D",2,0)
	;;=the Supplemental Feeding Menu file (118.1) along with the
	;;^UTILITY(U,$J,"DIPT",327,"%D",3,0)
	;;=associated data elements.
	;;^UTILITY(U,$J,"DIPT",327,"F",1)
	;;=.01~1;C30~99;"INACT";C42;R4~3;"D/T";C49;L4~10.5;"";R3;C56~10;"10AM FEEDING";C60~14.5;"";R3;C82~14;"2PM FEEDING";C86~18.5;"";R3;C108~18;"8PM FEEDING";C112~11.5;"";R3;C56~
	;;^UTILITY(U,$J,"DIPT",327,"F",2)
	;;=11;"";C60~15.5;"";R3;C82~15;"";C86~19.5;"";R3;C108~19;"";C112~12.5;"";R3;C56~12;"";C60~16.5;"";R3;C82~16;"";C86~20.5;"";R3;C108~20;"";C112~
	;;^UTILITY(U,$J,"DIPT",327,"F",3)
	;;=13.5;"";R3;C56~13;"";C60~17.5;"";R3;C82~17;"";C86~21.5;"";R3;C108~21;"";C112~
	;;^UTILITY(U,$J,"DIPT",327,"H")
	;;=SUPPLEMENTAL FEEDING MENU LIST
	;;^UTILITY(U,$J,"DIPT",328,0)
	;;=FHSFLST^2901016.1004^^118^^^2950713^
	;;^UTILITY(U,$J,"DIPT",328,"%D",0)
	;;=^^3^3^2910507^^^
	;;^UTILITY(U,$J,"DIPT",328,"%D",1,0)
	;;=This template lists all of the supplemental feedings contained
	;;^UTILITY(U,$J,"DIPT",328,"%D",2,0)
	;;=in the Supplemental Feeding file (118) along with the associated
	;;^UTILITY(U,$J,"DIPT",328,"%D",3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"DIPT",328,"F",2)
	;;=.01~5;"LABEL";C30~10;"BULK ONLY";C40~7;"MED VEH";C47~99;"INACT";C53~20;C59;R5~11;"RECIPE";C68~1,.01;C101~
	;;^UTILITY(U,$J,"DIPT",328,"H")
	;;=SUPPLEMENTAL FEEDINGS LIST
	;;^UTILITY(U,$J,"DIPT",329,0)
	;;=FHUMENU^2950313.1555^^112.6^479^^2950711
	;;^UTILITY(U,$J,"DIPT",329,"%D",0)
	;;=^^3^3^2880717^^
	;;^UTILITY(U,$J,"DIPT",329,"%D",1,0)
	;;=This template will list all users who have created User Menus
	;;^UTILITY(U,$J,"DIPT",329,"%D",2,0)
	;;=along with the menu names they created, date of creation, and
	;;^UTILITY(U,$J,"DIPT",329,"%D",3,0)
	;;=type of units selected.
	;;^UTILITY(U,$J,"DIPT",329,"F",2)
	;;=.8;L25~.7;"CREATED";C28~.6;C42~.01;"USER MENU";C51;L28~2;"REC MENU?";C82~
	;;^UTILITY(U,$J,"DIPT",329,"H")
	;;=USER MENU LIST
	;;^UTILITY(U,$J,"DIPT",330,0)
	;;=FHTFLST^2920928.1349^^118.2^^^2950711^
	;;^UTILITY(U,$J,"DIPT",330,"%D",0)
	;;=^^2^2^2920929^^
	;;^UTILITY(U,$J,"DIPT",330,"%D",1,0)
	;;=This template lists all of the tubefeeding products in the
	;;^UTILITY(U,$J,"DIPT",330,"%D",2,0)
	;;=Tubefeeding file (118.2) along with its various data elements.
	;;^UTILITY(U,$J,"DIPT",330,"F",2)
	;;=.01~1~2;R8~3~5;R5~99~11;"RECIPE";L20~10,.01;C101~
	;;^UTILITY(U,$J,"DIPT",330,"H")
	;;=TUBEFEEDING LIST
	;;^UTILITY(U,$J,"DIPT",331,0)
	;;=FHORCON^2860813^^119.5^^^2950711^
	;;^UTILITY(U,$J,"DIPT",331,"%D",0)
	;;=^^3^3^2880709^
	;;^UTILITY(U,$J,"DIPT",331,"%D",1,0)
	;;=This template lists the consultation types contained in the
	;;^UTILITY(U,$J,"DIPT",331,"%D",2,0)
	;;=Dietetic Consults file (119.5) along with the associated
	;;^UTILITY(U,$J,"DIPT",331,"%D",3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"DIPT",331,"F",2)
	;;=.01~1;C52~2;"ASK";C65~3;"IN-TU";C71~4;"FU-TU";C81~99;"INACT";C90~5;"BULLETIN";C100~
	;;^UTILITY(U,$J,"DIPT",331,"H")
	;;=DIETETIC CONSULTS LIST
	;;^UTILITY(U,$J,"DIPT",332,0)
	;;=FHORWRD^2850528^^119.6^^^2950711^
	;;^UTILITY(U,$J,"DIPT",332,"%D",0)
	;;=^^2^2^2880709^^
	;;^UTILITY(U,$J,"DIPT",332,"%D",1,0)
	;;=This template lists the responsible clinician for each ward
	;;^UTILITY(U,$J,"DIPT",332,"%D",2,0)
	;;=in the Dietetic Ward file (119.6).
	;;^UTILITY(U,$J,"DIPT",332,"F",1)
	;;=.01~1~
	;;^UTILITY(U,$J,"DIPT",332,"H")
	;;=WARD ASSIGNMENTS LIST
	;;^UTILITY(U,$J,"DIPT",333,0)
	;;=FHDIETL^2870120^^111^^^2950711^
	;;^UTILITY(U,$J,"DIPT",333,"%D",0)
	;;=^^1^1^2950717^^
	;;^UTILITY(U,$J,"DIPT",333,"%D",1,0)
	;;=This template is used to print a basic diet list.
	;;^UTILITY(U,$J,"DIPT",333,"F",2)
	;;=.01~1;C32~3;"DIET PREC";C46~6;"ABBREV LABEL";C52~4;"PROD DIET";C66;L12~2;"ASK EXP";C80~5;"MAIL";C86~99;"INACT";C92~10,.01;C100~
	;;^UTILITY(U,$J,"DIPT",333,"H")
	;;=DIETS LIST
	;;^UTILITY(U,$J,"DIPT",334,0)
	;;=FHISLST^2860813^^119.4^^^2950711^
	;;^UTILITY(U,$J,"DIPT",334,"%D",0)
	;;=^^3^3^2880709^^
	;;^UTILITY(U,$J,"DIPT",334,"%D",1,0)
	;;=This template lists all of the isolation types listed in
	;;^UTILITY(U,$J,"DIPT",334,"%D",2,0)
	;;=the Isolation/Precaution Type file (119.4) along with the
	;;^UTILITY(U,$J,"DIPT",334,"%D",3,0)
	;;=associated data elements.
	;;^UTILITY(U,$J,"DIPT",334,"F",2)
	;;=.01~1~2~99;"INACTIVE"~
	;;^UTILITY(U,$J,"DIPT",334,"H")
	;;=ISOLATION TYPE LIST
