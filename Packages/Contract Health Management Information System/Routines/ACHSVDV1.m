ACHSVDV1 ; IHS/ITSC/JVK - SELECT CONTRACT NUMBER ; [ 10/15/2004  3:02 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**11,15**;JUNE 11, 2001
 ;ITSC/SET/JVK ACHS*3.1*11 MODIFIED TO DISPLAY MEDICARE PROVIDER INFO
 ;ACHS*3.1*15 OIT.IHS.FCJ CHANGED TO ACCOMODATE THE 18 CHAR CONTRACT NUMBER
 ;
A4 ;EP
 G A6:'$D(^AUTTVNDR(ACHSPROV,"CN"))
 K ACHSCTFL,ACHSRQFL,ACHSPAFL,ACHSBPFL
 ;
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Contract Information","NO","","","",2)
 G END^ACHSVDV:$D(DTOUT),A1^ACHSVDV:$D(DUOUT),A6:'Y
 S ACHSACO="L",P=ACHSPROV,A("DISPLAY")=1,ACHSCTFL=""
 D L^ACHSVDV1
A6 ;
 G:ACHSRT("RQ")<0 A7
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Rate Quotation Information","NO","","","",2)
 G END^ACHSVDV:$D(DTOUT),A1^ACHSVDV:$D(DUOUT),A7:'Y
 S ACHSAGTP="RQ",ACHSRQFL=""
 D AGRDSP^ACHSVDV2
A7 ;
 G:'$D(ACHSRT("PA")) A8
 S Y=$$DIR^XBDIR("Y","Want to see Vendor Agreement Information","NO","","","",2)
 G END^ACHSVDV:$D(DTOUT),A1^ACHSVDV:$D(DUOUT),A8:'Y
 S ACHSAGTP="PA",ACHSPAFL=""
 D AGRDSP^ACHSVDV2
A8 ;
 G:'$D(ACHSRT("BPA")) A9
 S Y=$$DIR^XBDIR("Y","Want to see Vendor BPA Information","NO","","","",2)
 G END^ACHSVDV:$D(DTOUT),A1^ACHSVDV:$D(DUOUT),A9:'Y
 S ACHSAGTP="BPA",ACHSBPFL=""
 D AGRDSP^ACHSVDV2
A9 ;
 S Y=$$DIR^XBDIR("Y","Want to see Prior FY Payments for this Vendor","NO","","","",2)
 G A1^ACHSVDV:$D(DTOUT)!$D(DUOUT)!('Y)
 D ^ACHSVDV2
 I $$DIR^XBDIR("E","Press RETURN...","","","","",1)
 G A1^ACHSVDV
 ;
L ;EP
 S E=9999999-DT,(S,C,L)=""
 I '$D(ACHSACO) S ACHSACO=""
L1 ;
 S S=$O(^AUTTVNDR(ACHSPROV,"E",S))
 G L3:S=""
 S N=""
L2 ;
 S N=$O(^AUTTVNDR(ACHSPROV,"E",S,N))
 G L1:N="",L2:'$D(^AUTTVNDR(ACHSPROV,"CN",N,0))
 ;ACHS*3.1*15 OIT.IHS.FCJ CHANGED TO ACCOMODATE THE 18 CHAR CONTRACT NUMBER
 ;S I=$P(^AUTTVNDR(ACHSPROV,"CN",N,0),U),C=C+1,L=N_U_S_U_I I ACHSACO["L" D SBT:C=1 W !,$J(C,4),?4,$J($P(^(0),U),15) S D=$P(^(0),U,2,3) D SBD S C(C)=N
 S I=$P(^AUTTVNDR(ACHSPROV,"CN",N,0),U),C=C+1,L=N_U_S_U_I I ACHSACO["L" D SBT:C=1 W !,$J(C,2),?3,$J($P(^(0),U),18) S D=$P(^(0),U,2,3) D SBD S C(C)=N
 I ACHSACO["F",C=F G L3
 I $Y>24 K DIR S DIR(0)="E" D ^DIR Q:Y=0  K DIR D SBT
 G L2
 ;
L3 ;
 G END:'$D(^XUSEC("ACHSZMGR",DUZ)),NEW:'$D(^AUTTVNDR(ACHSPROV,"CN")),NEW:$P(^AUTTVNDR(ACHSPROV,"CN",0),U,4)<1!(A("DISPLAY"))!(+C<1)
 W !!,"Which one: "
 D READ^ACHSFU
 G END:$D(DUOUT)
 I Y?1"?".E W !!?3,"Enter 1 thru ",C G L3
 I Y="" G NEW
 I Y'?1N.N!(Y>C) W !!,"Enter 1 thru ",C G L3
 S DA=C(Y)
END ;
 K C,N,S,ACHSCTFL,ACHSRQFL,ACHSPAFL,ACHSBPFL
 Q
 ;
SBD ;
 W ?22,$$FMTE^XLFDT($P(D,U)),?35,$$FMTE^XLFDT($P(D,U,2)),?49,$E($P(^AUTTVNDR(ACHSPROV,"CN",N,0),U,5),1,30)
 Q
 ;
SBT ;EP
 W @IOF,!!?5,"Contract Number",?22,"Begin Date",?35,"Ending Date",?49,"Description of Service",!?5,"---------------",?22,"------------",?35,"------------",?49,"-------------------------"
 Q
 ;
NEW ;
 W:+C<1 !!,"No Contracts on file."
 I $D(ACHSCTFL) S DA="" G END
 W !!,"Want to Enter a New Contract?  NO// "
 D READ^ACHSFU
 G END:$D(DUOUT)
 S Y=$E(Y_"N"),Y=$$UP^XLFSTR(Y)
 I Y?1"?".E D YN^ACHS G NEW
 I Y=""!(Y?1"N".E) S DA="" G END
 I Y'?1"Y".E D YN^ACHS G NEW
NEW1 ;
 W !!,"Enter CONTRACT NUMBER: "
 D READ^ACHSFU
 G NEW:$D(DUOUT)
 I Y?1"?".E W !!,"Enter New Contract Number " G NEW1
 G NEW:Y=""
 S:'$D(^AUTTVNDR(ACHSPROV,"CN",0)) ^(0)="^9999999.1112^"
 S DA(1)=ACHSPROV,X=Y,DIC="^AUTTVNDR("_ACHSPROV_",""CN"",",DIC(0)="ELMQZ"
 D ^DIC
 G NEW:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_ACHSPROV_",""CN"",",DA(1)=ACHSPROV,DR="1;2;4;3"
 D ^DIE
 K DIE,DA
 G END
 ;
MP ;EP -- ITSC/SET/JVK ACHS*3.1*11 FIND MEDICARE PROVIDER INFO
 W @IOF D MPDSP
 S (ACHSMP,CT)=0
 F I=1:1  S ACHSMP=$O(^AUTTVNDR(ACHSPROV,"MP",ACHSMP)) Q:ACHSMP'>0  D
 .S ACHSDSP(I)=^AUTTVNDR(ACHSPROV,"MP",ACHSMP,0)
 .I ACHSDSP(I)'="" S CT=CT+1 S ACHSMPN=$P(ACHSDSP(I),U),ACHSBDT=$P(ACHSDSP(I),U,3),ACHSEDT=$P(ACHSDSP(I),U,4),ACHSDES=$P(ACHSDSP(I),U,2)
 .I $D(ACHSDES) S ACHSDES=$$EXTSET^XBFUNC(9999999.112303,2,ACHSDES)
 .W ?2,CT,?6,$G(ACHSMPN),?23,$$FMTE^XLFDT($G(ACHSBDT)),?37,$$FMTE^XLFDT($G(ACHSEDT)),?51,$G(ACHSDES),!
 W:CT=0 !!,?6,"No Medicare Numbers listed.",! G ASK1
 I CT>0 G ASK1
 Q
 ;
MPDSP ;DISPLAY MEDICARE PROVIDER INFO
 W !!,"Item",?6,"Medicare Number",?23,"Begin Date",?37,"End Date",?51,"Description",!,"----",?6,"---------------",?23,"------------",?37,"------------",?51,"-------------------------",!
 Q
 ;
ASK1 ;     
 S Y=$$DIR^XBDIR("Y","Want to add Medicare Information","NO","","","",2)
 G END:$D(DUOUT),ASK2:'Y
 I Y G MPADD
ASK2 ;
 S Y=$$DIR^XBDIR("Y","Want to edit Medicare Information","NO","","","",2)
 G END:$D(DUOUT),END:'Y
 I Y G MPEDIT
MPADD ;
 W !!,"Enter the Medicare NUMBER: "
 D READ^ACHSFU
 G END:$D(DUOUT)
 I Y?1"?".E W !!,"Enter New Number " G MPADD
 S:'$D(^AUTTVNDR(ACHSPROV,"MP",0)) ^(0)="^9999999.112303^"
 S DA(1)=ACHSPROV,X=Y,DIC="^AUTTVNDR("_ACHSPROV_",""MP"",",DIC(0)="ELMQZ"
 D ^DIC
 G MPADD:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_ACHSPROV_",""MP"",",DA(1)=ACHSPROV,DR="2;3;4"
 D ^DIE
 K DIE,DA
 G END
 ;
MPEDIT ;
 W !!,"Which item: "
 D READ^ACHSFU
 G END:$D(DUOUT)
 I Y?1"?".E W !!?3,"Enter 1 thru ",CT G MPEDIT
 I Y="" G MPEDIT
 I Y'?1N.N!(Y>CT) W !!,"Enter 1 thru ",CT G MPEDIT
 S X=$P(ACHSDSP(Y),U)
 S DA(1)=ACHSPROV,DIC="^AUTTVNDR("_ACHSPROV_",""MP"",",DIC(0)="ELMQZ"
 D ^DIC
 G MPADD:Y=-1
 S DA=+Y
 W !
 S DIE("NO^")="",DIE="^AUTTVNDR("_ACHSPROV_",""MP"",",DA(1)=ACHSPROV,DR=".01;2;3;4"
 D ^DIE
 K DIE,DA
 G END
 G END:'Y
 ;ITSC/SET/JVK ACHS*3.1*11 END FOR ADDITIONS FOR MEDICARE PROV. NO.
