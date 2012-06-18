BARUPCH2 ; IHS/SD/LSL - CHECK 3P UPLOAD ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; Global changes for new indirect global ABMA - @ABMA@
 ;;
BILL ; EP
 ; check bill
 K ^TMP("BAR",$J,"BARTMPBL",$J)
 S BARDSP=$G(^TMP("BAR",$J,"BARUPDSP",$J))
 S BARNULL=0
 D ENP^XBDIQ1(90050.01,BARUPDA,".01;.1;3;13;15;17;20;102;103;18:20;113;114;201:207;101;108;112","^TMP(""BAR"",$J,""BARTMPBL"",$J,","I")
 N A,B,C,X,Y,Z
 I '$L(^TMP("BAR",$J,"BARTMPBL",$J,101)) S BARNULL=1,BARDIF=1 G NULL
 ; resolve vp to insurer pointers
 F Z=3,205,206,207 D
 . S ^TMP("BAR",$J,"BARTMPBL",$J,Z,"V")=""
 . I ^TMP("BAR",$J,"BARTMPBL",$J,Z,"I") D
 . . K BARLSL
 . . S BARLSL=^TMP("BAR",$J,"BARTMPBL",$J,Z,"I")
 . . S ^TMP("BAR",$J,"BARTMPBL",$J,Z,"V")=$$GET1^DIQ(90050.02,BARLSL,1.001)
 . . K BARLSL
 F I=1:1 S X=$T(MAPBL+I),Y=$P(X,";;",2),X=$P(Y,";"),C=$P(Y,";",3),Y=$P(Y,";",2) Q:X="""END"""  Q:BARNULL  D
 .S A="@BAR3PUP@("_X_")"
 .S A=@A
 .S B="^TMP(""BAR"",$J,""BARTMPBL"",$J,"_Y_")"
 .S B=@B
 .I $L(B) S:C="+" B=+B
 .I X["PROV200" S X="""PROV"""
 .S BARBLDIF=0
 .; screen for odd items
 .I X["INS",A="",B=@BAR3PUP@("PTNM") Q
 .I X["INS",A="",B'=@BAR3PUP@("PTNM") D  Q
 ..S BARBLDIF=1,BARDIF=1
 ..S ^TMP("BAR",$J,"BARUPCHK","DIF",BARUPDA,"BL",X)=A
 ..S ^TMP("BAR",$J,"BARUPCHK","DIF",BARUPDA,"BL",X,Y)=B
 .I X["DTBILL",A="" Q
 .I A'=B D
 ..S BARBLDIF=1,BARDIF=1
 ..S ^TMP("BAR",$J,"BARUPCHK","DIF",BARUPDA,"BL",X)=A
 ..S ^TMP("BAR",$J,"BARUPCHK","DIF",BARUPDA,"BL",X,Y)=B
 .I BARBLDIF,BARSHOW W !,X,?15,A,?30,B,?45,BARBLDIF,?50,Y
 ;
NULL ;
 Q
 ; *********************************************************************
 ;
IT ; EP
 ; check bill - to reload A/R items from 3P everytime
 D DELITM^BARUP1
 D SETITM^BARUP1
 Q
 ; *********************************************************************
 ;
MAPBL ;; map between 3p and a/r bill
 ;;"BLNM";.01
 ;;"BLDA";17
 ;;"BLAMT";13
 ;;"PTNM";101,"I"
 ;;"CLNC";112,"I"
 ;;"INS";3,"V"
 ;;"PRIM";205,"V"
 ;;"SEC";206,"V"
 ;;"TERT";207,"V"
 ;;"PROV";113,"I"
 ;;"VSLC";108,"I"
 ;;"VSTP";114,"I"
 ;;"DOSB";102,"I"
 ;;"DOSE";103,"I"
 ;;"DTAP";18,"I"
 ;;"DTBILL";19,"I"
 ;;"CREDIT";20
 ;;"END";
 ;;"POHL";201
 ;;"POLN";201
MAPIT ;; map between 3p and a/r item
