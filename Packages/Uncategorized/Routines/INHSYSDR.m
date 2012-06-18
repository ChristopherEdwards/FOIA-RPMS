INHSYSDR ;WOM 12/07/95; 17 Nov 98 10:30 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
EN1 ;User entry point 1 using listman for saving Transaction Types
 ;and relatives for export
 ; Variables: INSELTT - Array of selected types
 ;  INPOP - Flag to bail, some kinda fatal error
 ;
 N INSELTT,INPOP S INPOP=0
 D LIST^INHSYSUT(.INSELTT)
 I INSELTT D COMP^INHSYS(.INSELTT)
 Q
EN2 ;User Entry point 2 for saving Transaction Types and relatives
 ;to export
 ; Variables: INSELTT - Array of selected types
 ;  INASK - If zero ask for reporting/DEVICE
 ;  INCR - If 1, require <CR> from user if 
 ;         report is sent to primary device
 ;  INPOP - Flag for FATAL ERROR
 N INSELTT,DIC,Y,INASK,INCR,INPOP
 ; Turn debug level off for Background Process
 D DEBOFF^INHSYS09
 S DIC="^INRHT(",DIC(0)="AEQZ",DIC("A")="Enter Transaction Type Name: "
 W @IOF
 D ^DIC Q:+Y'>0
 I $P(Y(0),"^",4)="" W !,"This entry has an invalid UNIQUE IDENTIFIER",!,"Aborting" Q
 S INSELTT=1,INSELTT(1)=+Y,INASK=0,INCR=1,INPOP=0 D COMP^INHSYS(.INSELTT)
 Q
EN3 ;List processesor of available routine names to restore data to env
 ; to import
 N %SRC,%RD,%RMSEL,%UTILITY,%UCI,%SYS,%,%RTN,DWLRF,DWLB,DWL,DWLMK,DWLMK1
 N %CNT,%UT,%RT,%,Y,INREPRT,%TT,INASK,INCR,INPOP
 ; Initialize INASK and INCR to Ask for FULL reporting/<CR>
 ; Initialize INPOP - Flag for FATAL ERROR
 S INASK=0,INCR=1,INPOP=0 K ^UTILITY($J),^UTILITY("INHSYS",$J) D ^%ZIST
 I '$$ROUT^INHSYS(.%UTILITY) W @IOF,$$SETXY^%ZTF(30,10),"No files to process",!!
 E  D
 .S %RTN="",%CNT=0 F  S %RTN=$O(%UTILITY(%RTN)) Q:%RTN=""  D
 ..S %TT=$T(@(%RTN)+3^@(%RTN)),%TT=$P(%TT,";",2)
 ..I %TT'="" S %RTN=%RTN_" - "_%TT
 ..S %CNT=%CNT+1,%UT(%CNT)=%RTN,%UT(%CNT,0)=""
 .I '$D(%UT) W !,"No files to process" Q
 .S DWLRF="%UT",DWLB="16^5^10^70",DWL="HWXXM-1"
 .S DWL("TITLE")="W $$CENTER^INHUTIL(""Select one routine to restore from"",80)"
 .D ^DWL
 .S %RT=$O(DWLMK("")) I %RT D RESTORE^INHSYS(.%UT,.%RT)
 Q
EN4 ;Global file element compare
 D %GCMP^INHSYS07
 Q
