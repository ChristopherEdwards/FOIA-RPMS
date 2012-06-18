BQITDUTL ;APTIV/HC/ALA-Diagnostic Tag Utilities ; 25 Feb 2008  2:30 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
CMP(BQIDFN,BQITAG) ;EP - Compare data
 NEW BQIFN,BQIFAC,BQIDID,BQIRN,BQIREC,BQIRDT,BQIREX,BQIIEN,ADD
 NEW BQIFIL,BQIVPR,FLAG
 S FLAG=0,THCFL=$P(^BQI(90506.2,BQITAG,0),U,10)
 I $G(^BQIPAT(BQIDFN,20,BQITAG,0))="" Q FLAG
 S BQIDID=$P(^BQIPAT(BQIDFN,20,BQITAG,0),U,2)
 S BQIFN=0
 F  S BQIFN=$O(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN)) Q:'BQIFN  D
 . S BQIFAC=$P($G(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,0)),U,1)
 . I BQIFAC="" K ^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN) Q
 . S BQIRN=0
 . F  S BQIRN=$O(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN)) Q:'BQIRN  D
 .. S BQIREC=$P(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN,0),U,1)
 .. S BQIRDT=$P(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN,0),U,2)
 .. S BQIREX=$P(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN,0),U,3)
 .. S BQIIEN=$P(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN,0),U,4)
 .. S BQIFIL=$P(^BQIPAT(BQIDFN,20,BQITAG,1,BQIFN,1,BQIRN,0),U,5)
 .. I $E(BQIREC,1,1)="P" S BQIVPR=$E(BQIREC,2,$L(BQIREC))_";AUPNPROB("
 .. I $E(BQIREC,1,1)="V" S BQIVPR=$E(BQIREC,2,$L(BQIREC))_";AUPNVSIT("
 .. I BQIREC="" S FLAG=0 Q
 .. S FLAG=$$CHKR()
 .. Q
 . I BQIFAC[" Tag" S FLAG=$$CHKR()
 Q FLAG
 ;
CHKR() ; Check for record
 NEW BQIIFACT,BQIISR,BQIIFAC,BQIITG,BQIIVPR,BQII
 S BQII=""
 I $O(^BQIFACT("C",BQIDFN,BQITAG,BQII))="" Q 1
 F  S BQII=$O(^BQIFACT("C",BQIDFN,BQITAG,BQII)) Q:BQII=""  D
 . S BQIIFACT=^BQIFACT(BQII,0)
 . S BQIIFAC=$P(BQIIFACT,U,1)
 . S BQIITG=$P(BQIIFACT,U,3) S:BQIITG="" BQIITG="~"
 . S BQIIVPR=$P(BQIIFACT,U,5) S:BQIIVPR="" BQIIVPR="~"
 . S BQIISR(BQIIFAC,BQIITG,BQIIVPR)=""
 ;
 I '$D(BQIISR(BQIFAC,BQITAG,BQIVPR)) Q 1
 Q 0
 ;
NCR(BQIDFN,BQITAG) ;EP - If no criteria found, check if patient is already
 ;  in Permanent Tag file BQIREG
 NEW RIEN,HOK,THCFL,RSTAT,TGDATA
 S THCFL=+$P(^BQI(90506.2,BQITAG,0),U,10)
 S RIEN=""
 F  S RIEN=$O(^BQIREG("C",BQIDFN,BQITAG,RIEN)) Q:RIEN=""  D
 . I $$REG(BQIDFN,BQITAG)=1 Q
 . S RSTAT=$P(^BQIREG(RIEN,0),U,3)
 . ; If status is Not Accepted or No Longer Valid or Superceded, quit
 . I RSTAT="N"!(RSTAT="V") Q
 . ; if the current status is 'Proposed', move the factors before setting the
 . ; current status to 'No Longer Valid' or 'Superseded'
 . I RSTAT="P" D MOV^BQITDPRC(BQIDFN,BQITAG)
 . I 'THCFL D  Q
 .. I $$REG(BQIDFN,BQITAG)=1 Q
 .. D EN^BQITDPRC(.TGDATA,BQIDFN,BQITAG,"V",,"SYSTEM UPDATE",3) Q
 . ;S LOK=$$LOW(BQIDFN,BQITAG)
 . S HOK=$$HIGH(BQIDFN,BQITAG)
 . ; If higher tag and it's active, superseded
 . I HOK,$P(HOK,U,3)=1 D EN^BQITDPRC(.TGDATA,BQIDFN,BQITAG,"S",,"SYSTEM UPDATE",4) Q
 . ; If CVD At Risk not met criteria but exists and higher hierarchy is not active, it
 . ; needs to go back to 'Accepted' status because user had manually entered or met with
 . ; original DOB and the DOB has been modified
 . I BQITAG=9,HOK,$P(HOK,U,3)'=1 D EN^BQITDPRC(.TGDATA,BQIDFN,BQITAG,"A",,"SYSTEM UPDATE",5) Q
 . D EN^BQITDPRC(.TGDATA,BQIDFN,BQITAG,"V",,"SYSTEM UPDATE",3)
 Q
 ;
ACT(RDFN) ;PEP - Check for any active tags
 NEW ACT,RIEN,CSTAT
 S RIEN="",ACT=0
 F  S RIEN=$O(^BQIREG("AC",RDFN,RIEN)) Q:RIEN=""  D
 . S CSTAT=$P(^BQIREG(RIEN,0),U,3)
 . I CSTAT="A"!(CSTAT="P") S ACT=1
 Q ACT
 ;
ACST(STAT) ; EP - Is this status active or not
 NEW ACT
 S ACT=0
 I STAT="A"!(STAT="P") S ACT=1_U_STAT
 Q ACT
 ;
ATAG(RDFN,RTAG) ;EP - Is this tag active for this patient
 NEW TGN,RGIEN,RGSTAT,RGDT,STAT,TGDT
 S TGN=$$GDXN^BQITUTL(RTAG)
 S RGIEN=$O(^BQIREG("C",RDFN,TGN,"")) I RGIEN="" Q 0
 S RGSTAT=$P($G(^BQIREG(RGIEN,0)),U,3),RGDT=$P($G(^(0)),U,4)
 S TGDT=$P($G(^BQIPAT(RDFN,0)),U,6)
 S STAT=$$ACST(RGSTAT)
 I 'STAT Q STAT
 Q STAT_U_$S($P(STAT,U,2)="A":RGDT,1:TGDT)
 ;Q $$ACST(RGSTAT)
 ;
CTAG(RDFN,RTAG) ;EP - Current tag status
 NEW TGN,RGIEN,RGSTAT,RGDT,STAT,TGDT
 S TGN=$$GDXN^BQITUTL(RTAG)
 S RGIEN=$O(^BQIREG("C",RDFN,TGN,"")) I RGIEN="" Q ""
 S RGSTAT=$P($G(^BQIREG(RGIEN,0)),U,3)
 Q RGSTAT
 ;
LOW(DFN,TAG) ;EP - Check for lower hierarchy and return next lower one found
 NEW RESULT,HCIEN,ORD,HORD,HIEN,HTAG,RIEN,HSTAT,QFL
 S RESULT=0
 S HCIEN=$O(^BQI(90506.2,TAG,4,"B",TAG,""))
 S ORD=$P(^BQI(90506.2,TAG,4,HCIEN,0),U,2),HORD=ORD,QFL=0
 F  S HORD=$O(^BQI(90506.2,TAG,4,"AC",HORD)) Q:HORD=""  D  Q:QFL
 . S HIEN=$O(^BQI(90506.2,TAG,4,"AC",HORD,""))
 . S HTAG=$P(^BQI(90506.2,TAG,4,HIEN,0),U,1)
 . S RIEN=$O(^BQIREG("C",DFN,HTAG,""))
 . I RIEN="" Q
 . S HSTAT=$P(^BQIREG(RIEN,0),U,3)
 . S RESULT=1_U_HTAG_U_$$ACST(HSTAT)
 Q RESULT
 ;
HIGH(DFN,TAG) ;EP - Check for a higher hierarchy and return next highest one found
 NEW RESULT,HCIEN,ORD,HORD,HIEN,HTAG,RIEN,HSTAT
 S RESULT=0
 S HCIEN=$O(^BQI(90506.2,TAG,4,"B",TAG,""))
 S ORD=$P(^BQI(90506.2,TAG,4,HCIEN,0),U,2),HORD=ORD,QFL=0
 F  S HORD=$O(^BQI(90506.2,TAG,4,"AC",HORD),-1) Q:HORD=""  D  Q:QFL
 . S HIEN=$O(^BQI(90506.2,TAG,4,"AC",HORD,""))
 . S HTAG=$P(^BQI(90506.2,TAG,4,HIEN,0),U,1)
 . S RIEN=$O(^BQIREG("C",DFN,HTAG,""))
 . I RIEN="" Q
 . S HSTAT=$P(^BQIREG(RIEN,0),U,3)
 . S RESULT=1_U_HTAG_U_$$ACST(HSTAT)
 Q RESULT
 ;
REG(BQIDFN,BQITAG) ;EP - Inactive Associated Register status
 ; Input
 ;   BQIDFN - Patient internal entry number
 ;   BQITAG - Tag internal entry number
 NEW REGIEN,RDATA,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD,DFN
 NEW IENS,RESULT,PSTAT,RGRIEN
 ; If there is no associated register with the tag, quit
 S REGIEN=$P(^BQI(90506.2,BQITAG,0),U,8) I REGIEN="" Q 0
 ; Get the information from the register on where the patient is located
 S DFN=BQIDFN
 S RDATA=^BQI(90507,REGIEN,0)
 S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 S SUBREG=$P(RDATA,U,9)
 S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 I GLBNOD="" Q 0
 ;
 ; If the register file doesn't exist, quit
 I '$D(@GLBNOD@(0)) Q 0
 ; If the patient isn't found in the register, quit
 I '$D(@GLBREF@(BQIDFN)) Q 0
 ;
 S RESULT=2
 ; If the register is a subregister in CMS, get the record IEN
 I $G(SUBREG)'="" S QFL=0 D  I 'QFL Q 0
 . S RGRIEN=""
 . F  S RGRIEN=$O(@GLBREF@(BQIDFN,RGRIEN)) Q:RGRIEN=""  D
 .. I $P($G(@GLBNOD@(RGRIEN,0)),U,5)=SUBREG S QFL=1,IENS=RGRIEN
 ; If the register is not a subregister, get the record IEN
 I $G(SUBREG)="" S IENS=$O(@GLBREF@(BQIDFN,""))
 ; Execute the status executable
 I STEX'="" X STEX Q:'$D(IENS)
 ; Check on register status, only inactive tagged patients
 ; stay proposed, status="inactive" or "unreviewed"
 S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 ;
 I PSTAT'="A",PSTAT'="T" Q RESULT
 Q 1
 ;
ORG(BQIDFN,BQIREG) ;EP - On register
 NEW REGIEN,RDATA,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD,DFN
 NEW PSTAT,QFL
 I BQIREG'?.N S REGIEN=$O(^BQI(90507,"B",BQIREG,"")) I REGIEN="" Q 0
 I BQIREG?.N S REGIEN=BQIREG
 S DFN=BQIDFN
 S RDATA=^BQI(90507,REGIEN,0)
 S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 I $G(SUBREG)="" S SUBREG=$P(RDATA,U,9)
 S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 I GLBNOD="" Q 0
 ;
 I '$D(@GLBNOD@(0)) Q 0
 I '$D(@GLBREF@(BQIDFN)) Q 0
 ;
 S RESULT=0
 I $G(SUBREG)'="" S QFL=0 D  I 'QFL Q 0
 . S RGRIEN=""
 . F  S RGRIEN=$O(@GLBREF@(BQIDFN,RGRIEN)) Q:RGRIEN=""  D
 .. I $P($G(@GLBNOD@(RGRIEN,0)),U,5)=SUBREG S QFL=1,IENS=RGRIEN
 . ; Check register status
 I $G(SUBREG)="" S IENS=$O(@GLBREF@(BQIDFN,""))
 I STEX'="" X STEX Q:'$D(IENS)
 ; Check on register status, only 'Active' register, tagged patients
 ; become accepted
 S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 I PSTAT="" Q RESULT
 I PSTAT'="A" Q RESULT
 Q 1
