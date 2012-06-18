INHMSR ;KN; 31 Jan 96 09:47; Calling routine for the INHMSR1 Module. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: INHMSR Module.
 ;
 ; PURPOSE:
 ; The purpose of the INHMSR is used to ask user for enter file name,
 ; and call the INHMSR1 module to start for the process.  Also the 
 ; INHGLB is used for the global ^UTILITY.
 ;
 ;
 ; DESCRIPTION:
 ; The processing of this routine will prompt user to enter file name,
 ; look up DD for the file IEN, and call INHMSR1 module to start the 
 ; Statistical process.  In addition, the INHGLB routine is used to
 ; store the predefined selectable fields in global ^UTILITY. 
 ;
EN ; Entry point for the INHMSR
 ;    
 N INIEN,INNM,INA
 ;If not found pre-defined selectable fields, run INHGLB
 I '$D(^UTILITY($J,"INHSR")) D INHGLB
 S DIC="^DIC(",DIC(0)="AEQ",DIC("A")="Enter File Name: "
 D ^DIC
 I $G(DUOUT)!(Y<0) G Q
 S INIEN=+Y,INNM=$P(Y,U,2)
 D EN^INHMSR1(INIEN,INNM)
Q K ^UTILITY($J)
 Q
 ;
UIF ; Universal Interface file
 ;
 N INIEN,INNM,INA
 D INHGLB
 D EN^INHMSR1(4001,"Universal Interface File")
 Q
ERR ;Interface error file
 ;
 N INIEN,INNM,INA
 D INHGLB
 D EN^INHMSR1(4003,"Interface Error")
 Q
 ;
INHGLB ; Temperary global set
 ; 
 ; Description: This file is used to set up temporary global for 
 ;  display setectable fields as need.
 ; 
 ; These fields are used to holds all interface transactions
 ; regardless of the destination.  It also holds all status
 ; and tracking information for the transactions.
 ; **************************************************************
 S ^UTILITY($J,"INHSR",4001)=1
 S ^UTILITY($J,"INHSR",4001,.12)=""
 S ^UTILITY($J,"INHSR",4001,.01)=""
 S ^UTILITY($J,"INHSR",4001,.02)=""
 S ^UTILITY($J,"INHSR",4001,.1)=""
 S ^UTILITY($J,"INHSR",4001,.14)=""
 S ^UTILITY($J,"INHSR",4001,.11)=""
 S ^UTILITY($J,"INHSR",4001,.16)=""
 S ^UTILITY($J,"INHSR",4001,.08)=""
 S ^UTILITY($J,"INHSR",4001,.03)=""
 S ^UTILITY($J,"INHSR",4001,5)=""
 ;**************************************************************
 ; This fields are used to store errors for the interface 
 ; error file.
 ;*************************************************************
 S ^UTILITY($J,"INHSR",4003)=1
 S ^UTILITY($J,"INHSR",4003,.11)=""
 S ^UTILITY($J,"INHSR",4003,.04)=""
 S ^UTILITY($J,"INHSR",4003,.09)=""
 S ^UTILITY($J,"INHSR",4003,.1)=""
 S ^UTILITY($J,"INHSR",4003,.05)=""
 S ^UTILITY($J,"INHSR",4003,.06)=""
 S ^UTILITY($J,"INHSR",4003,.01)=""
 S ^UTILITY($J,"INHSR",4003,.02)=""
 Q
