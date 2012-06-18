APCLXXAB ; IHS/OHPRD/TMJ -CREATED BY ^XBERTN ON APR 18, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;; E  W "Saving of routine ^",ATXPGM," failed.",!
 ;; K ^TMP("ATXPGM",$J,ATXPGM)
 ;; Q
 ;; ;
 ;;SETTMP ; SET ^TMP GLOBAL
 ;; S ATXL=ATXL+1
 ;; S ^TMP("ATXPGM",$J,ATXPGM,ATXL,0)=X
 ;; S ATXLNTH=ATXLNTH+(4+$L(X))
 ;; Q
 ;; ;
 ;;RECURSE ; CALLED FROM PGMTMP TO BUILD OTHER ROUTINES IF TOO LARGE
 ;; NEW ATXL,ATXLNTH,ATXPGM,ATXTMPQ
 ;; S ATXPGMC=ATXPGMC+1
 ;; S ATXPGM=ATXPGMR_$C(64+ATXPGMC)
 ;; D PGMBEG
 ;; D PGMTMP
 ;; D PGMSAVE
 ;; S ATXPGMS(ATXPGM)=""
 ;; Q
 ;; ;
 ;;DRIVER ; BUILD MAIN DRIVER ROUTINE
 ;; S ATXPGM=ATXDRVR
 ;; K ^TMP("ATXPGM",$J,ATXPGM)
 ;; S (ATXL,ATXLNTH)=0
 ;; S X=ATXPGM_" ;"_ATXASP_"-CREATED BY ^ATXSTX ON "_Y_";" D SETTMP
 ;; S X=" ;;"_ATXVER D SETTMP
 ;; S X=" ;" D SETTMP
 ;; S X=" ; See referenced routines to see taxonomies being loaded." D SETTMP
 ;; S X=" ;" D SETTMP
 ;; S X="START ;" D SETTMP
 ;; F ATXI=1:1:26 S X=ATXPGM_$C(64+ATXI) X ^%ZOSF("TEST") Q:'$T  D
 ;; . X "ZL @X S Z=$T(@X+2),Z=$P(Z,"";;"",2)"
 ;; . S Y="",$P(Y," ",(10-$L(X)))=" ",Y=" ;"_Y_Z
 ;; . S X=" D ^"_X_Y D SETTMP
 ;; . Q
 ;; S X=" Q" D SETTMP
 ;; D PGMSAVE
 ;; Q
 ;; ;
 ;;POSTINIT ; UPDATE POST INIT ENTRY IN PACKAGE FILE
 ;; S ATXX=$$VALI^XBDIQ1(9.4,ATXPK,914)
 ;; I ATXX'="",ATXX'=ATXDRVR D  Q:ATXQ
 ;; . S ATXQ=1
 ;; . W !!,"Package file already has post-init routine=^",ATXX
 ;; . S DIR(0)="Y",DIR("A")="Do you want me to replace it",DIR("B")="N" K DA D ^DIR K DIR
 ;; . Q:'Y
 ;; . S ATXQ=0
 ;; . Q
 ;; S DIE="^DIC(9.4,",DA=ATXPK,DR="914////"_ATXDRVR
 ;; D ^DIE
 ;; W !,"Package post-init routine has been set to ^",ATXDRVR,!
 ;; Q
 ;; ;
 ;;EOJ ;
 ;; K ^TMP("ATX",$J),^TMP("ATXPGM",$J)
 ;; D EN^XBVK("ATX")
 ;; Q
 ;; ;
 ;; ;-------------------
 ;;INSTALL ; This is to test the code for the post init routine
 ;; K ^TMP("ATX",$J)
 ;; ;F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 ;; F ATXI=4:1 S X=$P($G(^TMP("ATXPGM",$J,ATXI,0)),";;",2) Q:X=""  S ATXI=ATXI+1,Y=$P(^TMP("ATXPGM",$J,ATXI,0),";;",2) S @X=Y
 ;; I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 ;; I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 ;; D KILL^ATXSTX2
 ;; Q
 ;; ;--------------------
 ;; ;
 ;;CODE ;; If you modify this code change all F ATXI=n1:n2:n3 as appropriate
 ;;1 ;; ;
 ;;2 ;;START ;
 ;;3 ;; K:'$G(ATXPGMC) ^TMP("ATX",$J)
 ;;4 ;; S ATXPGMC=$G(ATXPGMC)+1
 ;;5 ;; F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 ;;6 ;; D OTHER
 ;;7 ;; I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 ;;8 ;; I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 ;;9 ;; D KILL^ATXSTX2
 ;;10 ;; Q
