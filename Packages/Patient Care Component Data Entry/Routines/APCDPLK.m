APCDPLK ; IHS/CMI/LAB - LOOKUP PROBLEM ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;CALLED FROM APCD INPUT TEMPLATES
 ; Problem based on a problem # that is entered through data entry.
 S U="^",APCDPERR=""
 I APCDPR="?" W !,"Enter a Problem Number in the form XXXXNN, where XXXX is the 2-4 digit location",!," abbreviation and NN is a problem number from 1 to 999.99." S APCDPERR=1 Q
 I APCDPR="??" W !,"Enter a Problem number in the form XXXXNN where XXXX is the 2-4 digit location",!," abbreviation and NN is problem number.  The available loc. abbrevs are:" D LL S APCDPERR=1 Q
 S:APCDPR["#" APCDPR=$P(APCDPR,"#")_$P(APCDPR,"#",2)
 S APCDPPL="" F APCDPI=1:1:$L(APCDPR) Q:$E(APCDPR,APCDPI)?1N  S APCDPPL=APCDPPL_$E(APCDPR,APCDPI)
 I APCDPPL="" W !,"No facility code has been entered." S APCDPERR=1 Q
 S APCDPLOC="",APCDPLOC=$O(^AUTTLOC("D",APCDPPL,APCDPLOC)) I APCDPLOC="" W !,"NO Location Abbreviation - PLEASE NOTIFY YOUR SUPERVISOR" S APCDPERR=1 Q
 S APCDPN=$P(APCDPR,APCDPPL,2) I APCDPN<0!(APCDPN>999.99) W !,"Invalid problem number" S APCDPERR=1 Q
 S APCDPN=" "_$E("000",1,(3-$L($P(APCDPN,"."))))_$P(APCDPN,".")_"."_$P(APCDPN,".",2)_$E("00",1,(2-$L($P(APCDPN,".",2))))
 I '$D(^AUPNPROB("AA",APCDPAT,APCDPLOC,APCDPN)) W !,"No Problem Number ",APCDPN," on file for this patient for location ",$P(^AUTTLOC(APCDPLOC,0),U,2),"." S APCDPERR=1 Q
 S APCDPDFN="",APCDPDFN=$O(^AUPNPROB("AA",APCDPAT,APCDPLOC,APCDPN,APCDPDFN))
 S APCDPDFN="`"_APCDPDFN
 K APCDPLOC,APCDPN,APCDPI,APCDPN,APCDPPL,APCDPL,APCDPSUB
 Q
LL ;
 N DIC,DA,D,DZ S DIC="^AUTTLOC(",DIC(0)="E",D="D",DZ="??" D DQ^DICQ K Y,DIC,D
 Q
