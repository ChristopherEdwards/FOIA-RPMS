BQIFLFLG ;PRXM/HC/ALA-Determine Flag Indicator ; 15 Dec 2005  2:33 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(BQIUSR,PDFN,ADIEN) ;EP - Find for each iCare user whether their patient has active flags
 ;
 ;Processing variables
 ;  BQIUSR = User signed into the system
 ;  PDFN   = Patient internal entry number (DFN)
 ;  ADN    = User Flag definition internal entry number
 ;  ADESC  = Flag definition description
 ;  ADIEN  = iCare definition internal entry number
 ;
 NEW VALUE,FLAGG,BQIFLAG
 I $G(DT)="" D DT^DICRW
 ;  For each user and their flag definitions
 S FLAGG=0
 D RET^BQIFLAG(BQIUSR,.BQIPREF)
 S ADIEN=""
 F  S ADIEN=$O(BQIPREF(ADIEN)) Q:ADIEN=""  D
 . ;  For each patient in all of a user's panels, see if there are active flags
 . S FDT=$P(BQIPREF(ADIEN),U,1),TDT=$P(BQIPREF(ADIEN),U,2)
 . I PDFN'="" D
 .. I '$$PAT(PDFN,ADIEN,FDT,TDT,BQIUSR) D FLG("R") Q
 .. ;
 .. ;  If the patient has active alerts based on the user's criteria, set the alert flag
 .. ;  for each panel belonging to the user that the patient is found.
 .. I $$PAT(PDFN,ADIEN,FDT,TDT,BQIUSR) D FLG("A")
 . ;
 . I PDFN="",PLIEN'="" D
 .. S PDFN=0,BQIFLAG=0
 .. F  S PDFN=$O(^BQICARE(BQIUSR,1,PLIEN,40,PDFN)) Q:'PDFN  D  Q:BQIFLAG
 ... I '$$PAT(PDFN,ADIEN,FDT,TDT,BQIUSR) D FLG("R") Q
 ... I $$PAT(PDFN,ADIEN,FDT,TDT,BQIUSR) D FLG("A") S BQIFLAG=1
 ;
 K ADESC,ADIEN,ADN,ADTM,AIEN,ALIEN,BQIUSR,FDT,FLAG,NAME,NM
 K PARMS,PDFN,PIEN,PMIEN,PTYP,SOURCE,STAT,TDT,TMFRAME,X,Y,%DT
 Q
 ;
PAT(DFN,ADIEN,SDT,EDT,USR) ;EP - Check for active flags
 ;
 ;Input
 ;  DFN = Patient internal entry number
 ;  ADIEN = iCare definition internal entry number
 ;  SDT = Start date range for the user preferences time frame
 ;  EDT = End date (which is today)
 ;  USR = User whose flag preferences are being checked
 ;Output
 ;  FLAG = If flag is 1, then active; if 0, is not active for this user (opposite of STAT)
 ;Processing Variables
 ;  ADTM  = Time Frame starting date
 ;  EDT   = Time Frame ending date
 ;  ALIEN = Patient flag record internal entry number
 ;  STAT  = Status of the record by this user.  If the user has set the
 ;          status to 1=Don't Show, then it is considered no longer active.
 ;
 ;Check in the ICARE PATIENT INDEX File (#90507.5) for any flags that meet
 ;the user's defined criteria
 ;
 S ADTM=SDT,FLAG=0
 F  S ADTM=$O(^BQIPAT(DFN,10,ADIEN,5,"AC",ADTM)) Q:ADTM=""!(ADTM\1>EDT)  D  Q:FLAG
 . S ALIEN=0
 . F  S ALIEN=$O(^BQIPAT(DFN,10,ADIEN,5,"AC",ADTM,ALIEN)) Q:'ALIEN  D  Q:FLAG
 .. Q:'$D(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,USR))
 .. S STAT=+$P(^BQIPAT(DFN,10,ADIEN,5,ALIEN,1,USR,0),U,2)
 .. I STAT'=1 S FLAG=1
 Q FLAG
 ;
FLG(ACT) ;EP - Set or Remove flag indicator
 ;
 ;Input
 ;  ACT = Action flag "R" is remove flag and "A" is add flag
 ;
 NEW PLIEN
 S PLIEN=0
 F  S PLIEN=$O(^BQICARE(BQIUSR,1,"AB",PDFN,PLIEN)) Q:'PLIEN  D
 . I $G(^BQICARE(BQIUSR,1,PLIEN,40,PDFN,0))="" K ^BQICARE(BQIUSR,1,"AB",PDFN,PLIEN) Q
 . NEW DA,IENS
 . S DA(2)=BQIUSR,DA(1)=PLIEN,DA=PDFN,IENS=$$IENS^DILF(.DA)
 . ;
 . ; Set patient record in panel with 1=Yes, has active flags or 0=No, has no active flags
 . I ACT="R" S BQIUPD(90505.04,IENS,.08)=0 Q
 . I ACT="A" S BQIUPD(90505.04,IENS,.08)=1
 I '$D(BQIUPD(90505.04)) D  ; Check shared panels if patient is not in owner's panel
 . N BQISHR
 . S (BQISHR,PLIEN)=""
 . F  S BQISHR=$O(^BQICARE("C",BQIUSR,BQISHR)) Q:BQISHR=""  D  Q:$D(BQIUPD(90505.04))
 .. F  S PLIEN=$O(^BQICARE("C",BQIUSR,BQISHR,PLIEN)) Q:PLIEN=""  D  Q:$D(BQIUPD(90505.04))
 ... I $D(^BQICARE(BQISHR,1,PLIEN,40,PDFN)) D
 .... NEW DA,IENS
 .... S DA(2)=BQISHR,DA(1)=PLIEN,DA=PDFN,IENS=$$IENS^DILF(.DA)
 .... ;
 .... ; Set patient record in panel with 1=Yes, has active flags or 0=No, has no active flags
 .... I ACT="R" S BQIUPD(90505.04,IENS,.08)=0 Q
 .... I ACT="A" S BQIUPD(90505.04,IENS,.08)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
PMS(USER,FLGN,PDFN) ;EP - Get parameter values
 ;
 ;Input Parameters
 ;  USER - User
 ;  FLGN - Flag internal entry number
 ;  For each user and their flag definition
 NEW ADIEN,BQIPREF
 D RET^BQIFLAG(USER,.BQIPREF)
 S ADIEN=FLGN
 S FDT=$P(BQIPREF(ADIEN),U,1),TDT=$P(BQIPREF(ADIEN),U,2)
 ;
 I $$PAT(PDFN,ADIEN,FDT,TDT,USER) Q 1
 Q 0
