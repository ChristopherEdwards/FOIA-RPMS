BSDX18 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;
DELRUD(BSDXY,BSDXIEN) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("DELRU^BSDX18(.BSDXY,BSDXIEN)")
 Q
 ;
DELRU(BSDXY,BSDXIEN) ;EP
 ;Deletes entry BSDXIEN from RESOURCE USERS file
 ;Return recordset containing error message or "" if no error
 ;Called by BSDX DELETE RESOURCEUSER
 ;Test Line:
 ;D DELRU^BSDX18(.RES,99)
 ;
 N BSDXI,DIK,DA
 S BSDXI=0
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="I00020RESOURCEUSERID^I00020ERRORID"_$C(30)
 I '+BSDXIEN D ERR(BSDXI,BSDXIEN,70) Q
 I '$D(^BSDXRSU(BSDXIEN,0)) D ERR(BSDXI,BSDXIEN,70) Q
 ;Delete entry BSDXIEN
 S DIK="^BSDXRSU("
 S DA=BSDXIEN
 D ^DIK
 ;
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXIEN_"^"_"-1"_$C(30)_$C(31)
 Q
 ;
ADDRUD(BSDXY,BSDXVAL) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("ADDRU^BSDX18(.BSDXY,BSDXVAL)")
 Q
 ;
ADDRU(BSDXY,BSDXVAL) ;EP
 ;
 ;Called by BSDX ADD/EDIT RESOURCEUSER
 ;Add/Edit BSDX RESOURCEUSER entry
 ;BSDXVAL is sResourceUserID|sOverbook|sModifySchedule|ResourceID|UserID|sModifyAppointments|MASTEROVERBOOK
 ;If IEN=0 Then this is a new ResourceUser entry
 ; MASTEROVERBOOK = determines if this user has Master Overbook Authority  0="NO"; 1="YES"
 ;Test Line:
 ;D ADDRU^BSDX18(.RES,"sResourceUserID|sOverbook|sModifySchedule|sResourceID|sUserID|sModifyAppointments")
 ;
 N BSDXIENS,BSDXFDA,BSDXIEN,BSDXMSG,BSDX,BSDXOVB,BSDXMOD,BSDXI,BSDXUID,BSDXRID
 N BSDXRES,BSDXRSU,BSDXF,BSDXAPPT
 S BSDXY="^BSDXTMP("_$J_")"
 S BSDXI=0
 S ^BSDXTMP($J,BSDXI)="I00020RESOURCEID^I00020ERRORID"_$C(30)
 S BSDXIEN=$P(BSDXVAL,"|")
 I +BSDXIEN D
 . S BSDX="EDIT"
 . S BSDXIENS=BSDXIEN_","
 E  D
 . S BSDX="ADD"
 . S BSDXIENS="+1,"
 ;
 I '+$P(BSDXVAL,"|",4) D ERR(BSDXI,BSDXIEN,70) Q
 I '+$P(BSDXVAL,"|",5) D ERR(BSDXI,BSDXIEN,70) Q
 ;
 S BSDXRID=$P(BSDXVAL,"|",4) ;ResourceID
 S BSDXUID=$P(BSDXVAL,"|",5) ;UserID
 S BSDXRSU=0 ;ResourceUserID
 S BSDXF=0 ;flag
 ;If this is an add, check if the user is already assigned to the resource.
 ;If so, then change to an edit
 I BSDX="ADD" F  S BSDXRSU=$O(^BSDXRSU("AC",BSDXUID,BSDXRSU)) Q:'+BSDXRSU  D  Q:BSDXF
 . S BSDXRES=$G(^BSDXRSU(BSDXRSU,0))
 . S BSDXRES=$P(BSDXRES,U) ;ResourceID
 . S:BSDXRES=BSDXRID BSDXF=1
 I BSDXF S BSDX="EDIT",BSDXIEN=BSDXRSU,BSDXIENS=BSDXIEN_","
 ;
 S BSDXOVB=$P(BSDXVAL,"|",2)
 S BSDXOVB=$S(BSDXOVB="YES":1,1:0)
 S BSDXMOD=$P(BSDXVAL,"|",3)
 S BSDXMOD=$S(BSDXMOD="YES":1,1:0)
 S BSDXAPPT=$P(BSDXVAL,"|",6)
 S BSDXAPPT=$S(BSDXAPPT="YES":1,1:0)
 S BSDXMOB=$P(BSDXVAL,"|",7)
 S BSDXMOB=$S(BSDXMOB="YES":1,1:0) ;Master Overbook Authority
 ;
 S BSDXFDA(9002018.15,BSDXIENS,.01)=$P(BSDXVAL,"|",4) ;RESOURCE ID
 S BSDXFDA(9002018.15,BSDXIENS,.02)=$P(BSDXVAL,"|",5) ;USERID
 S BSDXFDA(9002018.15,BSDXIENS,.03)=BSDXOVB ;OVERBOOK
 S BSDXFDA(9002018.15,BSDXIENS,.04)=BSDXMOD ;MODIFY SCHEDULE
 S BSDXFDA(9002018.15,BSDXIENS,.05)=BSDXAPPT ;ADD, EDIT, DELETE APPOINMENTS
 S BSDXFDA(9002018.15,BSDXIENS,.06)=BSDXMOB ;Master Overbook Authority
 K BSDXMSG
 I BSDX="ADD" D
 . K BSDXIEN
 . D UPDATE^DIE("","BSDXFDA","BSDXIEN","BSDXMSG")
 . S BSDXIEN=+$G(BSDXIEN(1))
 E  D
 . D FILE^DIE("","BSDXFDA","BSDXMSG")
 ;S ^BSDXTMP($J,1)=$G(BSDXIEN)_"^-1"_$C(31)
 S ^BSDXTMP($J,1)=$C(31)
 Q
 ;
