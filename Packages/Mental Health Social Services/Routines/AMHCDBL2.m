AMHCDBL2 ; IHS/CMI/LAB - backload pcc visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;backfill BH with CDMIS Data
CS ;EP
 ;create MHSS record first
 S AMHCDST=0 F  S AMHCDST=$O(^ACDCS("C",AMHIEN,AMHCDST)) Q:AMHCDST'=+AMHCDST  D CS1
 Q
CS1 ;
 ;get activity code from acdcs
 S A=$P(^ACDCS(AMHCDST,0),U,2) I A="" W !,"Client service, no activity code. ",AMHIEN," ",$P(^ACDCS(AMHCDST,0),U,2)," is ien of activity"  Q
 S A=$P($G(^ACDSERV(A,0)),U,2) I A="" W !,"Client service, no activity code to map. ",AMHIEN," ",$P(^ACDCS(AMHCDST,0),U,2)," is ien of activity" Q
 S AMHACT=$$ACONV(A)
 I AMHACT="" W !,"No conversion of activity code on client service. ",AMHIEN," code is ",A Q
 S AMHDAY=$P(^ACDCS(AMHCDST,0),U) I $L(AMHDAY)=1 S AMHDAY="0"_AMHDAY
 S AMHDATE=$E(AMHDATE,1,5)_AMHDAY
 K DIC S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".02///C;.03///^S X=DT;.19////"_DUZ_";.33////R;.28////"_DUZ_";.22///A;.21///^S X=DT"
 K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Error creating Behavioral Health Record!!  Deleting Record.",! Q
 S AMHR=+Y,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 S AMHTIME=$P($G(^ACDCS(AMHCDST,0)),U,4) S AMHTIME=AMHTIME*60 I 'AMHTIME S AMHTIME=1
 S DIE="^AMHREC(",DA=AMHR,DR=".04////"_AMHLOC_";.05////"_AMHDCOM_";.06///"_AMHACT_";.07///2;.08////"_AMHPAT_";.09///1;1101///"_AMHCOMP_";.12///"_AMHTIME_";.25///43;.32///"_AMHTC_";1105///"_AMHCOMT,DIE="^AMHREC(" D ^DIE
 I $D(Y) W !!,"error editing MHSS Record entry ",AMHIEN," ",AMHMIEN
 ;get initial entry and file activity time and mhss staging tool entry, get problem for later use
 S AMHSTR0=^ACDCS(AMHCDST,0)
 K AMHPROB
 ;S X=$O(^TMP($J,"ACDCONV",AMHPAT,0)) Q:X=""  S AMHPROB(1)=^TMP($J,"ACDCONV",AMHPAT,X)
 ;I X="" W !,"could not find problem code for this client service...SKIPPING  ",AMHCDST,! Q
 D GETVSITS,CHKFIN
 I 'AMHY W !!,AMHIEN," ",AMHCDST,"  no initial to get problems." Q
 S AMHINI=$O(^ACDIIF("C",AMHY,0))
 S AMHSTR0=^ACDIIF(AMHINI,0)
 S AMHPROB(1)=$P(AMHSTR0,U)_U_$P(^ACDPROB($P(AMHSTR0,U),0),U)_U_$P(^ACDPROB($P(AMHSTR0,U),0),U,2)
 D PROBCONV
 D ^XBFMK
 ;now create pov/provider
 S X=AMHPROV,DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR_";.04///P",DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02
 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 I Y=-1 W !!,"Creating Primary Provider entry failed!!!",$C(7),$C(7) H 2
 D ^XBFMK
 S AMHX=0 F  S AMHX=$O(^ACDCS(AMHCDST,1,AMHX)) Q:AMHX'=+AMHX  D
 .S AMHPRV1=$P($G(^ACDCS(AMHCDST,1,AMHX,0)),U)
 .Q:AMHPRV1=""
 .S X=AMHPRV1,DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR_";.04///P",DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02
 .K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating Secondary Prov entry for Client Service entry failed!!!","  ",$P(^VA(200,AMHPRV1,0),U)," ",AMHCDST H 2
 S AMHX=0 F  S AMHX=$O(AMHPROB(AMHX)) Q:AMHX'=+AMHX  D
 .S X=$P(AMHPROB(AMHX),U,5),DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR_";.04///"_$P(AMHPROB(AMHX),U,2),DIC="^AMHRPRO(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.01 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 .I Y=-1 W !!,"Creating POV entry failed!!!",$C(7),$C(7) H 2
 .D ^XBFMK
 ;S AMHACTN=1
 ;D PCCLINK^AMHCDBL
 Q
