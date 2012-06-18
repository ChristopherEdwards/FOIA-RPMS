AMHPLK ; IHS/CMI/LAB - LOOKUP PROBLEM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;CALLED FROM AMH INPUT TEMPLATES
 ; Problem based on a problem # that is entered through data entry.
 S U="^",AMHPERR=""
 I AMHPR="?" W !,"Enter a Problem Number." S AMHPERR=1 Q
 I AMHPR="??" W !,"Enter a Problem Number." S AMHPERR=1 Q
 S AMHPN=AMHPR I AMHPN<1!(AMHPN>999.99) W !,"Invalid problem number" S AMHPERR=1 Q
 S AMHPN=" "_$E("000",1,(3-$L($P(AMHPN,"."))))_$P(AMHPN,".")_"."_$P(AMHPN,".",2)_$E("00",1,(2-$L($P(AMHPN,".",2))))
 I '$D(^AMHPPROB("AA",AMHPAT,AMHPN)) W !,"No Problem Number ",AMHPN," on file for this patient" S AMHPERR=1 Q
 S AMHPDFN="",AMHPDFN=$O(^AMHPPROB("AA",AMHPAT,AMHPN,AMHPDFN))
 S AMHPDFN="`"_AMHPDFN
 K AMHPLOC,AMHPN,AMHPI,AMHPN,AMHPPL,AMHPL,AMHPSUB
 Q
LL ;
 N DIC,DA,D,DZ S DIC="^AUTTLOC(",DIC(0)="E",D="D",DZ="??" D DQ^DICQ K Y,DIC,D
 Q
