BQIIPUTL ;VNGT/HS/ALA-utility program for IPC ; 05 May 2011  12:55 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
STORF(FAC,ID,BQDATE,DEN,NUM) ;EP - Store facility data
 ; Input parameters
 ;   FAC    - Facility IEN
 ;   ID     - Measure ID
 ;   BQDATE - Month and Year date
 ;   DEN    - Denominator value
 ;   NUM    - Numerator value
 ;
 NEW DA,DIC,DLAYGO,MSRN,X
 I '$D(^BQIFAC(FAC,30,0)) S ^BQIFAC(FAC,30,0)="^90505.63^^"
 S DA(1)=FAC,DIC(0)="LMNZ",DLAYGO=90505.63,X=ID,DIC="^BQIFAC("_DA(1)_",30,"
 D ^DIC I Y=-1 K DO,DD D FILE^DICN
 S MSRN=+Y
 I '$D(^BQIFAC(FAC,30,MSRN,1,0)) S ^BQIFAC(FAC,30,MSRN,1,0)="^90505.631D^^"
 S DA(2)=FAC,DA(1)=MSRN,DIC(0)="LMNZ",DLAYGO=90505.631,X=$S($L(BQDATE)=5:BQDATE_"00",1:BQDATE)
 S DIC="^BQIFAC("_DA(2)_",30,"_DA(1)_",1,"
 D ^DIC I Y=-1 K DO,DD D FILE^DICN
 S DA=+Y
 S $P(^BQIFAC(FAC,30,MSRN,1,DA,0),U,2,3)=DEN_U_NUM
 Q
 ;
STORP(PROV,ID,BQDATE,DEN,NUM) ;EP - Store for provider
 ;   PROV   - Provider IEN
 ;   ID     - Measure ID
 ;   BQDATE - Month and Year date
 ;   DEN    - Denominator value
 ;   NUM    - Numerator value
 ;
 NEW DA,DIC,MSRN,DLAYGO,X
 I $G(^BQIPROV(PROV,0))="" D NPR(PROV)
 I '$D(^BQIPROV(PROV,30,0)) S ^BQIPROV(PROV,30,0)="^90505.43^^"
 S DA(1)=PROV,DIC(0)="LMNZ",DLAYGO=90505.43,X=ID,DIC="^BQIPROV("_DA(1)_",30,"
 D ^DIC I Y=-1 K DO,DD D FILE^DICN
 S MSRN=+Y
 I '$D(^BQIPROV(PROV,30,MSRN,1,0)) S ^BQIPROV(PROV,30,MSRN,1,0)="^90505.431D^^"
 S DA(2)=PROV,DA(1)=MSRN,DIC(0)="LMNZ",DLAYGO=90505.431,X=$S($L(BQDATE)=5:BQDATE_"00",1:BQDATE)
 S DIC="^BQIPROV("_DA(2)_",30,"_DA(1)_",1,"
 D ^DIC I Y=-1 K DO,DD D FILE^DICN
 S DA=+Y
 S $P(^BQIPROV(PROV,30,MSRN,1,DA,0),U,2,3)=DEN_U_NUM
 Q
 ;
NPR(PROV) ; EP - Add a new provider
 NEW DA,DIC,X,DINUM,Y
 S (DINUM,X)=PROV,DIC(0)="L",DIC="^BQIPROV("
 K DO,DD D FILE^DICN
 Q
 ;
MON ;EP - Months
 ;;JAN
 ;;FEB
 ;;MAR
 ;;APR
 ;;MAY
 ;;JUN
 ;;JUL
 ;;AUG
 ;;SEP
 ;;OCT
 ;;NOV
 ;;DEC
