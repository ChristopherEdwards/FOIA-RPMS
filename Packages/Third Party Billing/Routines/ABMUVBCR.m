ABMUVBCR ; IHS/SD/SDR - 3PB/UFMS View Batch Export Page Details   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; New routine to display Reconciliation Export page detail
 ; from Supervisor View Export Menu Option
EP ;EP
 Q
 ;
HD ;HEADER FOR RECONCIALTION PAGE DETAIL LISTING
 I $G(ABME("PG")),($E(IOST)="C") S DIR(0)="E" D ^DIR K DIR Q:Y=0
 S ABME("PG")=1
 W $$EN^ABMVDF("IOF")
 W !?20,$$EN^ABMVDF("HIN"),"***** UFMS EXPORT RECONCILIATION PAGE *****",?70,"Page: ",$$EN^ABMVDF("HIF"),ABME("PG")
 W !,$$EN^ABMVDF("HIN"),"LOCATION: ",$$EN^ABMVDF("HIF"),$P($G(^AUTTLOC(ABMLOC,0)),U,2)
 W !,$$EN^ABMVDF("HIN"),"EXPORT DATE: ",$$EN^ABMVDF("HIF"),ABME("BDATE")
 W !,$$EN^ABMVDF("HIN"),"FILE NAME: ",$$EN^ABMVDF("HIF"),ABME("FNAME")
 W !,ABME("EQ"),!
 Q
 ;
LOOP(ABMBDT,ABMLOC) ;EP -  For every User and Session Date, loop through the Cashiering
 ;   file and gather reconciliation info for one Export Date 
 ;
 ;         ;Enters with ABMBDT = Begin date = export ien  -- constant
 ;                      ABMLOC = Location pointer         -- constant
 ;
 K ABMC
 N ABMUSR,ABMSDT,ABMI
 D HD
 F ABMI=1,2 D
 .S ABMUS=0
 .F  S ABMUS=$O(^ABMUTXMT(ABMBDT,ABMI,ABMUS)) Q:+ABMUS=0  D
 ..S ABMUSR=$G(^ABMUTXMT(ABMBDT,ABMI,ABMUS,0))
 ..Q:+ABMUSR=0
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(^ABMUTXMT(ABMBDT,ABMI,ABMUSR,2,ABMSDT)) Q:+ABMSDT=0  D
 ...D PAGE(.ABMC,ABMSDT,ABMI_0)                ;Create local ABMC array
 S $P(ABMLINE,"-",80)="-"
 S ABMTRIBL=$P($G(^ABMDPARM(ABMLOC,1,4)),U,14) ;UFMS EXPORT FLAG
 D XSUM2^ABMURCON                              ;Display ABMC array
 Q
 ;
PAGE(ABMC,ABMSDT,ABMLOOP) ;EP; SET LOCAL ARRAY FOR EXTRACT PAGE DISPLAY
 ;
 N ABMSTR,ABMO,ABMUSER
 S ABM0=$G(^ABMUCASH(ABMLOC,ABMLOOP,ABMUSR,20,ABMSDT,0))
 I $P(ABM0,U,3)="" Q
 S ABMSTR=$P(ABM0,U,4)_U_$P(ABM0,U,3)     ;SESSION STATUS^SIGN OUT DATE
 S ABMUSER=$S(ABMLOOP=20:"POS",1:ABMUSR)  ;SUB "POS" FOR USER IEN 
 S ABMC(ABMSDT,ABMUSER,ABMSDT)=ABMSTR
 Q
PAUSE ;EP;
 Q:$E(IOST,1,2)'="C-"
 K DIR
P1 ;EP;
 W !
 S DIR(0)="E"
 S DIR("A")="Enter RETURN to Continue or '^' to exit"
 D ^DIR
 K DIR
 Q
