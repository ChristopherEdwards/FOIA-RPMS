AGEVST ; cmi/flag/maw - AGEV Scheduled Visit Task ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;this routine will go through file 44 and task eligibility
 ;requests for the following day's scheduled visits.
 ;
MAIN ;-- this is the main routine driver
 D ASK
 Q:Y<0
 S AGEVTB=$P((^INTHU(0)),U,3)
 D TASK
 G EOJ:AGEVYN
 D LOOP
 Q
 ;
TASK ;-- if they want to task it
 S DIR(0)="Y",DIR("A")="Would You like to Queue this "
 S DIR("B")="Y"
 D ^DIR
 S AGEVYN=+Y
 Q:AGEVYN<1
 K DIR
 F CIMTSKV="AGEVEXT","AGEVBDT","AGEVEDT","AGEVOELG","AGEVTB" S ZTSAVE(CIMTSKV)=""
 S ZTIO=""
 S ZTRTN="LOOP^AGEVST",ZTDESC="Envoy Eligibility Scheduled Visit Task"
 D ^%ZTLOAD
 Q
 ;
ASK ;-- get the beginning and end dates for search
 S %DT="AEP",%DT("A")="Enter Begin Date:  ",%DT("B")=$$FMTE^XLFDT(DT)
 D ^%DT
 Q:Y<0
 S AGEVBDT=Y-.0001
 K %DT
 S %DT="AEP",%DT("A")="Enter End Date:  ",%DT("B")=$$FMTE^XLFDT(DT)
 D ^%DT
 Q:Y<0
 S AGEVEDT=Y+.9999
 K %DT
 S DIR(0)="Y"
 S DIR("A")="Would you like to override previous eligibility checks "
 D ^DIR
 S AGEVOELG=+Y
 K DIR
 Q
 ;
LOOP ;-- loop through file 44 and get scheduled visits
 D ^XBKVAR
 S AGEVEXT=1
 S AGEVVDA=0
 F  S AGEVVDA=$O(^SC(AGEVVDA)) Q:'AGEVVDA  D
 . S AGEVDT=AGEVBDT
 . F  S AGEVDT=$O(^SC(AGEVVDA,"S",AGEVDT)) Q:'AGEVDT!(AGEVDT>AGEVEDT)  D
 .. S AGEVIEN=0
 .. F  S AGEVIEN=$O(^SC(AGEVVDA,"S",AGEVDT,1,AGEVIEN)) Q:'AGEVIEN  D
 ... S AGEVSPAT=$P($G(^SC(AGEVVDA,"S",AGEVDT,1,AGEVIEN,0)),U)
 ... S AGEVCDT=$P($G(AGEVDT),".")
 ... Q:$$ECHK^AGEVC(AGEVSPAT,AGEVCDT,$G(AGEVOELG))
 ... D E1^AGEVC(AGEVCDT)
 ... D AL^AGEVC(AGEVSPAT,$G(AGEVVST))
 ...Q
 ..Q
 .Q
 D EOJ
 Q
 ;
CD(DT) ;-- get date to check
 S X1=DT,X2=+1
 D C^%DTC
 Q X
 ;
EOJ ;-- kill variables
 D CNT
 D BUL
 D EN^XBVK("AGEV")
 KILL BGDT,EGDT,VDA
 Q
 ;
CNT ;-- count records created      
 H 300
 S AGEVCTR=0
 S AGEVTE=$P($G(^INTHU(0)),U,3)
 S AGEVCTR=$G(AGEVTE)-$G(AGEVTB)
 Q
 ;
BUL ;-- send a bulletin with the counts
 Q:$G(AGEVYN)
 S XMB="BHLX 270 REQUEST COUNT",XMB(3)=$G(AGEVCTR)
 S XMB(1)=$P($$FMTE^XLFDT(AGEVBDT),"@")
 S XMB(2)=$P($$FMTE^XLFDT(AGEVEDT),"@")
 D ^XMB
 Q
