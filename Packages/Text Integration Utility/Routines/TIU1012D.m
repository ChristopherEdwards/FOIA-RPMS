TIU1012D ;IHS/MSC/MGH - Data for Post-Install for TIU*1*1012;30-Apr-2013 16:20;DU
 ;;1.0;Text Integration Utilities;**1012**;Jun 20, 1997;Build 45
 ;
SETDATA ; Set more data for DDEFS (Basic data set in TIUEN1008)
 ; -- DDEF Number 1: REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- DDEF Number 2: APPROVED REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- DDEF Number 3: DENIED REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- Set Print Name, Owner, Status, Exterior Type,
 ;    National, for call to FILE^DIE:
 N TIUI S TIUI=0
 F TIUI=1:1:3 D
 . S ^XTMP("TIU1012","FILEDATA",TIUI,.03)=^XTMP("TIU1012","BASICS",TIUI,"NAME")
 . S ^XTMP("TIU1012","FILEDATA",TIUI,.06)="CLINICAL COORDINATOR"
 . S ^XTMP("TIU1012","FILEDATA",TIUI,.07)=$S(TIUI<6:"ACTIVE",1:"TEST")
 . S ^XTMP("TIU1012","FILEDATA",TIUI,.04)=$S(TIUI=2:"TITLE",TIUI=3:"TITLE",1:"DOCUMENT CLASS")
 . S ^XTMP("TIU1012","FILEDATA",TIUI,.13)=$S(TIUI>5:"NO",1:"YES")
 ; -- Set Parent:
 ; -- Set PIEN node = IEN of parent if known, or if not,
 ;    set PNUM node = DDEF# of parent
 ;    Parent must exist by the time this DDEF is created:
 S ^XTMP("TIU1012","DATA",1,"PIEN")=3
 S ^XTMP("TIU1012","DATA",1,"MENUTXT")="Request for Correction/Amendment of PHI"
 S ^XTMP("TIU1012","DATA",2,"PNUM")=1
 S ^XTMP("TIU1012","DATA",2,"MENUTXT")="Approved Request for Correction/Amendment of PHI"
 S ^XTMP("TIU1012","DATA",3,"PNUM")=1
 S ^XTMP("TIU1012","DATA",3,"MENUTXT")="Denied Request for Correction/Amendment of PHI"
 Q