ERR(BSDXI,BSDXID,BSDXERR) ;Error processing
 S BSDXERR=BSDXERR+134234112 ;vbObjectError
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=BSDXID_"^"_BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
MADERR(BSDXMSG) ;
 W !,BSDXMSG
 Q
 ;
MADSCR(BSDXDUZ,BSDXZMGR,BSDXZMENU,BSDXZPROG) ;EP - File 200 screening code for MADDRU
 ;Called from DIR to screen for scheduling users
 I $D(^VA(200,BSDXDUZ,51,"B",BSDXZMENU)) Q 1
 I $D(^VA(200,BSDXDUZ,51,"B",BSDXZMGR)) Q 1
 I $D(^VA(200,BSDXDUZ,51,"B",BSDXZPROG)) Q 1
 Q 0
 ;
MADDRU ;EP -Command line utility to bulk-add users and set access rights IHS/HMW 20060420 **1**
 ;Main entry point
 ;
 N BSDX,BSDXZMENU,BSDXZMGR,BSDXZPROG,DIR
 ;
 ;INIT
 K ^TMP($J)
 S BSDXZMENU=$O(^DIC(19.1,"B","BSDXZMENU",0)) I '+BSDXZMENU D MADERR("Error: BSDXZMENU KEY NOT FOUND.") Q
 S BSDXZMGR=$O(^DIC(19.1,"B","BSDXZMGR",0)) I '+BSDXZMGR D MADERR("Error: BSDXZMGR KEY NOT FOUND.") Q
 S BSDXZPROG=$O(^DIC(19.1,"B","XUPROGMODE",0)) I '+BSDXZPROG D MADERR("Error: XUPROGMODE KEY NOT FOUND.") Q
 ;
 D MADUSR
 I '$D(^TMP($J,"BSDX MADDRU","USER")) D MADERR("Cancelled:  No Users selected.") Q
 D MADRES
 I '$D(^TMP($J,"BSDX MADDRU","RESOURCE")) D MADERR("Cancelled:  No Resources selected.") Q
 I '$$MADACC(.BSDX) ;D MADERR("Selected users will have no access to the selected clinics.")
 I '$$MADCONF(.BSDX) W ! D MADERR("--Cancelled") Q
 D MADASS(.BSDX)
 W ! D MADERR("--Done")
 ;
 Q
 ;
MADUSR ;Prompt for users from file 200 who have BSDXUSER key
 ;Store results in ^TMP($J,"BSDX MADDRU","USER",DUZ) array
 N DIRUT,Y,DIR
 S DIR(0)="PO^200:EMZ",DIR("S")="I $$MADSCR^BSDX18(Y,BSDXZMGR,BSDXZMENU,BSDXZPROG)"
 S Y=0
 K ^TMP($J,"BSDX MADDRU","USER")
 W !!,"-------Select Users-------"
 F  D ^DIR Q:$G(DIRUT)  Q:'Y  D
 . S ^TMP($J,"BSDX MADDRU","USER",+Y)=""
 Q
 ;
