APCLPOS3 ; IHS/OHPRD/TMJ -CREATED BY ^XBERERTN ON APR 04, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ; This routine loads Routine ^ATXCHK
 ;
START ;
 S XBERPGM="ATXCHK"
 F I=1:1 S Y=$P($T(RTN+I),";;",2,99) Q:Y=""  S X="^TMP(""XBERPGM"",$J,"_I_",0)" S @X=Y
 S XCN=0,DIE="^TMP(""XBERPGM"","_$J_",",X=XBERPGM
 X ^%ZOSF("SAVE")
 K DIE,XCM,XCN
 S X=XBERPGM
 X ^%ZOSF("TEST")
 W !
 I $T W "Routine ^",XBERPGM," has been filed.",! I 1
 E  W "Saving of routine ^",XBERPGM," failed.",!
 K ^TMP("XBERPGM",$J)
 K XBERPGM,I,X,Y
 Q
 ;
RTN ; The routine to be loaded follows:
 ;;ATXCHK ; IHS/TUCSON/LAB - CHECK ICD CODES AGAINST TAXONOMY ;  [ 04/27/95  7:40 AM ]
 ;; ;;5.0;TAXONOMY SYSTEM;**1**;OCT 12, 1994
 ;; ;
 ;; ;IHS/TUCSON/LAB - changed VCODE+2 $D TO $E 02/27/95
 ;; ;
 ;;ICD(X,Y,Z) ;EP >>EXTRN FUNC to see if ICD code belongs in certain taxonomy
 ;; ;input variables: X=dx ifn, Y=taxonomy ifn, Z=9 for dx or 0 for proc
 ;; N ATXICD,ATXBEG,ATXEND,ATXFLG
 ;; S ATXFLG=0 I '$D(X)!'$D(Y)!'$D(Z) G EOJ
 ;; I (X="")!(Y="") G EOJ
 ;; S ATXICD=$S(Z=9:$P($G(^ICD9(X,0)),U),Z=0:$P($G(^ICD0(X,0)),U),1:"")
 ;; I ATXICD="" G EOJ
 ;; S ATXBEG=0
 ;; F  S ATXBEG=$O(^ATXAX(Y,21,"AA",ATXBEG)) Q:ATXBEG=""  Q:ATXFLG=1  D
 ;; .S ATXEND=$O(^ATXAX(Y,21,"AA",ATXBEG,0)) Q:ATXEND=""
 ;; .I ATXICD?1A.E D VCODE Q
 ;; .Q:ATXICD<ATXBEG  ;already passed code
 ;; .I ATXICD'>ATXEND S ATXFLG=1 Q  ;found code in taxonomy
 ;;EOJ Q ATXFLG
 ;; ;
 ;;VCODE ;checks v codes and e codes
 ;; I ATXBEG'?1A.E Q
 ;; I $E(ATXICD)'=$E(ATXBEG) Q  ;don't mix v and e codes ;ihs/tucson/lab changed $D to $E 2/27/95
 ;; Q:$E(ATXICD,2,9)<$E(ATXBEG,2,9)
 ;; I $E(ATXICD,2,9)'>$E(ATXEND,2,9) S ATXFLG=1
 ;; Q
