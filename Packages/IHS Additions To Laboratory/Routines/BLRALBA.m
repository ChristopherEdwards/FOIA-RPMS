BLRALBA ;VA/DALOI/RWF/BA-PRINT THE DATA FOR INTERIM REPORTS ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1013,1015,1022,1025,1027**;NOV 01, 1997
 ;
 ;**Program Description**
 ;  This program is copied from program, LRRP1 and
 ;  modified to set the data into a temporary global
 ;  instead of displaying on a report or to the screen.
 ;
PRINT S BLRADSP=0,$P(BLRABLKS," ",80)=""
 S:'$L($G(SEX)) SEX="M" S:'$L($G(AGE)) AGE=99
 S LRTC=$P(LR0,U,12)
 S LRSPEC=+$P(LR0,U,5),X=$P(LR0,U,10) D DOC^LRX
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)="Ordering Provider: "_LRDOC
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=$E(BLRABLKS,1,9)_"Specimen: "_$P($G(^LAB(61,LRSPEC,0)),U)
 S LRAAO=0
PORD S LRAAO=$O(^TMP("LR",$J,"TP",LRAAO)) G EXIT:LRAAO=""
 D ORDER
 G PORD
 ;
EXIT K ^TMP("LR",$J,"TP")
 ;Q  ;IHS/ITSC/TPF 12/04/01 REMOVED PER MITRTEK
 ;
 S LRORU=$G(^LR(LRDFN,LRSS,LRIDT,"ORU")) Q:LRORU=""
 I $D(^LRO(68,"C",LRORU)) D
 . S LRAA=$O(^LRO(68,"C",LRORU,"")) Q:'LRAA
 . S LRAD=$O(^LRO(68,"C",LRORU,LRAA,"")) Q:'LRAD
 . S LRAN=$O(^LRO(68,"C",LRORU,LRAA,LRAD,"")) Q:'LRAN
 ;
 Q:+$G(LRAA)<1!(+$G(LRAD)<1)!(+$G(LRAN)<1)  ; IHS/OIT/MKK - LR*5.2*1027
 ;
 NEW TST
 S TST=0
 F  S TST=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST)) Q:'TST  D
 . I $P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TST,0)),U,5)="" D
 .. S LRDN=$P($P($G(^LAB(60,TST,0)),U,5),";",2)
 .. ; Do not combine the 3 if statements below into 1 ;DAOU/DJW 1/23/02
 .. I '$D(LRDN) D PEND Q
 .. I $G(LRDN)="" D PEND Q
 .. I '$D(^LR(LRDFN,LRSS,LRIDT,LRDN)) D PEND Q
 Q
 ;
PEND ; Set up this test to be displayed as pending 
 S BLRAZ=$P($G(^LAB(60,TST,0)),U,1),BLRAZ1=30 D Z1
 S BLRAZ=BLRAZ_"pending" D Z1
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=BLRAZ
 Q
 ;
ORDER S LRCDT=0
TST S LRCDT=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT)) Q:LRCDT=""
 D TEST
 G TST
TEST S LRIDT=9999999-LRCDT,LRSS=$P($G(^TMP("LR",$J,"TP",LRAAO)),U,2)
 ;
 ;  Microbiology
 I LRSS="MI" S LRH=1,LRHF=1,LRFOOT=0 K A,Z,LRH Q
 ;
 Q:'$P(LR0,U,3)
 D ORU
 D LIN
 S Y=LRCDT D DD^LRX
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=$E(BLRABLKS,1,30)_Y
 S BLRAZ=$E(BLRABLKS,1,5)_"Test name",BLRAZ1=30 D Z1
 S BLRAZ=BLRAZ_"Result    units",BLRAZ1=21 D Z1
 S BLRAZ=BLRAZ_$E(BLRABLKS,1,6)_"Ref.   range"
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=BLRAZ
 ;
 S LRPO=0 F  S LRPO=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO)) Q:LRPO'>0  S LRDATA=^(LRPO) D DATA
 I $D(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C")) D
 . S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)="Comment: "
 . S LRCMNT=0 F  S LRCMNT=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) Q:LRCMNT<1  D
 .. S ^TMP($J,"BLRA",BLRADSP,0)=$G(^TMP($J,"BLRA",BLRADSP,0))_$G(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT))
 .. I $O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=$E(BLRABLKS,1,9)
 Q
