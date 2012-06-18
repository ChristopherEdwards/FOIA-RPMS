BHSWH ;IHS/CIA/MGH - Health Summary for Women's health profile ;17-Mar-2006 10:36;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;;March 17, 2006
 ;===================================================================
 ;Rewrite of IHS health summary to use women's health in VA health summary format
 ;This routine writes out the health summary to the screen to be use din the EHR
 ;Taken from APCHS9B3
 ; IHS/TUCSON/LAB - women's health supplement ;  [ 02/19/03  7:37 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**3,5,8,9,10**;JUN 24, 1997
 ;
 ;
PROF ; Control Women's health profile retrieval and display;
 N BWD
 S BWD=0
 K ^TMP("BHS",$J)
 Q:$P($G(^DPT(DFN,0)),U,2)="M"
 D EP^BHSWPROF(DFN,BWD)
 Q:'$D(^TMP("BHS",$J))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 D WHMAIN
 Q
PROF2 ;Do detailed display of patient profile
 N BWD
 S BWD=1
 K ^TMP("BHS",$J)
 Q:$P($G(^DPT(DFN,0)),U,2)="M"
 D EP^BHSWPROF(DFN,BWD)
 Q:'$D(^TMP("BHS",$J))
 D CKP^GMTSUP Q:$D(GMTSQIT)
 D WHMAIN
 Q
WHMAIN ; Main Display
 N GMORDER,GMHR,GMDT,GMIFN,GMN0,GMW,X,GMTSDAT,HF,LEVEL,PHFC,COMMENT
 N GMICL,GMTAB,GMTSLN,BWACCP,BWACC,Z
 S (BWACCP,Z)=0
 S GMORDER="" F  S GMORDER=$O(^TMP("BHS",$J,GMORDER)) Q:GMORDER=""  D  Q:$D(GMTSQIT)
 . I GMORDER=1 D HEADER
 . I GMORDER=2 D RESULT
 K ^TMP("BHS",$J)
 Q
HEADER ; Display Header fields from the profile
 D CKP^GMTSUP Q:$D(GMTSQIT)  W "* * * Patient Profile * * *",!
 S GMHR="" F  S GMHR=$O(^TMP("BHS",$J,GMORDER,GMHR)) Q:GMHR=""  D  Q:$D(GMTSQIT)
 . D CKP^GMTSUP Q:$D(GMTSQIT)
 . W $P($G(^TMP("BHS",$J,GMORDER,GMHR)),U,1)
 . W ?50,$P($G(^TMP("BHS",$J,GMORDER,GMHR)),U,2),!
 Q
