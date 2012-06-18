RA12PST2 ;HIRMFO/CRT - Post-init functions (patch seventeen) ;5/20/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**17**;Mar 16, 1998
 ;
MSG(ENTRY,FILE,ERR) ; display a status message pertaining to the addition
 ; of entries to files: 870 & 101.  Display a status message
 ; when items are added to the Protocol (101) file.
 ; Variable list:
 ; ENTRY-> value of the .01 field for a particular file (60 chars max)
 ; FILE -> file # where the data will be added
 ; ERR  -> err message? 1 if yes, else null
 N RACNT,RATXT,STRING,WORDS S RACNT=1,RATXT(RACNT)=" "
 S:$G(ERR) STRING="* ERROR * "
 S STRING=$G(STRING)_"Adding/Editing '"_$E(ENTRY,1,40)_"' in the "
 S STRING=$G(STRING)_$E($P($G(^DIC(FILE,0)),"^"),1,40)_" file."
 S:$G(ERR)&($D(DIERR)) STRING=$G(STRING)_" "_$E($G(^TMP("DIERR",$J,1,"TEXT",1)),1,115) ; display the 1st error text encountered! (there may be more errors. Because of possible string length error display only the first error.)
 S:$G(ERR) STRING=$G(STRING)_" IRM should investigate."
 F  D  Q:STRING=""
 . S WORDS=$L($E(STRING,1,71)," ")
 . S RACNT=RACNT+1,RATXT(RACNT)=$P(STRING," ",1,WORDS)
 . S STRING=$P(STRING," ",WORDS+1,999)
 . Q
 D MES^XPDUTL(.RATXT)
 Q
CLIENT() ; return 'CLIENT (SENDER)', for CLIENT/SERVER (400.03) field
 ; in file 870
 Q "CLIENT (SENDER)"
N() ; return 'NO', for various fields in file 101
 Q "NO"
SLISTN() ; return 'SINGLE LISTENER', for CLIENT/SERVER (400.03) field
 ; in file 870
 Q "SINGLE LISTENER"
TCP() ; return 'TCP' for LLP TYPE (2) field in file 870
 Q "TCP"
Y() ; return 'YES', for PERSISTENT (400.04) field in file 870
 Q "YES"
PKG() ; Return the name of the package
 Q "RADIOLOGY/NUCLEAR MEDICINE"
PROID() ; Delete the Processing ID field
 Q "@"
ACKTO() ; Return the ACK timeout for CLIENT(SENDER)s
 Q 300
TSTMP() ; Timestamp the protocol entry point with current date/time (in $H format)
 Q $$FMTH^XLFDT($$NOW^XLFDT())
 ;
DELITEM ; Delete Item multiple from RA event driver protocols
 N RAA,RAB,RARR,RAX,RAX1,RAY,RAZ
 F RAX="RA REG","RA EXAMINED","RA CANCEL","RA RPT" D
 .S RARR(RAX)=$$FIND1^DIC(101,,"X",RAX)
 .S RARR(RAX_" 2.3")=+$$FIND1^DIC(101,,"X",RAX_" 2.3")
 .Q
 F RAX="RA TALKLINK TCP SERVER RPT","RA PSCRIBE TCP SERVER RPT","RA VOICE TCP SERVER RPT" D
 .S RARR(RAX)=+$$FIND1^DIC(101,,"X",RAX)
 .Q
 ; remove RA subscriber type items
 S RAX="" F  S RAX=$O(RARR(RAX)) Q:RAX=""  D
 .S RAX1=+$G(RARR(RAX)) Q:'RAX1  ; must be a protocol ien
 .S:'$D(^ORD(101,RAX1,10,0)) ^ORD(101,RAX1,10,0)="^101.01PA^^0"
 .S RAY=0 F  S RAY=$O(^ORD(101,RAX1,10,RAY)) Q:'RAY  D
 ..S RAZ=+$G(^ORD(101,RAX1,10,RAY,0)) ; get the item ien
 ..S RAA=$$GET1^DIQ(101,RAZ,.01,"I") ; protocol name
 ..S RAB=$$GET1^DIQ(101,RAZ,4,"I") ; protocol type
 ..Q:$E(RAA,1,2)'="RA"!(RAB'="S")  ; must be a RA subscriber item type
 ..S RA101(101.01,RAY_","_RAX1_",",.01)="@" D FILE^DIE("K","RA101")
 ..Q
 .Q
 Q
