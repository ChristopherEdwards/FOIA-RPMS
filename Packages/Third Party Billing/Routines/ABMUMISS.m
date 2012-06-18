ABMUMISS ; IHS/SD/SDR - 3PB/UFMS Cashiering Options   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - abm*2.6
 ; Check for bills that were missed in session
UFMSCK ;
 W !!,"Will now check for any ""missing"" claims/bills..."
 ;
 ;ABMFD contains open date/time of session; start there and
 ;go thru approved bills looking for this user
 ;
 S ABMPAR=0
 S ABMPFLG=0
 F  S ABMPAR=$O(^BAR(90052.05,ABMPAR)) Q:'ABMPAR  D  Q:ABMPFLG=1
 .I $D(^BAR(90052.05,ABMPAR,DUZ(2))) D
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,3)'=ABMPAR
 ..S ABMPFLG=1  ;set flag to stop looking; this is our parent
 S ABMSITE=0
 F  S ABMSITE=$O(^BAR(90052.05,ABMPAR,ABMSITE)) Q:'ABMSITE  D
 .I $D(^BAR(90052.05,ABMPAR,ABMSITE)) D
 ..Q:$P($G(^BAR(90052.05,ABMPAR,ABMSITE,0)),U,3)'=ABMPAR
 ..I ABMPAR=ABMSITE S ABMPARNT=ABMPAR
 ..S ABMP("SATS",ABMSITE)=""
 ;
 S ABMFFLG=0
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(ABMP("SATS",DUZ(2))) Q:'DUZ(2)  D
 .Q:$P($G(^ABMDPARM(DUZ(2),1,4)),U,15)'=1
 .K ABMLOC
 .S ABMASDT=(ABMFD-.000001)
 .F  S ABMASDT=$O(^ABMDBILL(DUZ(2),"AP",ABMASDT))  Q:'ABMASDT  D
 ..S ABMP("BDFN")=0
 ..F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AP",ABMASDT,ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ...I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,4)'=DUZ Q
 ...I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)=901 Q  ;don't add if POS claim
 ...D ADDBENTR^ABMUCUTL("ABILL",ABMP("BDFN"))
 ...I ($P(Y,U,3)'="") D
 ....W !?5,"Bill number: ",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)," added to session"
 ....S ABMFFLG=1
 I ABMFFLG=0 W !,"No ""missing"" bills found"
 S DUZ(2)=ABMHOLD
 W !!
 K ABMPARNT,ABMP("SATS")
 Q