RESULT ; Display Data from profile
 I BWD=1 D DETAIL Q
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"DATE",?16,"PROCEDURE",?27,"RESULTS/DIAGNOSIS",?71,"STATUS"
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W !,"--------",?16,"---------",?27,"----------------------------"
 W ?71,"------"
 S GMIFN="" F  S GMIFN=$O(^TMP("BHS",$J,GMORDER,GMIFN)) Q:GMIFN=""  D  Q:$D(GMTSQIT)
 .S GMN0=$G(^TMP("BHS",$J,GMORDER,GMIFN))
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .;---> QUIT IF NOT A PROCEDURE (PIECE 1'=1).
 .Q:$P(GMN0,U)'=1
 .W !,$P(GMN0,U,4)                               ;DATE OF PROCEDURE
 .W ?17,$P(GMN0,U,5)                           ;PROCEDURE ABBREVIATION
 .W ?27,$P(GMN0,U,7)                           ;RESULT
 .W ?71,$P(GMN0,U,9)                           ;STATUS
 .S BWACCP=$P(GMN0,U,6)                        ;STORE AS PREVIOUS ACCESS#
 Q
DETAIL ;Display the detailed display
 N I
 S GMIFN="" F  S GMIFN=$O(^TMP("BHS",$J,GMORDER,GMIFN)) Q:GMIFN=""  D  Q:$D(GMTSQIT)
 .S GMN0=$G(^TMP("BHS",$J,GMORDER,GMIFN))
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .;Copied from BWPROF to display data from profile
 .;---> IF PIECE 1=1 DISPLAY AS A PROCEDURE.
 .I $P(GMN0,U)=1 D  Q
 ..W !,"------------------------------< "
 ..W "PROCEDURE: ",$P(GMN0,U,5)," >"            ;PROCEDURE ABBREVIATION
 ..F I=1:1:(6-$L($P(GMN0,U,5))) W "-"
 ..W "-----------------------------"
 ..W !,$P(GMN0,U,6)                               ;ACCESSION#
 ..;begin Y2K
 ..W ?16,$P(GMN0,U,4)                           ;DATE OF PROCEDURE ;IHS/CMI
 ..;end Y2K
 ..W ?27,"Res/Diag: ",$P(GMN0,U,7)              ;RESULTS/DIAGNOSIS
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,?27,"Provider: ",$E($P(GMN0,U,8),1,14)    ;PROVIDER
 ..W ?62,"Status: ",$P(GMN0,U,9)                ;STATUS
 ..S BWACCP=$P(GMN0,U,6)                        ;STORE AS PREVIOUS ACCESS#
 .;
 .;---> **********************
 .;---> DISPLAY NOTIFICATIONS
 .;---> IF PIECE 1=2 DISPLAY AS A NOTIFICATION.
 .I $P(GMN0,U)=2 D  Q
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..S BWACC=$P(GMN0,U,5)
 ..I BWACC'=Z D
 ...;begin Y2K
 ...W ! W:BWACC["NO ACC#" "-----------------" W ?16 ;IHS/CMI/LAB 17 to 1
 ...;end Y2K
 ...W "-------------< NOTIFICATIONS >---------------------------------"
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !
 ..W:BWACC'=BWACCP!(BWACC["NO ACC#") BWACC    ;ACCESSION#
 ..;begin Y2K
 ..W ?16,$P(GMN0,U,4)                            ;DATE OF PROCEDURE;IHS/CMI
 ..;end Y2K
 ..W ?27,$E($P(GMN0,U,6)_": "_$P(GMN0,U,7),1,53)    ;TYPE AND PURPOSE
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,?27,"Outcome: ",$E($P(GMN0,U,8),1,23)      ;OUTCOME OF NOTIFICATION
 ..W ?62,"Status: ",$P(GMN0,U,9)                 ;STATUS
 ..S (BWACCP,Z)=BWACC                         ;STORE AS PREVIOUS ACC#
 ..;
 ..;---> TWO VARIABLES (BWACCP & Z) USED ABOVE: "Z" SAYS "IF THIS NOTIF
 ..;---> ACC# IS NOT THE SAME AS THE LAST ONE, DISPLAY --<NOT>-- BANNER.
 ..;---> "BWACCP" SAYS "IF THIS NOTIF ACC# MATCHES THE LAST PROCEDURE'S
 ..;---> ACC#, DON'T DISPLAY THE ACCESSION#."
 ..;---> BOTH VARIABLES ARE RESET AFTER A FORMFEED, IN ORDER TO DISPLAY
 ..;---> ON THE NEW PAGE.
 .;
 .;---> **********************
 .;---> DISPLAY PAP REGIMENS
 .;---> IF PIECE 1=3 DISPLAY AS A PAP REGIMEN.
 .I $P(GMN0,U)=3 D  Q
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,"------------------------------< PAP REGIMEN CHANGE"
 ..W " >----------------------------"
 ..;begin Y2K
 .. D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !?9,"Began:" ;IHS/CMI/LAB - 10 to 9 Y2000
 ..W ?16,$P(GMN0,U,4)                           ;DATE OF REGIMEN ENTRY ;IHS
 ..;end Y2K
 ..W ?27,"Regimen: ",$P(GMN0,U,5)               ;PAP REGIMEN
 .;
 .;---> **********************        .;---> DISPLAY PREGNANCIES
 .;---> IF PIECE 1=4 DISPLAY AS A PREGNANCY.
 .I $P(GMN0,U)=4 D  Q
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !,"------------------------------< PREGNANCY STATUS"
 ..W " >------------------------------"
 ..;begin Y2K
 ..D CKP^GMTSUP Q:$D(GMTSQIT)
 ..W !?6,"Entered:" ;IHS/CMI/LAB - 8 to 6 patch 5 Y2000
 ..W ?15,$P(GMN0,U,4)                           ;DATE OF PREGNANCY EDIT. ;I
 ..;end Y2K
 ..W ?27,$P(GMN0,U,5)                           ;PREGNANT/NOT
 ..W:$P(GMN0,U,6)]"" ?50,"EDC: ",$P(GMN0,U,6)      ;EDC
 Q
FORMAT ; Format Line
 N DIWR,DIWL,DIWF,X
 S DIWL=3,DIWR=80-(GMICL+GMTAB)
 K ^UTILITY($J,"W")
 S X=COMMENT D ^DIWP
 Q
LINE ; Write Line
 D CKP^GMTSUP Q:$D(GMTSQIT)  W ?13,^UTILITY($J,"W",DIWL,GMTSLN,0),!
 Q
