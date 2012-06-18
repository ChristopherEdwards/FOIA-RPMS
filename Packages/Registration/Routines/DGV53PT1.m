DGV53PT1 ;ALB/MTC - MAS v5.3 Post Init Routine ; 07 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
 ;
PROCON ;-- entry point to start the provider conversion
 ;
 ;-- create conversion log file
 D LOGCON
 ;-- do conversion
 D CON2^DGV53PT2,CON44^DGV53PT5,CON405^DGV53PT3,CON457^DGV53PT4,CON392^DGV53PT4,CON411^DGV53PT5,CON45^DGV53PT6
 ;-- conversion complete
 D ENDMSG
 ;-- generate mail message from conversion log
 D DOMAIL
 Q
 ;
ENDMSG ;-- This function will write the completion time for the complete
 ;   conversion to the log.
 N RESULT,DATE,Y
 D NOW^%DTC S Y=% D DD^%DT S DATE=Y
 S RESULT=$P(^DG(43,1,"PCL",0),U,3)
 S RESULT=RESULT+1,^DG(43,1,"PCL",RESULT,0)=">>> Provider Conversion Completed on  "_DATE W !,^(0)
 S $P(^DG(43,1,"PCL",0),U,3,4)=RESULT_"^"_RESULT
 Q
 ;
ADDPC(FILE) ;--add entry for provider conversion to file 43
 ; INPUT : FILE - File number to convert
 ;
 ;-- add entry to provider conversion multiple if none
 I '$D(^DG(43,1,"PCON","B",FILE)) D
 . I '$D(^DG(43,1,"PCON",0)) S ^DG(43,1,"PCON",0)="^43.02A^"
 . S DIC="^DG(43,1,""PCON"",",DIC(0)="L",X=FILE,DA(1)=1 K D0,DD D FILE^DICN K DIC,DA
 Q
 ;
DONE(PSAV,TOTAL) ;-- This function will update the completion time, total number of
 ;   records and the file sentinal indicating the file has been
 ;   converted.
 ; INPUT : PSAV - IFN of the record in file 43
 ;        TOTAL - total records processed
 ;
 ;-- enter completion time, mark conversion as completed
 D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,3)=%,$P(^DG(43,1,"PCON",PSAV,0),U,6)="Y",$P(^DG(43,1,"PCON",PSAV,0),U,7)=TOTAL
 ;
 Q
 ;
LOGCON ;-- This function will create a log file entry in file 43
 ;   if one does not exist.
 ;
 N RESULT,DATE,X,Y
 D NOW^%DTC S Y=% D DD^%DT S DATE=Y
 ;-- check if log entry is already present
 I $D(^DG(43,1,"PCL",0)) D  G LOGCONQ
 . S RESULT=$P(^DG(43,1,"PCL",0),U,3)
 . S RESULT=RESULT+1,^DG(43,1,"PCL",RESULT,0)=">>> Provider Conversion Re-Started on  "_DATE W !,^(0)
 . S $P(^DG(43,1,"PCL",0),U,3,4)=RESULT_"^"_RESULT
 ;
 ;-- add entry build, build header
 S DIE="^DG(43,",DA=1,DR="91///"_"      Provider Conversion Log for MAS Files." D ^DIE K DIE,DA,DR
 S ^DG(43,1,"PCL",2,0)=">>> Provider Conversion Started on "_DATE W !,^(0)
 S ^DG(43,1,"PCL",3,0)=" Files : 2, 41.1, 44, 45, 45.7, 392 and 405" W !,^(0)
 S ^DG(43,1,"PCL",4,0)=""
 S $P(^DG(43,1,"PCL",0),U,3,4)="4^4"
 ;
LOGCONQ Q
 ;
NEWFILE(FILE) ;-- This function will add a information to the Provider
 ;   Conversion Log for the file in (FILE).
 ;   INPUT - FILE - The file number to print a header
 N SEQ,DATE,X,Y
 ;-- get the next sequence number for message
 S SEQ=$P($G(^DG(43,1,"PCL",0)),U,3)
 G:'SEQ NFQ
 ;-- get date/time
 D NOW^%DTC S Y=% D DD^%DT S DATE=Y
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)=""
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)=">>> Provider Conversion for the "_$O(^DD(FILE,0,"NM",0))_" (#"_FILE_") file :" W !!,^(0)
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)="Started on "_DATE W !?5,^(0)
 S $P(^DG(43,1,"PCL",0),U,3,4)=SEQ_U_SEQ
NFQ Q
 ;
COMFILE(FILE,OK) ;-- This function will add information to the Provider
 ;  Conversion Log when a file has been processed.
 ;    INPUT FILE - File currently being processsed
 ;          OK   - 1 if all entries converted, else 0
 N SEQ,DATE,X,Y
 ;-- get the next sequence number for message
 S SEQ=$P($G(^DG(43,1,"PCL",0)),U,3)
 G:'SEQ COMQ
 ;-- get date/time
 D NOW^%DTC S Y=% D DD^%DT S DATE=Y
 ;-- if all entries for a file converted write msg
 I OK S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)="   All entries converted." W !,^(0)
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)=">>> Provider Conversion for the "_$O(^DD(FILE,0,"NM",0))_" (#"_FILE_") file :" W !,^(0)
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)="Completed on "_DATE W !?5,^(0)
 S $P(^DG(43,1,"PCL",0),U,3,4)=SEQ_U_SEQ
COMQ Q
 ;
WRERROR(ERSTR) ;-- This function will write the error message to the
 ;  Provider conversion log. The message will be format by the
 ;  calling routine.
 ;   INPUT : ERSTR - The error string to write into log file
 ;
 N SEQ
 ;-- get the next sequence number for message
 S SEQ=$P($G(^DG(43,1,"PCL",0)),U,3) Q:'SEQ
 S SEQ=SEQ+1,^DG(43,1,"PCL",SEQ,0)=ERSTR,$P(^DG(43,1,"PCL",0),U,3,4)=SEQ_U_SEQ
 W !,ERSTR
 Q
 ;
DOMAIL ;-- This function will generate a Mailman message from the 
 ;   Provider Conversion Log field of file (#43). Lastly,
 ;   if the message was sent, then the log entry in file #43
 ;   will be deleted.
 ;
 K XMZ
 N DIFROM
 ;-- send mail message
 W !,">>> Generating mail message for Provider Conversion."
 S XMTEXT="^DG(43,1,""PCL"",",XMSUB="Provider Conversion Log.",XMDUZ=.5,XMY(DUZ)="",XMY(.5)=""
 D ^XMD
 I 'XMZ W !!,">>> Error Creating Provider Conversion Mail Message." G DOMAILQ
 ;-- clean-up log if message was sent
 S DIE="^DG(43,",DA=1,DR="91///@" D ^DIE K DIE,DA,DR
 ;
DOMAILQ K XMTEXT,XMSUB,XMDUZ,XMY
 Q
 ;
