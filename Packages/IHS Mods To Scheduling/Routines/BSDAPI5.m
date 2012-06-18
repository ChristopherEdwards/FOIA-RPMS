BSDAPI5 ; cmi/anch/maw - PCC API FOR RPMS (con't)[ 03/24/2005  1:44 PM ]
 ;;5.3;PIMS;**1009**;MAY 28, 2004
 ;
 ;cmi/anch/maw 06/10/2008 PATCH 1009 requirement 58 added logic to display visits and let user select
 ;
SELECT(BSDT,BSDV) ; SELECT EXISTING VISIT
 W !!,"PATIENT: ",$P(^DPT(BSDT("PAT"),0),U)," has one or more VISITs on this date.",!,"If one of these is your visit, please select it",!
 K BSDV1 S (BSDVC,BSDVA,BSDVX)="",BSDV1=0 F  S BSDV1=$O(BSDV(BSDV1)) Q:BSDV1'=+BSDV1  D
 . S BSDVX=$G(^AUPNVSIT(BSDV1,0)),BSDVX11=$G(^AUPNVSIT(BSDV1,11)) D WRITE
 S BSDVC=BSDVC+1 W !,BSDVC,"  Create New Visit",!
 K DIR
 S DIR(0)="N^1:"_BSDVC,DIR("A")="Select" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K BSDTMP("CALLER") S BSDIN("FORCE ADD")=1 Q  ;kill caller variable so force add happens
 I BSDVC=Y K BSDTMP("CALLER") S BSDIN("FORCE ADD")=1 Q  ;kill caller variable so force add happens
 S BSDR("VIEN")=BSDVX1(Y)
 K BSDT,APCDALVR
 Q
 ;
WRITE ; WRITE VISITS FOR SELECT
 S BSDVC=BSDVC+1,BSDVX1(BSDVC)=BSDV1
 S BSDVLT=$P(+BSDVX,".",2),BSDVLT=$S(BSDVLT="":"<NONE>",$L(BSDVLT)=1:BSDVLT_"0:00 ",1:$E(BSDVLT,1,2)_":"_$E(BSDVLT,3,4)_$E("00",1,2-$L($E(BSDVLT,3,4)))_" ")
 S BSDVLOC=""
 I $P(BSDVX,U,6),$D(^AUTTLOC($P(BSDVX,U,6),0)) S BSDVLOC=$P(^(0),U,7),BSDVLOC=BSDVLOC_$E("    ",1,4-$L(BSDVLOC))
 S:BSDVLOC="" BSDVLOC="...."
 W !,BSDVC,"  TIME: ",BSDVLT,"LOC: ",BSDVLOC," TYPE: ",$P(BSDVX,U,3)," CAT: ",$P(BSDVX,U,7)," CLINIC: ",$S($P(BSDVX,U,8)]"":$E($P(^DIC(40.7,$P(BSDVX,U,8),0),U),1,8),1:"<NONE>") D
 .W ?57,"DEC: ",$S($P(BSDVX,U,9):$P(BSDVX,U,9),1:0),$S($P(BSDVX11,U,3)]"":" VCN:"_$P(BSDVX11,U,3),1:"")
 .I $P(BSDVX,U,22) W !?3,"Hospital Location: ",$P($G(^SC($P(BSDVX,U,22),0)),U)
 .S BSDVPRV=$$PRIMPROV^APCLV(BSDV1,"N") I BSDVPRV]"" W !?3,"Provider on Visit: ",BSDVPRV
 K BSDVLT,BSDVLOC,BSDVPRV
 Q
 ;
