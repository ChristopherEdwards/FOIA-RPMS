RAIPST12 ;HIRMFO/BNT - Post-init functions (patch twelve) ;5/20/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**12**;Mar 16, 1998
 ;
MSG(ENTRY,FILE,ERR) ; display a status message pertaining to the addition
 ; of entries to files: 869.2, 870, 771 & 101.  Display a status message
 ; when items are added to the Protocol (101) file.
 ; Variable list:
 ; ENTRY-> value of the .01 field for a particular file (60 chars max)
 ; FILE -> file # where the data will be added
 ; ERR  -> err message? 1 if yes, else null
 N RACNT,RATXT,STRING,WORDS S RACNT=1,RATXT(RACNT)=" "
 S:$G(ERR) STRING="* ERROR * "
 S STRING=$G(STRING)_"Adding '"_$E(ENTRY,1,40)_"' to the "
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
ACTIVE() ; return 'ACTIVE', for ACTIVE/INACTIVE (2) field in file
 ; 771
 Q "ACTIVE"
CLIENT() ; return 'CLIENT (SENDER)', for CLIENT/SERVER (400.03) field
 ; in file 869.2
 Q "CLIENT (SENDER)"
N() ; return 'NO', for various fields in file 101
 Q "NO"
SLISTN() ; return 'SINGLE LISTENER', for CLIENT/SERVER (400.03) field
 ; in file 869.2
 Q "SINGLE LISTENER"
TCP() ; return 'TCP' for LLP TYPE (.02) field in file 869.2
 Q "TCP"
US() ; return 'US', for COUNTRY CODE (7) field in file 771
 Q "US"
Y() ; return 'YES', for PERMANENT (400.04) field in file 869.2
 Q "YES"
PKG() ; Return the name of the package
 Q "RADIOLOGY/NUCLEAR MEDICINE"
PROID() ; Return the Processing ID data  ;IHS/ITSC/CLS 04/25/2003 replaced “PRODUCTION” with “”
 Q ""
TSTMP() ; Timestamp the protocol entry point with current date/time (in $H format)
 Q $$FMTH^XLFDT($$NOW^XLFDT())
