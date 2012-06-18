INHOP ;JMB; 13 Sep 95 09:24; Front End for Interface Monitoring Reports 
 ;;3.01;BHL IHS Interfaces with GIS;**14**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;Tags called under option: Background Process Control Menu
 ; Tags - 1 (VS Report)
 ;        2 (QSIZE)
 ;        3 (TOP)
 ;        4 (BPM)
VS D EN1(1,"EN^INHOV1","INHO VS") Q         ;Verify Status Report
QSIZ D EN1(2,"ENZTSK^INHOQR1","INHO QSIZ") Q  ;Queue Size Report
TOP D EN1(3,"EN^INHOQT1","INHO TOP") Q       ;Top Entries Report
BPM D EN1(4,"EN^INHOA","INHO BPM") Q         ;Background Process Monitor
 Q
 ;
EN1(SELECT,INPRO,INGAL) ;Run selected report
 ;INPUT:  SELECT - Report #     
 ;        INPRO  - Procedure to be executed
 ;        INGAL  - Gallery for reading in parameters
 ;
 N %,INPAR,D,D0,DA,INDA,DIC,DICPOP,DIE,DLAYGO,XGABPOP
 ;
 S INDA=""
 S X=$J_"_"_DUZ_"_"_$P($H,",",2),DIC=4001.1,DIC(0)="L" S DLAYGO=4001.1 D ^DIC S INDA=+Y I +Y<0 W !,"Unable to create record "_X_" in file 4001.1" Q
 S DA=INDA
 ;
 ;Initialize "^DIZ(4001.1" with default values
 D DEF(SELECT,DA)
 ;
 ;Initialize gallery variables
 S DIE=4001.1,DWN=INGAL
RPT ; Loop, the user can enter/edit values in the input parameters
 ; screen and rerun the report selected as many times as wanted.
 ;
 ;Check to determine if this is an IHS system and the form exists
 I '$$SC^INHUTIL1 Q:'$D(^DIST(.403,"B",DWN))  D
 .N DDSFILE,DR,DDSPAGE,DDSPARM
 .S DDSFILE=DIE,DR="["_DWN_"]",DDSPAGE=1,DDSPARM="SC"
 .D ^DDS
 ; Force ^DWC to ask to file (i.e. take default values)
 I $$SC^INHUTIL1 D
 .S DWASK=""
 .;Run Gallery to enter/edit input parameters
 .D ^DWC
 I '$D(DWFILE)&'$G(DDSSAVE) D INKINDA(INDA) Q
 D GAT(INDA,SELECT,.INPAR)
 ;Q:'$G(BPC)  ;cmi/maw 4/4/2006 added so it won't bomb on a blank
 D ST
 G RPT
 ;
 Q
 ;
ST ;Run Report with INPUT parameters selected
 ;
 ;NEW statements
 N %ZIS,POP,INTASKED,ZTDESC,ZTIO,ZTRTN,ZTSAVE
 ;
 ;IF Device selected is not the user own device, run this routine
 ; in the background.
 S INTASKED=0 ;Background flag
 ;Get device
 ;
 ;Top Entries Report only displays on the screen
 I SELECT=3 D @INPRO Q
 ;
 W ! K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ"
 ;;;DGH;;S:'$$SC^INHUTIL1 %ZIS=%ZIS_"T0"
 D ^%ZIS I POP D EXIT^INHOA Q
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 ;User did not select their own device, force queue to taskman
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." D EXIT^INHOA Q
 I IO'=IO(0) D  D EXIT^INHOA Q
 . S INTASKED=1,ZTDESC="Background Process Monitor",ZTIO=IOP,ZTRTN=INPRO
 . F X="INPAR(","INTASKED" S ZTSAVE(X)=""
 . D ^%ZTLOAD
 ;
 ;Go to compilation and display module
 D @INPRO
 Q
 ;
