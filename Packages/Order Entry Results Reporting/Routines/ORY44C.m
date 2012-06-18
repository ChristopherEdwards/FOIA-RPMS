ORY44C ; SLC/PKS  OE/RR - Delete Personal lists for terminated users. ; [2/21/00 1:02pm]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**44**;Dec 17, 1997
 ;
 Q
 ;
EN ; Clean out Team Lists of type "Personal" with only one user when
 ;    user has been terminated.
 ;
 N DIK,DA,Y,ORLPTYPE,ORLPTEAM,ORLPCNT,ORLPFRST,ORLPUSER,ORLPTNM
 ;
 ; Order through each team in the file:
 S ORLPTEAM=0
 F  S ORLPTEAM=$O(^OR(100.21,ORLPTEAM)) Q:+ORLPTEAM=0  D
 .;
 .; Find out if team is "Personal" type:
 .I $P(^OR(100.21,ORLPTEAM,0),U,2)="P" D
 ..;
 ..; Check users currently on team:
 ..S ORLPFRST=""
 ..S ORLPCNT=0
 ..S ORLPUSER=0
 ..F  S ORLPUSER=$O(^OR(100.21,+ORLPTEAM,1,ORLPUSER)) Q:+ORLPUSER=0  D
 ...S ORLPCNT=ORLPCNT+1 ; Increment counter.
 ...I ORLPCNT=1 S ORLPFRST=ORLPUSER ; Get first user.
 ...I ORLPCNT>1 Q                   ; If more than one user, punt.
 ..;
 ..; Check for none or only one user:
 ..I ORLPCNT=0!'(ORLPFRST="") D
 ...;
 ...; Find out if user is terminated:
 ...I ORLPCNT=0!'($$ACTIVE^XUSER(+ORLPFRST)) D
 ....S ORLPTNM=$P(^OR(100.21,ORLPTEAM,0),U,1) ; Get name of Team List.
 ....;
 ....; Dump team if of type "Personal" (and only user is terminated):
 ....L +^OR(100.21,+ORLPTEAM):3     ; Handle file locking.
 ....S DIK="^OR(100.21,"
 ....S DA=+ORLPTEAM
 ....D ^DIK                         ; Delete the Team List.
 ....K DIK,DA,Y,%                   ; Clean up after call to DIK.
 ....L -^OR(100.21,+ORLPTEAM)       ; Unlock the file.
 ....D MES^XPDUTL("Personal Team "_ORLPTNM_" / IEN "_+ORLPTEAM_" deleted.") ; Installation message to run under Taskman.
 ....;
 ....; Call Consults package code to delete pointers there:
 ....D CLNLIST^GMRCTU(+ORLPTEAM,1)
 ;
 Q
 ;
