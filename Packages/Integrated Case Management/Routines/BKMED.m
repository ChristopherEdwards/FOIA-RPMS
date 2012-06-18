BKMED ;PRXM/HC/CLT - SET EDITED BY FIELDS IN 90451 ; 11 Mar 2005  12:27 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
 ;
EN ;EP - SET THE NODE called by POST^BKMVAUD - Update Date/Time of Last Edit for File 90451
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ;  DUZ - User IEN from File 200
 ; Output variables:
 ;  Record updated in File 90451
 ; Initialize variables
 N IENS
 I $G(BKMIEN)'="",$G(BKMREG)'="",$G(DUZ)'="" D
 .; Set the data via FileMan API
 .K FDA
 .S IENS="+1,"_BKMREG_","_BKMIEN_","
 .;S %DT="ST",X="N" D ^%DT
 .;S FDA(90451.05,IENS,.01)=Y     ; DATE/TIME
 .S FDA(90451.05,IENS,.01)=$$NOW^XLFDT()     ; DATE/TIME
 .S FDA(90451.05,IENS,1)=DUZ     ; EVENT USER (File 200)
 .D UPDATE^DIE("","FDA","")
 .K FDA,%DT,X,Y
 Q
 ;
 ;