DEF(SELECT,DA) ;Initialize ^DIZ(4001.1 with default values
 N DIE,DR
 S DIE="^DIZ(4001.1,"
 S DR=$P($T(@SELECT),";",2,99) D ^DIE
 Q
 ;
 ;Default values mapping
 ; Structure - {Field Number}///{Default Value}
 ; Tags - 1 (VS Report)
 ;        2 (QSIZE)
 ;        3 (TOP)
 ;        4 (BPM)
1 ;21///5;22///1;23///100
2 ;21///5;22///1;23///100;27///0;25///1800;24///0
3 ;21///5;22///1;26///5
4 ;21///5;22///1;23///100;27///0;25///1800;26///5;24///0
 Q
 ;
GAT(INDA,SELECT,INPAR) ;Initialize  INPAR with input parameters
 ; INPUT - INDA   : ien entry to fileman file #4001.1
 ;         SELECT : report number selected
 ; OUPUT - INPAR array initialized
 ;       
 ; Tag DOC shows which INPAR parameters are used for each report.
 ; We initialize only the appropiate parameters.
 N B,BPC
 S B=^DIZ(4001.1,INDA,20)
 S BPC=$P(B,U,1)
 ;Q:'$G(BPC)  ;cmi/maw 4/4/2006 added as if left blank it bombs
 S:SELECT=4 INPAR("PROCESS")=BPC_U_$P(^INTHPC(BPC,0),U)
 S INPAR("REPAINT")=$P(B,U,2)
 S INPAR("DETAIL")=$P(B,U,3)
 S:";1;2;4;"[SELECT INPAR("ITER")=$P(B,U,4)
 S:";2;4;"[SELECT INPAR("RUNTOEND")=$P(B,U,5)
 I ";2;4;"[SELECT S INPAR("MAXREPTIME")=$P(B,U,6),INPAR("MAXQTIME")=INPAR("MAXREPTIME")
 S:";2;4;"[SELECT INPAR("FUTURE")=$P(B,U,8)
 S:";3;4;"[SELECT INPAR("ITERT")=$P(B,U,7)
 Q
 ;
DOC ;INPAR Parameters used by each report
 ; This is only for documentation purposes
 ;
 ;VS Report (SELECT=1):
 ; DETAIL,ITER,REPAINT (in INHOP rout.)
 ; QSTART,START (in INHOV1)
 ;QSIZE Report (SELECT=2): 
 ; DETAIL,FUTURE,ITER,MAXQTIME,MAXREPTIME,REPAINT,RUNTOEND (in INHOP)
 ; MSGSTART,QSTART,REPSTART,START,TSKSTART (in INHOQR1) 
 ;TOP Report (SELECT=3):
 ; DETAIL,ITERT,REPAINT (in INHOP)
 ; START (in INHOQT1)
 ;BPM Report (SELECT=4):
 ; DETAIL,FUTURE,ITER,ITERT,MAXQTIME,MAXREPTIME,PROCESS,REPAINT,RUNTOEND
 ; MSGSTART,QSTART,REPSTART,START,TSKSTART (in INHOQR1)
 ;
INKINDA(INDA) ;Clean-up Input Parameters storage data
 ; DESCRIPTION:
 ;   Cleans up input parameters from file "INTERFACE MESSAGE
        ;   SEARCH" (4001.1)
 ;INPUT: 
 ;   INDA - Ien into ^DIZ(4001.1
 ;
 Q:'$G(INDA)  ;nothing to clean-up
 N DA,DIK,X
 S DA=INDA,DIK="^DIZ(4001.1,"
 D ^DIK
 Q
 ;
GALC(X) ;Check Background Process selected
 ; Tag called from "INHO BPM" gallery
 N DIC,Y
 S DIC=4004,DIC(0)="MNED"
 S DIC("S")="I $D(^INTHPC(""ACT"",1,Y))"
 D ^DIC
 I Y<0 K X Q
 ; Display the text of the Background Process selected
 S DWVOY=$P(Y,U,2)
 ; Repaint window, this allows to repaint full text of
 ;  the Background Process selected. 
 S DWPNT=""
 ; Store only the pointer
 S $P(^DIZ(4001.1,INDA,20),U)=+Y
 Q
 ;
GALH ;Help, list of active queues to select from.
 ; Tag is called from "INHO BPM" gallery.
 N DIC,X,Y
 W !,"The following listing contains only active queues." H 2
 S DIC=4004,DIC(0)="MN",X="??"
 S DIC("S")="I $D(^INTHPC(""ACT"",1,Y))"
 D ^DIC
 Q
 ;
MPURG() ;Purge junk entries from Interface Message Search File, #4001.1
 ; OUTPUT 
 ;   1 - Purge completed
 N INDA,X
 S X="^DIZ(4001.1)"
 S INDA=0 F  S INDA=$O(@X@(INDA)) Q:'INDA  D
 .;kill entry if we can acquire lock
 .L +@X@(INDA):0 I  L -@X@(INDA) D INKINDA^INHOP(INDA)
 Q 1
