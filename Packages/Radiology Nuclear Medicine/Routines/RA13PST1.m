RA13PST1 ;HIRMFO/CRT - Post-init number one (patch thirteen) ;5/19/99
VERSION ;;5.0;Radiology/Nuclear Medicine;**13**;Mar 16, 1998
 ;
EN1 ; Add entry to the LABEL PRINT FIELDS (78.7) file
 ;
 N RAFDA,RAFDAIEN
 I '$D(^RA(78.7,"B","NAME OF PATIENT (FIRST LAST)")) D
 . S RAFDA(78.7,"+1,",.01)="NAME OF PATIENT (FIRST LAST)"
 . S RAFDA(78.7,"+1,",2)="P"
 . S RAFDA(78.7,"+1,",3)="Name:"
 . S RAFDA(78.7,"+1,",4)="JOHN JONES"
 . S RAFDA(78.7,"+1,",5)="RANM"
 . D MSG("NAME OF PATIENT (FIRST LAST)",78.7),UPDATE^DIE("E","RAFDA","RAFDAIEN")
 . I '$D(^RA(78.7,"B","NAME OF PATIENT (FIRST LAST)")) D MSG("NAME OF PATIENT (FIRST LAST)",78.7,1) Q
 . S ^RA(78.7,RAFDAIEN(1),"E")="S RANM=$TR($P($P(RAY0,""^""),"","",2)_"" ""_$P($P(RAY0,""^""),"",""),"".,"","""")"
 ;
 D BMES^XPDUTL(" ") ; greater readability
 Q
MSG(ENTRY,FILE,ERR) ; display a status message pertaining to the addition
 ; of entries to files: 78.7, 
 ;
 ; Variable list:
 ; ENTRY-> value of the .01 field for a particular file (60 chars max)
 ; FILE -> file # where the data will be added
 ; ERR  -> err message? 1 if yes, else null
 ;
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
