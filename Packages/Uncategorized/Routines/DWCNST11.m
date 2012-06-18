DWCNST11 ;NEW PROGRAM [ 07/07/1999  4:13 PM ]
 ; vjm 7/7/99 - this routine has been modified by vjm from Walz's
 ;              original rtn:  DWCNST11
 ;            - i left variable names as coded by DW.
 ;            - 'fixed' all naked references
 ;            - changed rtn to call OTHER^DWCNST02.  this allows
 ;              the switching of SERVICE.
 ;            - the OTHER sub-rtn is no longer called within this
 ;              rtn.  i left it intact in case it's called
 ;              else where within this 'consult system'.
 ;
 ;  Global information:
 ;    ^DWCNST03( = PIMC-CONSULTATION-OTHER-SVC file
 ;    ^DIC(49, = SERVICE/SECTION file
 ;
 ; WALZ's rtn comment:
 ;WRITTEN BY DAN WALZ PIMC TO PRINT THE NUMBER OF CONSULTS TO THE
 ;LOGON USERS'S SERVICE BY REQUESTED CONSULTANT
 ;
START ; start of rtn
 I '$D(DUZ) W !,"DUZ not set ABORTING..." H 3 D XIT Q
 I '$D(^VA(200,DUZ,0)) W "Unable to verify user. ABORTING..." H 3 D XIT Q
 S USR=$P(^VA(200,DUZ,0),"^",1)
 I '$D(^VA(200,DUZ,5)) W "Unable to locate SERVICE - ABORTING.." H 3 D XIT Q
 S SVCN=+$P($G(^VA(200,DUZ,5)),U)
 S SVC=$P(^DIC(49,SVCN,0),U,1)
 S AZXX("OTHER SRVS")=0
 S:$D(^DWCNST03("B",DUZ)) AZXX("OTHER SRVS")=1
 ;
 I AZXX("OTHER SRVS")=1 D OTHER^DWCNST02
 ; OTHER^DWCNST02   ; asks if user would like to switch SERVICES
 ;                  ; this call needs the SVCN & SVC variables
 ;
 I SVCN=0 W "Unable to locate Service - ABORTING.." H 3 D XIT Q
 Q:'$D(^DIC(49,SVCN,0))
 D ^DWSETSCR,^%AUCLS,HEAD,DTSEL G:$D(XIT) XIT
 D PRT
 D XIT
 Q
 ;---------------------------------------------------------------------
 ;
XIT K XIT,USR,IOP,SVCN,SVC,DIR,OSIE,SDT,EDT,AZXX
 D KILL^DWSETSCR
 Q
 ;
PRT K IOP
 S DIC=1966180,L=0,BY="'.01,+1,+16;S1",FR(1)=SDT,FR(2)=SVC,FR(3)="@",TO(1)=EDT,TO(2)=SVC,TO(3)="ZZZZZZZZZZ",FLDS="!.01"
 S DHD="PIMC Consults to "_SVC_" Service between "_$E(SDT,4,5)_"/"_$E(SDT,6,7)_"/"_$E(SDT,2,3)_" and "_$E(EDT,4,5)_"/"_$E(EDT,6,7)_"/"_$E(EDT,2,3)
 D EN1^DIP
 Q
 ;
HEAD W ?26,HI_"*****************************",!,?26,"*",?54,"*",!,?26,"* PIMC CONSULTATION REQUEST *",!,?26,"*",?54,"*",!,?26,"*",?28,"My Service Consult Counts",?54,"*",!,?26,"*",?54,"*",!,?26,"*****************************"_NO,!!!
 W IV_"Display Consult Counts for "_SVC_NO,!
 Q         
OTHER ;replace usual service with the entry in ^DWCNST03 1966195 
 S OSIE=+$O(^DWCNST03("B",DUZ,0))
 I '$D(^DWCNST03(OSIE,0)) Q
 ; vjm 7/7/99
 ;S SVCN=+$P(^(0),"^",2) I SVCN=0 K SVCN   ; old code
 S SVCN=+$P(^DWCNST03(OSIE,0),U,2) I SVCN=0 K SVCN
 Q
DTSEL S %DT="AE",%DT("A")="Enter STARTING date: ",%DT("B")="T-30"
 D ^%DT
 I Y<0 S XIT="" Q
 S SDT=+Y
 S %DT="AE",%DT("A")="Enter ENDING date: ",%DT("B")="T"
 D ^%DT
 I Y<0 S XIT="" Q
 S EDT=+Y
 I EDT<SDT W $C(7)," ?? - Invalid date pair!" G DTSEL
 Q
