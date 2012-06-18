AMHPPLK ; IHS/CMI/LAB - LOOKUP PCC PROBLEM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;CALLED FROM AMH INPUT TEMPLATES
 ; Problem based on a problem # that is entered through data entry.
 S U="^",AMHPERR=""
 I AMHPR="?" W !,"Enter a Problem Number in the form XXXXNN, where XXXX is the 2-4 digit location",!," abbreviation and NN is a problem number from 1 to 999.99." S AMHPERR=1 Q
 I AMHPR="??" W !,"Enter a Problem number in the form XXXXNN where XXXX is the 2-4 digit location",!," abbreviation and NN is problem number.  The available loc. abbrevs are:" D LL S AMHPERR=1 Q
 S:AMHPR["#" AMHPR=$P(AMHPR,"#")_$P(AMHPR,"#",2)
 S AMHPPL="" F AMHPI=1:1:$L(AMHPR) Q:$E(AMHPR,AMHPI)?1N  S AMHPPL=AMHPPL_$E(AMHPR,AMHPI)
 I AMHPPL="" W !,"No facility code has been entered." S AMHPERR=1 Q
 S AMHPLOC="",AMHPLOC=$O(^AUTTLOC("D",AMHPPL,AMHPLOC)) I AMHPLOC="" W !,"NO Location Abbreviation - PLEASE NOTIFY YOUR SUPERVISOR" S AMHPERR=1 Q
 S AMHPN=$P(AMHPR,AMHPPL,2) I AMHPN<1!(AMHPN>999.99) W !,"Invalid problem number" S AMHPERR=1 Q
 S AMHPN=" "_$E("000",1,(3-$L($P(AMHPN,"."))))_$P(AMHPN,".")_"."_$P(AMHPN,".",2)_$E("00",1,(2-$L($P(AMHPN,".",2))))
 I '$D(^AUPNPROB("AA",AMHPAT,AMHPLOC,AMHPN)) W !,"No Problem Number ",AMHPN," on file for this patient for location ",$P(^AUTTLOC(AMHPLOC,0),U,2),"." S AMHPERR=1 Q
 S AMHPDFN="",AMHPDFN=$O(^AUPNPROB("AA",AMHPAT,AMHPLOC,AMHPN,AMHPDFN))
 S AMHPDFN="`"_AMHPDFN
 K AMHPLOC,AMHPN,AMHPI,AMHPN,AMHPPL,AMHPL,AMHPSUB
 Q
LL ;
 N DIC,DA,D,DZ S DIC="^AUTTLOC(",DIC(0)="E",D="D",DZ="??" D DQ^DICQ K Y,DIC,D
 Q
