DG272PT1 ;alb/maw-DG*5.3*272 post-install utilities ;2/1/2000
 ;;5.3;Registration;**272**;Aug 13, 1993
 ;
 ; This routine contains utilities called from ^DG272PT and ^DG272PT2.
 ;
SRCE(X) ; get source of test...
 ; X = pointer to 408.34
 ; returns SOURCE OF INCOME TEST
 Q $P($G(^DG(408.34,+X,0)),"^")
 ;
COUNT(DATE) ; update process tracking mechanisms...
 ; DATE = inverse date from "AS" x-ref in 408.31
 N %,DGMTIY
 S DGMTIY=$E(DATE,2,4)-1
 S $P(^XTMP("DGMTPCT",DGMTIY),"^")=+$P($G(^XTMP("DGMTPCT",DGMTIY)),"^")+1
 Q
 ;
EDIT(FILE,IEN,ERR) ; edit records...
 ; FILE = file number to be edited
 ; IEN  = record number to be edited
 ; ERR  = passed by reference as 0, returned as 1 if errors
 ;          occured during DBS call
 N DGMTEDIT,DGMTERR,DGMTTEXT,DGMTFLD,DIERR,I
 S DGMTTEXT="F"_$P(FILE,".",2)
 F I=1:1 Q:$P($T(@DGMTTEXT+I),";;",2)=""  D
 .S DGMTFLD=$P($P($T(@DGMTTEXT+I),";;",2),"^")
 .S DGMTEDIT(FILE,IEN_",",DGMTFLD)=""
 ;
 ; if file is 408.31, add set of purge flag in field 3...
 I FILE="408.31" S DGMTEDIT(FILE,IEN_",",3)=$$FMTE^XLFDT($$DT^XLFDT)
 ;
 ; do the edit...
 K DGMTERR,DIERR
 D FILE^DIE("E","DGMTEDIT","DGMTERR")
 I $G(DIERR)'="" S ERR=1 D ERRS(FILE,IEN,.DGMTERR)
 ;
 ; if file is 408.31, append text to field 50, COMMENT...
 I FILE="408.31" D
 .K DGMTEDIT
 .S DGMTEDIT(1)=" "
 .S DGMTEDIT(2)="NOTE: Income-related data fields in this record were purged on"
 .S DGMTEDIT(3)=$$FMTE^XLFDT($$DT^XLFDT)_" as required by IRS and/or SSA."
 .K DGMTERR,DIERR
 .D WP^DIE(408.31,IEN_",",50,"A","DGMTEDIT","DGMTERR")
 .I $G(DIERR)'="" S ERR=1 D ERRS(FILE,IEN,.DGMTERR)
 Q
 ;
ERRS(FILE,RECORD,ERRORS)        ; process errors from FM DBS calls...
 ; FILE    = file number where editing error occured
 ; RECORD = record number in which editing error occured
 ; ERRORS = the DIERR array containing error information
 N DGMTFLD,DGMTX,DGMTY
 S DGMTX=0
 F  S DGMTX=$O(ERRORS("DIERR",DGMTX)) Q:'DGMTX  D
 .S DGMTFLD=ERRORS("DIERR",DGMTX,"PARAM","FIELD")
 .S ^XTMP("DGMTPERR",FILE,RECORD,DGMTFLD)=""
 .S DGMTY=0
 .F  S DGMTY=$O(ERRORS("DIERR",DGMTX,"TEXT",DGMTY)) Q:'DGMTY  D
 ..S ^XTMP("DGMTPERR",FILE,RECORD,DGMTFLD,DGMTY)=ERRORS("DIERR",DGMTX,"TEXT",DGMTY)
 Q
 ;
BLDSTR(NSTR,STR,COL,NSL)        ; build a string...
 ; NSTR = a string to be added to STR
 ; STR  = an existing string to which NSTR will be added
 ; COL  = column location at which NSTR will be added to STR
 ; NSL  = length of new string
 ; returns STR with NSTR appended at the specified COL
 ; (code borrowed from SETSTR^VALM1)
 Q $E(STR_$J("",COL-1),1,COL-1)_$E(NSTR_$J("",NSL),1,NSL)_$E(STR,COL+NSL,999)
 ;
F22 ; fields in 408.22 to be edited...
 ;;.07^AMOUNT CONTRIBUTED TO SPOUSE
 ;;
F21 ; fields in 408.21 to be edited...
 ;;.08^SOCIAL SECURITY (NOT SSI)
 ;;.09^U.S. CIVIL SERVICE
 ;;.1^U.S. RAILROAD RETIREMENT
 ;;.11^MILITARY RETIREMENT
 ;;.12^UNEMPLOYMENT COMPENSATION
 ;;.13^OTHER RETIREMENT
 ;;.14^TOTAL INCOME FROM EMPLOYMENT
 ;;.15^INTEREST, DIVIDEND, OR ANNUITY
 ;;.16^WORKERS COMP. OR BLACK LUNG
 ;;.17^ALL OTHER INCOME
 ;;1.01^MEDICAL EXPENSES
 ;;1.02^FUNERAL AND BURIAL EXPENSES
 ;;1.03^EDUCATIONAL EXPENSES
 ;;2.01^CASH, AMOUNTS IN BANK ACCOUNTS
 ;;2.02^STOCKS AND BONDS
 ;;2.03^REAL PROPERTY
 ;;2.04^OTHER PROPERTY OR ASSETS
 ;;2.05^DEBTS
 ;;
F31 ; fields in 408.31 to be edited...
 ;;.04^INCOME
 ;;.05^NET WORTH
 ;;.15^DEDUCTIBLE EXPENSES
 ;;
