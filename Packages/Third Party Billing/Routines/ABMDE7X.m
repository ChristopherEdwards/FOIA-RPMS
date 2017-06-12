ABMDE7X ; IHS/ASDST/DMJ - Edit Page 7 - ERROR CHK ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**10,14**;NOV 12, 2009;Build 238
 ;
 ; IHS/ASDS/SDH - 04/04/01 - V2.4 Patch 9 - NOIS XAA-0700-200102
 ;     Modified to resolved <UNDEF>ERR+9^ABMDE7X.  Thanks to Jim Gray for coding change
 ;IHS/SD/SDR - 2.6*14 - ICD10 - admit dx error checks (245 and 246) if wrong code set is used.
 ;
 ; *********************************************************************
 ;
ERR ;EP
 Q:ABMP("VTYP")=831
 S ABME("TITL")="PAGE 7 - INPATIENT INFORMATION"
 S ABMX("C5")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),ABMX("C6")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),ABMX("C7")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7))
 I $P(ABMX("C6"),U,1)="" S ABME(15)=""
 E  S:$P(ABMX("C6"),U)<ABMP("DOB") ABME(128)="ADMIT DATE" I $D(ABMP("DOD")),$P(ABMX("C6"),U)>ABMP("DOD") S ABME(129)="ADMIT DATE"
 I $P(ABMX("C6"),U,3)="" S ABME(144)=""
 E  S:$P(ABMX("C6"),U,3)<ABMP("DOB") ABME(128)="DISCHARGE DATE" I $D(ABMP("DOD")),$P(ABMX("C6"),U,3)>ABMP("DOD") S ABME(129)="DISCHARGE DATE"
 I $P(ABMX("C6"),U,1)>$P(ABMX("C6"),U,3),$P(ABMX("C6"),U,3)>0 S ABME(140)="ADMIT>DISCHARGE"
 I '$D(ABMP("EXP")) D EXP^ABMDEVAR
 ;start new abm*2.6*14 ICD10 admit dx
 I ((ABMP("ICD10")>ABMP("VDT"))&($P($$DX^ABMCVAPI($P(ABMX("C5"),U,9),ABMP("VDT")),U,20)=30)) S ABME(245)=""  ;should be ICD9, but is ICD10
 I ((ABMP("ICD10")<ABMP("VDT"))&($P($$DX^ABMCVAPI($P(ABMX("C5"),U,9),ABMP("VDT")),U,20)'=30)) S ABME(246)=""  ;should be ICD10, but is ICD9
 ;end new ICD10 admit dx
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G XIT
UB92 I $P(ABMX("C6"),U,2)="" S ABME(16)=""
 I $P(ABMX("C5"),U,1)="" S ABME(17)=""
 I $P(ABMX("C5"),U,2)="" S ABME(18)=""
 I $P(ABMX("C5"),U,3)="" S ABME(21)=""
 I $P(ABMX("C5"),U,9)="" S ABME(143)=""
 I $P(ABMX("C6"),U,4)="" S ABME(20)=""
 ;I $P(ABMX("C5"),U,8)="" S ABME(146)=""  ;abm*2.6*10
 I $P(ABMX("C5"),U,12)="" S ABME(146)=""  ;abm*2.6*10
 ;
DX I $P(ABMX("C5"),U,9)="" S ABME(143)=""
DTC ;CHECK DATES     
 S X1=$P(ABMX("C6"),U,3),X2=$P(ABMX("C6"),U) D ^%DTC
 S ABMX("DAYS")=X-$P(ABMX("C7"),U,3)-$P(ABMX("C6"),U,6)
 I ABMX("DAYS")*ABMX("DAYS")>1 S ABME(150)=""
 ;
XIT ;K ABMX
