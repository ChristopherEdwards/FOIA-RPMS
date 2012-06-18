BHSPSO7A ; IHS/MSC/MGH - Health summary selected for medications ;27-Oct-2009 13:39;MGH
 ;;1.0;HEALTH SUMMARY COMONENTS;**3**;March 17,2006
 ;This component allows a user to use selected drugs. The routine will include any
 ;drugs in the VA generic finding for the drugs included
 ; External References
 ;   DBIA     60  ^PSOHCSUM
 ;   DBIA    522  ^PS(55,
 ;   DBIA  10035  ^DPT(  file #2
 ;   DBIA   3136  ^PS(59.7,
 ;   DBIA  10011  ^DIWP
 ;
MAIN ; OP Rx HS Component
 N ECD,NDF,DRUG,GENERIC,GMTSEL,GMR,IX,PSOBEGIN,PSOACT,GMX,GMTOP,MEDSEG
 S PSOBEGIN=$S(GMTS2'=9999999:(9999999-GMTS2),1:"")
 I PSOBEGIN="" S PSOACT=1 K PSOBEGIN
 K ^TMP("BHS",$J)
 Q:$O(GMTSEG(GMTSEGN,50,0))'>0
 S GMTSEL=0
 F  S GMTSEL=$O(GMTSEG(GMTSEGN,50,GMTSEL)) Q:'GMTSEL  D
 .S DRUG=$G(GMTSEG(GMTSEGN,50,GMTSEL))
 .S MEDSEG(DRUG)=""
 .S NDF=$P($G(^PSDRUG(DRUG,"ND")),U,1)
 .I NDF'="" S GENERIC(NDF)=""
 I '$D(^PS(55,DFN,"P")),'$D(^("ARC")) Q
 I '$O(^PS(55,DFN,"P",0)),$D(^PS(55,DFN,"ARC")) D CKP^GMTSUP Q:$D(GMTSQIT)  W "Patient Has Archived OP Prescriptions",!
 D SEL^BHSPOS(.MEDSEG) I '$D(^TMP("BHS",$J)) Q
 S GMTSLO=GMTSLO+3
 S (GMTOP,GMX,IX)=0
 F  S IX=$O(^TMP("BHS",$J,IX)) Q:IX'>0  S GMR=$G(^(IX,0)) D WRT
 S GMTSLO=GMTSLO-3
 K ^TMP("BHS",$J),^UTILITY($J,"W")
 Q
WRT ; Writes OP Pharmacy Segment Record
 N ID,LFD,X,MI,NL,CF,GMD,GMV,GMI,DIWL,DIWR,DIWF,GMSIG,GUI S GUI=$$HF^GMTSU
 S ID=$P(GMR,U),LFD=$P(GMR,U,2),ECD=$P(GMR,U,11),CF=$P(GMR,U,10)
 ;   Don't display when issue date is after To Date
 Q:+$G(GMRANGE)&(ID>(9999999-GMTS1))
 F GMV="ID","LFD","ECD" S X=@GMV D REGDT4^GMTSU S @GMV=X K X
 S NL=0,DIWL=1,DIWR=73,DIWF="" K ^UTILITY($J,"W")
 F  S NL=$O(^TMP("BHS",$J,IX,NL)) Q:NL'>0  D
 . S X=$G(^TMP("BHS",$J,IX,NL,0)) D ^DIWP
 S GMD=$P($P(GMR,U,4),";",2)
 D CKP^GMTSUP Q:$D(GMTSQIT)
 D:GMTSNPG!(GMX'>0) HEAD W:'GMTOP ! S GMTOP=0 W $P($P(GMR,U,3),";",2)
 W !,?22,$P(GMR,U,6),?35,$P($P(GMR,U,5),";"),?39,$P(GMR,U,7),?54,ID,?65,LFD,?76,"("_$P(GMR,U,8)_")",!
 S GMX=1,GMI=0,GMSIG=1
 F  S GMI=$O(^UTILITY($J,"W",DIWL,GMI)) Q:GMI'>0!$D(GMTSQIT)  D
 . D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HEAD
 . S MI=$G(^UTILITY($J,"W",DIWL,GMI,0))
 . W:GMSIG=1 ?2,"SIG: " S:GMSIG=1 GMSIG=0 W ?7,MI,! S GMTOP=0
 D CKP^GMTSUP Q:$D(GMTSQIT)  D:GMTSNPG HEAD W ?4,"Provider: ",$E(GMD,1,22) W:CF ?37,"Cost/Fill: $",$J(CF,6,2)
 I "EC"[$P($P(GMR,U,5),";"),ECD]"" W ?57,"Exp/Can Dt: "_ECD
 W ! S GMTOP=0
 Q
HEAD ; Prints Header
 ;   Only write the next line when there is data
 S GMTOP=1
 I GMX'>0,$D(^DPT(DFN,.1)),^(.1)]"",+($P($G(^PS(59.7,1,40.1)),"^")) D CKP^GMTSUP Q:$D(GMTSQIT)  W "Outpatient prescriptions are cancelled 72 hours after admission",!
 D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"Drug....................................",?65,"Last",!
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W ?22,"Rx #",?34,"Stat",?39,"Qty",?54,"Issued",?65,"Filled",?76,"Rem"
 W:$Y'>(IOSL-GMTSLO)!(+($G(GUI))>0) !
 Q
