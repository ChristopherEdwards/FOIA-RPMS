BDGAD4 ; IHS/ANMC/LJF - A&D DISCHARGES ; 
 ;;5.3;PIMS;**1003,1005,1009,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/03/2005 PATCH 1003 added code for multiple discharges per patient
 ;IHS/OIT/LJF  12/29/2005 PATCH 1005 changed AGE^BDGF2 to official API
 ;cmi/anch/maw 02/11/2008 added fix in GATHER PATCH 1009
 ;ihs/cmi/maw  09/14/2011 added check of service being DAY SURGERY
 ;
LOOP ;--loop discharges
 NEW DGDT,DFN,IFN
 S DGDT=DGBEG
 F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D GATHER
 Q
 ;
GATHER ; gather info on discharges and put counts into arrays
 NEW ADM,ADULT,OLDWD,OLDSV,OLDSVN,X,TYPE,LOS,D0,PIECE,NAME,DATA
 S ADM=$P(^DGPM(IFN,0),U,14)                         ;admit ien
 S ADULT=$S($$AGE<$$ADULT^BDGPAR:0,1:1)              ;1=adult, 0=peds
 S TYPE=$$GET1^DIQ(405,IFN,.04)                      ;type of disch
 S D0=ADM D EN^DGPMLOS S LOS=$P(X,U,5)               ;length of stay
 ;
 S OLDWD=$P($G(^DGPM(+$$PRIORMVT^BDGF1(DGDT,ADM,DFN),0)),U,6)  ;old ward
 Q:'$G(OLDWD)  ;cmi/maw 2/11/2008 added for no ward being returned PATCH 1009
 ;
 S OLDSV=$P(^DGPM(+$$PRIORTXN^BDGF1(DGDT,ADM,DFN),0),U,9)  ;old srv
 S OLDSVN=$$GET1^DIQ(45.7,OLDSV,.01)
 I OLDSVN["OBSERVATION" S LOS=$$LOSHRS^BDGF1(ADM,DGDT,DFN)  ;los-hours
 ;
 ;  collect patient data for report
 S NAME=$$GET1^DIQ(2,DFN,.01),X=$S(OLDSVN["OBSERVATION":"O",OLDSVN="DAY SURGERY":"D",1:"I")
 S DATA=OLDSV_U_OLDWD
 ;IHS/OIT/LJF 12/29/2005 PATCH 1005 changed AGE call to official API
 ;I BDGFRM="D" S DATA=DATA_U_$$LASTPRV^BDGF1(ADM,DFN)_U_$$AGE^BDGF2(DFN,+$G(^DGPM(ADM,0)))  ;add provider and age at admission
 I BDGFRM="D" S DATA=DATA_U_$$LASTPRV^BDGF1(ADM,DFN)_U_$$AGE^AUPNPAT(DFN,+$G(^DGPM(ADM,0)))  ;add provider and age at admission
 ;
 I TYPE["DEATH" D
 . S ^TMP("BDGAD",$J,"DEATH",NAME,DFN)=DATA
 ;
 ;IHS/ITSC/LJF 6/3/2005 PATCH 1003
 E  D
 . I OLDSVN="NEWBORN" D
 .. ;S ^TMP("BDGAD",$J,"DSCH","N",NAME,DFN)=DATA
 .. S ^TMP("BDGAD",$J,"DSCH","N",NAME,DFN,IFN)=DATA
 . ;E  S ^TMP("BDGAD",$J,"DSCH",X,NAME,DFN)=DATA
 . E  S ^TMP("BDGAD",$J,"DSCH",X,NAME,DFN,IFN)=DATA
 ;end of PATCH 1003 changes
 ;
 Q:$G(BDGREP)                              ;reprint, not recalculating
 ;
 ;
 ; -- increment counts in ADT Census files
 ; --- discharge for service within ward
 ; ---- set zero node if needed
 I '$D(^BDGCWD(OLDWD,1,BDGT,1,OLDSV)) D
 . S ^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)=OLDSV
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,0),U,3,4)=OLDSV_U_($P(^BDGCWD(OLDWD,1,BDGT,1,0),U,4)+1)
 ;
 ; ---- increment discharge/death counts
 S PIECE=$S(ADULT:4,1:14)
 I TYPE["DEATH" D
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,(PIECE+3))=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,(PIECE+3))+1
 . S $P(^BDGCWD(OLDWD,1,BDGT,0),U,7)=$P($G(^BDGCWD(OLDWD,1,BDGT,0)),U,7)+1
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,(PIECE+3))=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,(PIECE+3))+1
 E  D
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,PIECE)=$P($G(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0)),U,PIECE)+1
 . S $P(^BDGCWD(OLDWD,1,BDGT,0),U,4)=$P($G(^BDGCWD(OLDWD,1,BDGT,0)),U,4)+1
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,PIECE)=$P($G(^BDGCTX(OLDSV,1,BDGT,0)),U,PIECE)+1
 ;
 ; --- increment LOS (inpt in days/observations in hours)
 I OLDSVN["OBSERVATION" S PIECE=$S(ADULT:11,1:21)
 E  S PIECE=$S(ADULT:9,1:19)
 S $P(^BDGCWD(OLDWD,1,BDGT,0),U,$S(PIECE=19:9,PIECE=21:11,1:PIECE))=$P(^BDGCWD(OLDWD,1,BDGT,0),U,$S(PIECE=19:9,PIECE=21:11,1:PIECE))+LOS
 S $P(^BDGCTX(OLDSV,1,BDGT,0),U,PIECE)=$P(^BDGCTX(OLDSV,1,BDGT,0),U,PIECE)+LOS
 S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,PIECE)=$P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,PIECE)+LOS
 ;
 ; --- increment one day inpatients
 I (DGDT\1)=($P(^DGPM(ADM,0),U)\1) D
 . S $P(^BDGCWD(OLDWD,1,BDGT,0),U,8)=$P(^BDGCWD(OLDWD,1,BDGT,0),U,8)+1
 . S PIECE=$S(ADULT:8,1:18)
 . S $P(^BDGCTX(OLDSV,1,BDGT,0),U,PIECE)=$P(^BDGCTX(OLDSV,1,BDGT,0),U,PIECE)+1
 . S $P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,PIECE)=$P(^BDGCWD(OLDWD,1,BDGT,1,OLDSV,0),U,PIECE)+1
 ;
 Q
 ;
AGE() ;--age at admit
 NEW X,X1,X2
 S X1=+$G(^DGPM(ADM,0))                  ;admit date
 S X2=$P($G(^DPT(DFN,0)),U,3) D ^%DTC    ;date of birth
 Q:'X "" Q X\365.25
 ;