PROBCONV ;
 S X=0 F  S X=$O(AMHPROB(X)) Q:X'=+X  S %=$$PCONV($P(AMHPROB(X),U,3)),$P(AMHPROB(X),U,4)=%,$P(AMHPROB(X),U,5)=$O(^AMHPROB("B",%,0))
 Q
GETVSITS ; EP - GET CDMIS VISITS FOR THIS CLIENT
 K ^TMP("AMHCONV",$J,"VISITS")
 S AMHVCNT=0,Y=0
 F  S Y=$O(^ACDVIS("D",AMHPAT,Y)) Q:'Y  S X=^ACDVIS(Y,0) I $P($G(^("BWP")),U)=AMHLOC D
 .  S ^TMP("AMHCONV",$J,"VISITS",$P(X,U),Y)=X,AMHVCNT=AMHVCNT+1
 .  Q
 Q
CHKFIN ; EP - CHECK FOR INITIAL CONTACT TYPE
 S AMHX="",(AMHY,Y)=0
 F  S AMHX=$O(^TMP("AMHCONV",$J,"VISITS",AMHX)) Q:AMHX=""  S Y=0 F  S Y=$O(^TMP("AMHCONV",$J,"VISITS",AMHX,Y)) Q:'Y  S X=^(Y) I $P(X,U,2)=AMHCOMPI,$P(X,U,7)=AMHCOMTI,$P(X,U,4)="IN" S AMHY=Y Q
 Q
ACONV(P) ;
 I P=7 Q 41
 I P="ACU" Q 23
 I P=19 Q 23
 I P=6 Q 23
 I P=11 Q 23
 I P=23 Q 23
 I P="ACO" Q 12
 I P="DUI" Q 12
 I P="AOT" Q 12
 I P=14 Q 34
 I P=16 Q 31
 I P=15 Q 61
 I P=13 Q 14
 I P=3 Q 14
 I P=4 Q 14
 I P=2 Q 13
 I P=1 Q 12
 I P="MAS" Q 23
 I P=20 Q 23
 I P="MMO" Q 23
 I P=10 Q 34
 I P=12 Q 34
 I P="PH" Q 26
 I P=10 Q 23
 I P=22 Q 23
 I P=17 Q 25
 I P=21 Q 23
 I P=9 Q 14
 I P=8 Q 14
 I P=5 Q 82
 I P=18 Q 38
 I P="URS" Q 23
 I P="CNOS1" Q 12
 I P="CNOS2" Q 12
 I P="CNOS3" Q 12
 I P="MIA" Q 23
 I P="OTH" Q 23
 Q 23
PCONV(P) ;
 I P=17 Q 89
 I P=1 Q 29
 I P=18 Q 94
 I P=30 Q 43
 I P=2 Q 30
 I P=42 Q 23
 I P=16 Q 3
 I P=36 Q 42.2
 I P=40 Q 44.2
 I P=32 Q 43.2
 I P=12 Q 59
 I P=14 Q 79
 I P=60 Q 312.31
 I P=61 Q 26
 I P=44 Q 302.6
 I P=53 Q 80
 I P=3 Q "305.90"
 I P=13 Q 88
 I P=11 Q 56
 I P=15 Q 5
 I P=55 Q 3
 I P="MIA" Q 8
 I P=37 Q 47
 I P=41 Q 48
 I P=33 Q 49
 I P=19 Q 82
 I P=20 Q 26
 I P=34 Q 42.1
 I P=38 Q 44.1
 I P=49 Q 66
 I P=35 Q 42.3
 I P=39 Q 44.3
 I P=31 Q 43.3
 I P=43 Q 302.9
 I P=50 Q 62
 I P=10 Q 304.83
 I P=9 Q 62
 I P=47 Q 40
 I P=48 Q 41
 I P=46 Q 41
 I P=45 Q 39
 I P=29 Q "305.10"
 Q 4