MADRES ;Prompt for Resources
 ;Store results in ^TMP($J,"BSDX MADDRU","RESOURCE",ResourceID) array
 N DIRUT,Y,DIR
 S DIR(0)="PO^9002018.1:EMZ"
 S Y=0
 K ^TMP($J,"BSDX MADDRU","RESOURCE")
 W !!,"-------Select Resources-------"
 F  D ^DIR Q:$G(DIRUT)  Q:'Y  D
 . S ^TMP($J,"BSDX MADDRU","RESOURCE",+Y)=""
 Q
 ;
MADACC(BSDX) ;Prompt for access level.
 ;Start with Overbook and go to read-only access.
 ;Store results in variables for:
 ;sOverbook, sModifySchedule, sModifyAppointments
 ;
 N DIRUT,Y,DIR,J
 W !!,"-------Select Access Level-------"
 S Y=0
 F J="MODIFY","OVERBOOK","WRITE","READ" S BSDX(J)=1
 S DIR(0)="Y"
 ;
 S DIR("A")="Allow users to Modify Clinic Availability"
 D ^DIR
 Q:$G(DIRUT) 0
 Q:Y 1
 S BSDX("MODIFY")=0
 ;
 S DIR("A")="Allow users to Overbook the selected clinics"
 D ^DIR
 Q:$G(DIRUT) 0
 Q:Y 1
 S BSDX("OVERBOOK")=0
 ;
 S DIR("A")="Allow users to Add, Edit and Delete appointments in the selected resources"
 D ^DIR
 Q:$G(DIRUT)
 Q:Y 1
 S BSDX("WRITE")=0
 ;
 S DIR("A")="Allow users to View appointments in the selected resources"
 D ^DIR
 Q:$G(DIRUT)
 Q:Y 1
 S BSDX("READ")=0
 ;
 Q 0
 ;
MADCONF(BSDX) ;Confirm selections
 N DIR,DIRUT,Y
 S DIR(0)="Y"
 W !!,"-------Confirm Selections-------"
 I BSDX("READ")=0 D
 . S DIR("A")="Are you sure you want to remove all access to these clinics for these users"
 E  D
 . W !,"Selected users will be assigned the following access:"
 . W !,"Modify clinic availability:  ",?50,BSDX("MODIFY")
 . W !,"Overbook Appointments:  ",?50,BSDX("OVERBOOK")
 . W !,"Add, Edit and Delete Appointments:  ",?50,BSDX("WRITE")
 . W !,"View Clinic Appointments:  ",?50,BSDX("READ")
 . S DIR("A")="Are you sure you want to assign these access rights to the selected users"
 D ^DIR
 Q:$G(DIRUT) 0
 Q:$G(Y) 1
 Q 0
 ;
MADASS(BSDX) ;
 ;Assign access level to selected users and resources
 ;Loop through selected users
 ;. Loop through selected resources
 ; . . If an entry in ^BSDXRSU for this user/resource combination exists, then
 ; . . . S sResourceUserID = to it
 ; . . Else
 ; . . . S sResourceUserID = 0
 ; . . Call MADFILE
 N BSDXU,BSDXR,BSDXRUID,BSDXVAL
 S BSDXU=0
 F  S BSDXU=$O(^TMP($J,"BSDX MADDRU","USER",BSDXU)) Q:'+BSDXU  D
 . S BSDXR=0 F  S BSDXR=$O(^TMP($J,"BSDX MADDRU","RESOURCE",BSDXR)) Q:'+BSDXR  D
 . . S BSDXRUID=$$MADEXST(BSDXU,BSDXR)
 . . S BSDXVAL=BSDXRUID_"|"_BSDX("OVERBOOK")_"|"_BSDX("MODIFY")_"|"_BSDXR_"|"_BSDXU_"|"_BSDX("WRITE")
 . . I +BSDXRUID,BSDX("READ")=0 D MADDEL(BSDXRUID)
 . . Q:BSDX("READ")=0
 . . D MADFILE(BSDXVAL)
 . . Q
 . Q
 Q
 ;
