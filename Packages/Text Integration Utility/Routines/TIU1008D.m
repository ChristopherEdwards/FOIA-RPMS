TIU1008D ;IHS/MSC/MGH - Data for Post-Install for TIU*1*1008;28-Jan-2011 15:42;DU
 ;;1.0;Text Integration Utilities;**1008**;Jun 20, 1997;Build 15
 ;
SETDATA ; Set more data for DDEFS (Basic data set in TIUEN1008)
 ; -- DDEF Number 1: DISCHARGE INSTRUCTIONS DC
 ; -- DDEF Number 2: E-COPY DC
 ; -- DDEF Number 3: DISCHARGE INSTRUCTIONS DOC
 ; -- DDEF Number 4: E-COPY DISCHARGE INSTR RECEIVED
 ; -- DDEF Number 5: E-COPY DISCHARGE INSTR NOT RECEIVED
 ; -- Set Print Name, Owner, Status, Exterior Type,
 ;    National, for call to FILE^DIE:
 N TIUI S TIUI=0
 F TIUI=1:1:5 D
 . S ^XTMP("TIU1008","FILEDATA",TIUI,.03)=^XTMP("TIU1008","BASICS",TIUI,"NAME")
 . S ^XTMP("TIU1008","FILEDATA",TIUI,.06)="CLINICAL COORDINATOR"
 . S ^XTMP("TIU1008","FILEDATA",TIUI,.07)=$S(TIUI<6:"ACTIVE",1:"TEST")
 . S ^XTMP("TIU1008","FILEDATA",TIUI,.04)=$S(TIUI=3:"TITLE",TIUI=4:"TITLE",TIUI=5:"TITLE",1:"DOCUMENT CLASS")
 . S ^XTMP("TIU1008","FILEDATA",TIUI,.13)=$S(TIUI>5:"NO",1:"YES")
 . I TIUI=1 S ^XTMP("TIU1008","FILEDATA",TIUI,6)="D ENTRY^BTIUPRPN"
 ; -- Set Parent:
 ; -- Set PIEN node = IEN of parent if known, or if not,
 ;    set PNUM node = DDEF# of parent
 ;    Parent must exist by the time this DDEF is created:
 S ^XTMP("TIU1008","DATA",1,"PIEN")=3
 S ^XTMP("TIU1008","DATA",1,"MENUTXT")="Discharge Instructions"
 S ^XTMP("TIU1008","DATA",2,"PIEN")=3
 S ^XTMP("TIU1008","DATA",2,"MENUTEXT")="E-Copy"
 S ^XTMP("TIU1008","DATA",3,"PNUM")=1
 S ^XTMP("TIU1008","DATA",3,"MENUTXT")="Discharge Instructions"
 S ^XTMP("TIU1008","DATA",4,"PNUM")=2
 S ^XTMP("TIU1008","DATA",4,"MENUTXT")="E-copy discharge instr received"
 S ^XTMP("TIU1008","DATA",5,"PNUM")=2
 S ^XTMP("TIU1008","DATA",5,"MENUTXT")="E-copy discharge instr not received"
 Q
