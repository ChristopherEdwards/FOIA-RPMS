DGMTOFA ;ALB/CAW/AEG - Future Appointments who will require MT ;8/24/92
 ;;5.3;Registration;**3,50,182,326,426**;Aug 13, 1993
 ;
EN ; 
 I '$$RANGE^DGMTUTL("F") G ENQ
 I '$$DIV^DGMTUTL G ENQ
 I '$$CLINIC^DGMTUTL G ENQ
 ;I '$$LETTER G ENQ
 W !! S %ZIS="PMQ" D ^%ZIS I POP G ENQ
 I '$D(IO("Q")) D MAIN G ENQ
 S Y=$$QUE
ENQ ;
 D:'$D(ZTQUEUED) ^%ZISC
 K DFN,DGAPT,DGBEG,DGCLN,DGDATE,DGDFN,DGDIV,DGEND,DGFLG,DGINFO,DGLINE,DGLST,DGMT,DGMT1,DGPAGE,DGSTOP,DGTMP,DGTMP1,DGTMP2,DGMTYPT,DGYN,DIW,DIWF,DIWR,DIWT,DN,SDFORM,SDLET,VA,VAERR,VAUTC,VAUTD,^TMP("DGMTO",$J),^TMP("DGMTL",$J)
 Q
 ;
QUE() ; -- que job
 ; return: did job que [ 1|yes   0|no ]
 ;
 K ZTSK,IO("Q")
 S ZTDESC="Future Appt. w/ Means Test",ZTRTN="MAIN^DGMTOFA"
 F X="DGBEG","DGEND","DGYN","DGMTYPT","SDFORM","SDLET","VAUTC","VAUTD","VAUTC(","VAUTD(" S ZTSAVE(X)=""
 D ^%ZTLOAD W:$D(ZTSK) "   (Task: ",ZTSK,")"
 Q $D(ZTSK)
 ;
MAIN ; 
 ;
 K ^TMP("DGMTO",$J)
 I VAUTC=1,VAUTD=1 S DGCLN=0 F  S DGCLN=$O(^SC(DGCLN)) Q:'DGCLN  I $P(^(DGCLN,0),U,3)="C" D CLN1
 I VAUTC=1,VAUTD=0 S DGDIV="" F  S DGDIV=$O(VAUTD(DGDIV)) Q:'DGDIV  S DGCLN=0 F  S DGCLN=$O(^SC(DGCLN)) Q:'DGCLN  I $P(^SC(DGCLN,0),U,3)="C",$P(^SC(DGCLN,0),U,15)=DGDIV D CLN1
 S DGCLN="" F  S DGCLN=$O(VAUTC(DGCLN)) Q:'DGCLN  D CLN1
 D ^DGMTOFA1
 D CLOSE^DGMTUTL
 Q
 ;
CLN1 ; Loop through appointments
 ;
 S DGDATE=DGBEG-.1,DGLST=DGEND+.9
 F  S DGDATE=$O(^SC(DGCLN,"S",DGDATE)) Q:'DGDATE!(DGDATE>DGLST)  S DGAPT=0 F  S DGAPT=$O(^SC(DGCLN,"S",DGDATE,1,DGAPT)) Q:'DGAPT  S DGDFN=$P(^SC(DGCLN,"S",DGDATE,1,DGAPT,0),U),DGPAT=$G(^DPT(DGDFN,"S",DGDATE,0)) D
 .Q:DGCLN'=+DGPAT
 .Q:$$DOM(DGDFN,DGDATE)
 .Q:"^N^NA^C^CA^PC^PCA^"[(U_$P(DGPAT,U,2)_U)
 .D MT
 Q
MT ; Is patient going to need to complete a MT/Copay by appt?
 S DGMT=$$LST^DGMTU(DGDFN,$P(DGDATE,"."),DGMTYPT),DGMT1=$P($G(^DGMT(408.31,+DGMT,0)),U,3) I DGMT1,"^3^10^"'[("^"_DGMT1_"^") D
 .S X1=$P(DGMT,U,2),X2=365 D C^%DTC I $P(DGDATE,".")<X,$S(DGMT1=1:0,DGMT1=9:0,1:1) Q
 .;Check to see if Cat C/Pend Adj agreed to pay with test date >10/5/99
 .I $P(DGMT,U,2)>2991005,$P($G(^DGMT(408.31,+DGMT,0)),U,11)=1,((DGMT1=6)!(DGMT1=2)) Q
 .;Check to see if Cat C, declined to provide income info but agreed to
 .;pay -- no date restrictions on these types.
 .I $G(DGMT1)=6,+$P($G(^DGMT(408.31,+DGMT,0)),U,14),+$P($G(^DGMT(408.31,+DGMT,0)),U,11) Q
 .; checking for future means test based on DT
 .N DGNXTMT
 .S DGNXTMT=$O(^IVM(301.5,"AE",DGDFN,DT))
 .I 'DGNXTMT S DGNXTMT=""
 .S ^TMP("DGMTO",$J,$S(+$P(^SC(DGCLN,0),U,15):$P(^(0),U,15),1:$O(^DG(40.8,0))),$P(^SC(DGCLN,0),U),$P(^DPT(DGDFN,0),U),DGDATE)=DGDFN_U_$P(DGMT,U,1,4)_U_$P(DGPAT,U,16)_U_DGNXTMT,^TMP("DGMTL",$J,$P(^DPT(DGDFN,0),U),DGDFN)=""
 Q
 ;
LETTER() ;
 ;   Input - none
 ;  Output - DGYN - yes/no
 ;
 N %
LTR W !!,"Do you want to generate letters" S %=2 D YN^DICN
 ;I %=1 D START^DGMTLTR S DGYN=$S('$D(DGFLG):1,1:0)
 I %=2 S DGYN=0
 I %=0 W !!,"Enter 'Y'es to generate letters from the listing or",!,"Enter 'N'o to produce the listing, but not the letters." G LTR
 Q $D(DGYN)
 ;
DOM(DFN,DGT) ; Screen out dom patient
 ;         Input:   DFN - Patient IEN
 ;                  DGT - Date of visit
 ;
 N Y,DGI,DGXFR0,DGA1,DGINP
 S Y=0
 D ^DGINPW I DG1 I $P(^DG(43,1,0),U,21),$D(^DIC(42,+DG1,0)),$P(^(0),U,3)="D" S Y=1
 Q Y