MADDEL(BSDXRUID) ;
 ;Delete entry BSDXRUID from BSDX RESOURCE USER file
 N DIK,DA
 Q:'+BSDXRUID
 Q:'$D(^BSDXRSU(BSDXRUID))
 S DIK="^BSDXRSU("
 S DA=BSDXRUID
 D ^DIK
 Q
 ;
MADFILE(BSDXVAL) ;
 ;
 ;Add/Edit BSDX RESOURCEUSER entry
 ;BSDXVAL is sResourceUserID|sOverbook|sModifySchedule|ResourceID|UserID|sModifyAppointments
 ;If sResourceUserID=0 Then this is a new ResourceUser entry
 ;
 N BSDXIENS,BSDXFDA,BSDXIEN,BSDXMSG,BSDX,BSDXOVB,BSDXMOD,BSDXI,BSDXUID,BSDXRID
 N BSDXRES,BSDXRSU,BSDXF,BSDXAPPT
 S BSDXIEN=$P(BSDXVAL,"|")
 I +BSDXIEN D
 . S BSDX="EDIT"
 . S BSDXIENS=BSDXIEN_","
 E  D
 . S BSDX="ADD"
 . S BSDXIENS="+1,"
 ;
 I '+$P(BSDXVAL,"|",4) D MADERR("Error in MADFILE^BSDX18: No Resource ID") Q
 I '+$P(BSDXVAL,"|",5) D MADERR("Error in MADFILE^BSDX18: No User ID") Q
 ;
 S BSDXRID=$P(BSDXVAL,"|",4) ;ResourceID
 S BSDXUID=$P(BSDXVAL,"|",5) ;UserID
 S BSDXRSU=0 ;ResourceUserID
 S BSDXF=0 ;flag
 ;If this is an add, check if the user is already assigned to the resource.
 ;If so, then change to an edit
 I BSDX="ADD" F  S BSDXRSU=$O(^BSDXRSU("AC",BSDXUID,BSDXRSU)) Q:'+BSDXRSU  D  Q:BSDXF
 . S BSDXRES=$G(^BSDXRSU(BSDXRSU,0))
 . S BSDXRES=$P(BSDXRES,U) ;ResourceID
 . S:BSDXRES=BSDXRID BSDXF=1
 I BSDXF S BSDX="EDIT",BSDXIEN=BSDXRSU,BSDXIENS=BSDXIEN_","
 ;
 S BSDXOVB=$P(BSDXVAL,"|",2)
 S BSDXMOD=$P(BSDXVAL,"|",3)
 S BSDXAPPT=$P(BSDXVAL,"|",6)
 ;
 S BSDXFDA(9002018.15,BSDXIENS,.01)=$P(BSDXVAL,"|",4) ;RESOURCE ID
 S BSDXFDA(9002018.15,BSDXIENS,.02)=$P(BSDXVAL,"|",5) ;USERID
 S BSDXFDA(9002018.15,BSDXIENS,.03)=BSDXOVB ;OVERBOOK
 S BSDXFDA(9002018.15,BSDXIENS,.04)=BSDXMOD ;MODIFY SCHEDULE
 S BSDXFDA(9002018.15,BSDXIENS,.05)=BSDXAPPT ;ADD, EDIT, DELETE APPOINMENTS
 K BSDXMSG
 I BSDX="ADD" D
 . K BSDXIEN
 . D UPDATE^DIE("","BSDXFDA","BSDXIEN","BSDXMSG")
 . S BSDXIEN=+$G(BSDXIEN(1))
 E  D
 . D FILE^DIE("","BSDXFDA","BSDXMSG")
 Q
 ;
MADEXST(BSDXU,BSDXR) ;
 ;Returns BSDX RESOURCE USER ID
 ;if there is a BSDX RESOURCE USER entry for
 ;user BSDXU and resource BSDXR
 ;Otherwise, returns 0
 ;
 N BSDXID,BSDXFOUND,BSDXNOD
 I '$D(^BSDXRSU("AC",BSDXU)) Q 0
 S BSDXID=0,BSDXFOUND=0
 F  S BSDXID=$O(^BSDXRSU("AC",BSDXU,BSDXID)) Q:'+BSDXID  D  Q:BSDXFOUND
 . S BSDXNOD=$G(^BSDXRSU(BSDXID,0))
 . I +BSDXNOD=BSDXR S BSDXFOUND=BSDXID
 . Q
 Q BSDXFOUND
