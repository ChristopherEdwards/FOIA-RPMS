BQIFLAG ;PRXM/HC/ALA-Get Flag indicator ; 06 Sep 2006  2:34 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
RET(OWNR,BQIPREF) ;EP -- Returns the flag preferences for a user
 NEW ADIEN,ADESC,PARMS,MPARMS,TMFRAME,NM,NAME,Y,X,TDT,FDT,%DT
 S ADIEN=0
 F  S ADIEN=$O(^BQICARE(OWNR,10,"B",ADIEN)) Q:'ADIEN  D
 . ; If the flag entry is inactive, quit
 . I $P(^BQI(90506,ADIEN,0),U,2)=1 Q
 . K PARMS,MPARMS
 . S ADESC=$P(^BQI(90506,ADIEN,0),U,1)
 . ;  Check for the user preferences timeframe for flags
 . D GPARMS^BQIPLFLG(DUZ,ADESC,.PARMS,.MPARMS)
 . S NM=""
 . I $O(PARMS(NM))="",'$D(MPARMS) Q
 . F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 . I $G(TMFRAME)="" Q
 . I TMFRAME["T-" S %DT="",X=TMFRAME D ^%DT S FDT=Y
 . I $G(DT)="" D DT^DICRW
 . S TDT=DT
 . S BQIPREF(ADIEN)=FDT_U_TDT
 Q
 ;
FPAT(PDFN,OWNR,BQIPREF,TYPE) ;EP -- Checks if the patient has an active flag for the user and the user preferences
 NEW FLG,QFLG,FDT,FDTM,TDT,REC,STAT
 S TYPE=$G(TYPE,"")
 S FLG="",QFLG=0
 F  S FLG=$O(BQIPREF(FLG)) Q:FLG=""  D  Q:QFLG
 . S FDT=$P(BQIPREF(FLG),U,1),TDT=$P(BQIPREF(FLG),U,2)
 . S FDTM=FDT
 . F  S FDTM=$O(^BQIPAT("AF",PDFN,FLG,FDTM)) Q:FDTM=""!(FDTM\1>TDT)  D  Q:QFLG
 .. S REC=0
 .. F  S REC=$O(^BQIPAT("AF",PDFN,FLG,FDTM,REC)) Q:REC=""  D  Q:QFLG
 ... S STAT=+$P($G(^BQIPAT(PDFN,10,FLG,5,REC,1,OWNR,0)),U,2)
 ... I STAT,TYPE="" Q
 ... I STAT,TYPE="S" Q
 ... I STAT,TYPE="A" S QFLG=1 Q
 ... S QFLG=1
 Q QFLG
 ;
UPU(BDFN,USR) ;EP -- Update user entry
 NEW DIC,DA,DLAYGO,X,DINUM,Y,BQIPREF,FLAG,FDTM,RIEN
 D RET^BQIFLAG(USR,.BQIPREF)
 S FLAG=""
 F  S FLAG=$O(BQIPREF(FLAG)) Q:FLAG=""  D
 . S FDTM=""
 . F  S FDTM=$O(^BQIPAT("AF",BDFN,FLAG,FDTM)) Q:FDTM=""  D
 .. S RIEN=""
 .. F  S RIEN=$O(^BQIPAT("AF",BDFN,FLAG,FDTM,RIEN)) Q:RIEN=""  D
 ... I $G(^BQIPAT(BDFN,10,FLAG,5,RIEN,0))="" D  Q
 .... K ^BQIPAT("AF",BDFN,FLAG,FDTM,RIEN)
 .... K ^BQIPAT("AD",FLAG,BDFN,FDTM,RIEN)
 .... K ^BQIPAT("AE",FLAG,FDTM,BDFN,RIEN)
 ... I $P(^BQIPAT(BDFN,10,FLAG,5,RIEN,0),U,2)'=FDTM D
 .... K ^BQIPAT("AF",BDFN,FLAG,FDTM,RIEN)
 .... K ^BQIPAT("AD",FLAG,BDFN,FDTM,RIEN)
 .... K ^BQIPAT("AE",FLAG,FDTM,BDFN,RIEN)
 ... S DA(3)=BDFN,DA(2)=FLAG,DA(1)=RIEN
 ... I '$D(^BQIPAT(DA(3),10,DA(2),5,DA(1),1,0)) S ^BQIPAT(DA(3),10,DA(2),5,DA(1),1,0)="^90507.5151P^^"
 ... ;  for each user that has this patient in a panel, add a user record so
 ... ;  that each user's action/status for this patient and flag can be recorded
 ... I $D(^BQIPAT(DA(3),10,DA(2),5,DA(1),1,USR)) Q
 ... S (X,DINUM)=USR,DIC="^BQIPAT("_DA(3)_",10,"_DA(2)_",5,"_DA(1)_",1,"
 ... S DIC(0)="L",DLAYGO=90507.5151
 ... K DO,DD D FILE^DICN
 Q
 ;
SXAD ; Set the AD cross-reference
 ;BQIPAT("AD",Flag IEN,Patient IEN,Record DTM,Record IEN)
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" S ^BQIPAT("AD",DA(1),DA(2),BQIDTM,DA)=""
 Q
 ;
KXAD ;  Kill the cross-reference
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" K ^BQIPAT("AD",DA(1),DA(2),BQIDTM,DA)
 Q
 ;
SXAE ;  Set the AE cross-reference
 ; BQIPAT("AE",Flag IEN,Record DTM,Patient IEN,Record IEN)
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" S ^BQIPAT("AE",DA(1),BQIDTM,DA(2),DA)=""
 Q
 ;
KXAE ;  Kill the AE cross-reference
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" K ^BQIPAT("AE",DA(1),BQIDTM,DA(2),DA)
 Q
 ;
SXAF ; Set the AF cross-reference
 ; BQIPAT("AF",Patient IEN,Flag IEN,Record DTM,Record IEN)
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" S ^BQIPAT("AF",DA(2),DA(1),BQIDTM,DA)=""
 Q
 ;
KXAF ;  Kill the AF cross-reference
 NEW BQIDTM
 S BQIDTM=$P(^BQIPAT(DA(2),10,DA(1),5,DA,0),U,2)
 I BQIDTM'="" K ^BQIPAT("AF",DA(2),DA(1),BQIDTM,DA)
 Q
