BEDDUTW1 ;GDIT/HS/BEE-BEDD Utility Routine 2 - Cache Calls ; 08 Nov 2011  12:00 PM
  ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014
 ;
 ;This routine is included in the BEDD XML 2.0 install and is not in the KIDS
 ; 
 Q
 ;
CHKLK(BEDDID,DUZ,TIMEOUT) ; EP - Check and Possibly Unlock
 ;
 ; Input:
 ; BEDDID - Record ID
 ; DUZ - User DUZ
 ; TIMEOUT - The site timeout value
 ;
 ; Output:
 ; None
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(BEDDID)="" Q
 I $G(DUZ)="" Q
 ;
 ;BEDD*2.0*1;CR#8726;Establish variable unlocking timeout
 S TIMEOUT=+$G(TIMEOUT) S:TIMEOUT=0 TIMEOUT=300
 ;
 NEW EDVST,LDT,TIM,SAVE,LUSITE
 ;
 S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(BEDDID)
 ;
 ;Check if already unlocked
 I EDVST.RecLock=0 Q
 ;
 ;Unlock if same user
 I DUZ=EDVST.RecLockUser D  Q
 . S EDVST.RecLock=0,EDVST.RecLockDT="",EDVST.RecLockUser="",EDVST.RecLockSite=""
 . S SAVE=EDVST.%Save()
 ;
 ;Pull timeout of locked user's site, if available
 S LUSITE=EDVST.RecLockSite
 I +LUSITE D
 . NEW SINFO,SIEN
 . S SIEN=$O(^BEDD.EDSYSTEMI("SiteIdx"," "_+LUSITE,"")) Q:'SIEN
 . S SINFO=##class(BEDD.EDSYSTEM).%OpenId(SIEN)
 . S TIMEOUT=+SINFO.TimeOut S:TIMEOUT=0 TIMOUT=300
 ;
 ;Unlock any record after 30 seconds after timeout value
 S LDT=EDVST.RecLockDT
 S TIM=$$SECWTG^BEDDUTIL($P(LDT,","),$P(LDT,",",2))
 I TIM>(TIMEOUT+30) D  Q
 . S EDVST.RecLock=0,EDVST.RecLockDT="",EDVST.RecLockUser="",EDVST.RecLockSite=""
 . S SAVE=EDVST.%Save()
 Q
 ;
LKLST(BEDDLK,SITE,DUZ) ; EP - Assemble list of locked records dashboard
 ;
 ; Input:
 ; SITE - Site variable
 ; DUZ - User DUZ
 ;
 ; Output:
 ; BEDDLK array
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW BEDD,OBJ,TYP,TRM,BEDDSYS
 ;
 S SITE=$G(SITE)
 S DUZ=$G(DUZ)
 ;
 ;Get system variables
 Do LOADSYS^BEDDUTW(.BEDDSYS,SITE,DUZ)
 ;
 ;Get dashboard entries
 D BEDDLST^BEDDUTIL(.BEDD,SITE)
 ;
 ;Check-In/Awaiting Doc
 F TYP=1,8 S OBJ="" F  S OBJ=$O(BEDD(TYP,OBJ)) Q:OBJ=""  D
 . Do CHKLK^BEDDUTW(OBJ,DUZ,$G(BEDDSYS("TimeOut"))) ;Check Lock
 . NEW EDVST
 . S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(OBJ)
 . I EDVST.RecLock'=0 S BEDDLK(OBJ)=""
 ;
 ;Triage/Room
 F TYP=2,3 S TRM="" F  S TRM=$O(BEDD(TYP,TRM)) Q:TRM=""  S OBJ="" F  S OBJ=$O(BEDD(TYP,TRM,OBJ)) Q:OBJ=""  D
 . Do CHKLK^BEDDUTW(OBJ,DUZ,$G(BEDDSYS("TimeOut"))) ;Check Lock
 . NEW EDVST
 . S EDVST=##CLASS(BEDD.EDVISIT).%OpenId(OBJ)
 . I EDVST.RecLock'=0 S BEDDLK(OBJ)=""
 ;
 Q
 ;
CHKDATA(OBJID) ; EP - Save Primary Prov and Assigned Prov
 ;
 ; Input:
 ; OBJID
 ;
 ; Output:
 ; None
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW EDREF,VIEN,PPR,PPRN,ESTAT
 S EDREF=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
 S VIEN=EDREF.VIEN
 S (PPR,PPRN)="" S PPR=$$PPR^BEDDUTIL(VIEN)
 I PPR'="" S EDREF.PrimPrv=PPR
 I EDREF.AsgPrv="" s EDREF.AsgPrv=PPR
 S ESTAT=EDREF.%Save()
 S EDREF=""
 K EDREF
 Q
 ;
UPPRV(OBJID,PPR) ; EP - Save Primary Prov
 ;
 ; INPUT:
 ; OBJID - OBJECT
 ; PPR - Primary Provider IEN
 ;
 ; OUTPUT:
 ; None
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTW D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW EDOBJ,STAT
 ;
 I $G(OBJID)="" Q
 I $G(PPR)="" Q
 ;
 S EDOBJ=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
 I EDOBJ.PrimPrv="" S EDOBJ.PrimPrv=PPR S STAT=EDOBJ.%Save()
 S EDOBJ=""
 K EDOBJ,STAT
 Q
 ;
BLDTRG(MYTRG) ;EP - Build Acuity MYTRG array
 ;
 ; Input:
 ; None
 ;
 ; Output:
 ; MYTRG array of ^AMER(3) TRIAGE CATEGORY entries
 ;
 ;Error Trap
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDUTIL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 NEW TIEN,TIEN1,AC
 K MYTRG
 S TIEN=$O(^AMER(2,"B","TRIAGE CATEGORY","")) Q:TIEN=""
 S TIEN1="" F  S TIEN1=$O(^AMER(3,"AC",TIEN,TIEN1)) Q:'TIEN1  D
 . NEW ANM,CNM
 . S AC=$$GET1^DIQ(9009083,TIEN1_",",5,"E") Q:AC=""
 . S CNM=$$GET1^DIQ(9009083,TIEN1_",",.01,"E")
 . S ANM=$S(AC=1:"RESUSCITATION",AC=2:"EMERGENT",AC=4:"LESS URGENT",AC=5:"ROUTINE",1:CNM)
 . S MYTRG(AC)=TIEN1_"^"_CNM_"^"_AC_"^"_ANM
 Q