DATA S LRTSTS=+LRDATA,LRPC=$P(LRDATA,U,5),LRSUB=$P(LRDATA,U,6)
 S X=$P(LRDATA,U,7),LRFFLG=$P(LRDATA,U,8) Q:X=""
 S BLRAZ=$S($L($P(LRDATA,U,2))>20:$P(LRDATA,U,3),1:$P(LRDATA,U,2))
 S BLRAZ1=27 D Z1
 ;
 ;  If value to display is an executable
 I LRPC'="" D
 . S BLRAZZ="S X="_LRPC
 . X BLRAZZ
 . S LRPC=X
 ;
 S BLRAZ=BLRAZ_$S(LRPC="":$J(X,LRCW),1:LRPC)_" "_LRFFLG
 S X=$S($D(^LAB(60,LRTSTS,1,LRSPEC,0)):^(0),1:"")
 ;Q:'$L(X)
 S LRTHER=$S($L($P(X,U,11,12))>1:1,1:0)
 S LRLO=$S(LRTHER:$P(X,U,11),1:$P(X,U,2))
  ; ----- BEGIN IHS/OIT/MKK MODIFICATION LR*5.2*1025
 I $G(LRLO)'["$"&($E($RE(LRLO),1,1)=".") S LRLO=$RE($P($RE(LRLO),".",2,999))
 ; ----- END IHS/OIT/MKK MODIFICATION LR*5.2*1025
 S LRHI=$S(LRTHER:$P(X,U,12),1:$P(X,U,3))
 ; ----- BEGIN IHS/OIT/MKK MODIFICATION LR*5.2*1025
 I $G(LRHI)'["$"&($E($RE(LRHI),1,1)=".") S LRHI=$RE($P($RE(LRHI),".",2,999))
 ; ----- END IHS/OIT/MKK MODIFICATION LR*5.2*1025
 ; 
 S @("LRLO="_$S($L(LRLO):LRLO,1:""""""))
 S @("LRHI="_$S($L(LRHI):LRHI,1:""""""))
 ; ----- BEGIN IHS/OIT/MKK MODIFICATION LR*5.2*1025
 ;      The changes that were implemented below DO NOT work if the
 ;      reference ranges are $SELECT statements.  Therefore, they
 ;      are being commented out.
 ; ----- BEGIN IHS/OIT/MKK MODIFICATION LR*5.2*1022
 ; The preceding two lines will fail with a <SYNTAX> error if the
 ; LRLO or the LRHI variables end in periods; viz., 20.
 ; 
 ; In order to ensure that a variable that ends with a period does not
 ; adversely effect any other code, the next two lines of code will
 ; reset the LRLO and/or the LRHI variable, if necessary.
 ; 
 I $P(LRLO,".",2)="" S LRLO=$P(LRLO,".")
 I $P(LRHI,".",2)="" S LRHI=$P(LRHI,".")
 ; ----- END IHS/OIT/MKK MODIFICATION LR*5.2*1022
 ; ----- END IHS/OIT/MKK MODIFICATION LR*5.2*1025
 ; 
 S BLRAZ=BLRAZ,BLRAZ1=40 D Z1
 S BLRAZ=BLRAZ_$P(X,U,7),BLRAZ1=51 D Z1
 S BLRAZ=BLRAZ_$J(LRLO,4)_$S($L(LRHI):" - "_$J(LRHI,4),1:"")
 S BLRAZ1=12 D Z1
 S BLRAZ=BLRAZ_$S(LRTHER:"(Ther. range)",1:"")
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=BLRAZ
 I $O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,0))>0 D
 . S LRINTP=0
 . F  S LRINTP=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,LRINTP)) Q:LRINTP<1  D
 .. S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=$E(BLRABLKS,1,7)_"Eval: "_$G(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,LRINTP))
 Q
 ;
HDR ;EP
 ; Header Information
 I $G(BLRABLKS)="" S $P(BLRABLKS," ",80)=""
 S LRHF=0,LRJ02=1,VALMHDR(1)=" "
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG") S VALMHDR(1)="** PERSONAL DATA - PRIVACY ACT OF 1974 **"
 S BLRAZ=PNM,BLRAZ1=60 D Z1
 S A8=$P($H,",",2),Y=A8\3600_":"_$E((A8\60#60+100),2,3)
 S VALMHDR(2)=BLRAZ_$$FMTE^XLFDT(DT)_" "_Y
 S VALMHDR(3)=$E(BLRABLKS,1,5)_"HRCN: "_HRCN_"    SEX: "_SEX_"    AGE: "_AGE_"    LOC: "_$G(LROC)
 Q
 ;
ORU ; Display remote ordering info if available
 N LRX
 S LRX=$G(^LR(LRDFN,"CH",LRIDT,"ORU"))
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)="  Accession [UID]: "_$P(LR0,U,6)_" ["_$P(LRX,U)_"]"
 I $P(LRX,U,2) D
 . S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=$E(BLRABLKS,1,2)="Ordering Site: "_$$EXTERNAL^DILFD(63.04,.32,"",$P(LRX,U,2))
 . S BLRAZ=" Ordering Site UID: "_$P(LRX,U,5),BLRZ1=43 D Z1
 . S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=BLRAZ
 I $P(LRX,U,3) D
 . S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)="Collecting Site: "_$$EXTERNAL^DILFD(63.04,.33,"",$P(LRX,U,3))
 Q
 ;
Z1 ;  Pad with trailing spaces
 F BLRAI=1:1:(BLRAZ1-$L(BLRAZ)) S BLRAZ=BLRAZ_" "
 Q
 ;
LIN ;EP
 ; Set a Blank Line
 S BLRADSP=BLRADSP+1,^TMP($J,"BLRA",BLRADSP,0)=" "
 Q
