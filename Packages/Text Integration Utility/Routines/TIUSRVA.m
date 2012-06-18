TIUSRVA ; SLC/JER,AJB - API's for Authorization ; 12/03/03
 ;;1.0;TEXT INTEGRATION UTILITIES;**19,28,47,80,100,116,152,160,178**;Jun 20, 1997
 ;
 ;External reference to File ^AUPNVSIT supported by DBIA 3580
REQCOS(TIUY,TIUTYP,TIUDA,TIUSER) ; Evaluate cosignature requirement
 ; Initialize return value
 N TIUDPRM
 S TIUY=0
 I +$G(TIUTYP)'>0,'+$G(TIUDA) Q
 I +$G(TIUDA) S TIUTYP=+$G(^TIU(8925,+$G(TIUDA),0))
 S:'+$G(TIUSER) TIUSER=+$G(DUZ)
 S TIUY=+$$REQCOSIG^TIULP(TIUTYP,+$G(TIUDA),+$G(TIUSER))
 Q
URGENCY(Y) ; -- retrieve set values from dd for discharge summary urgency
 N TIUDD,I,X
 D FIELD^DID(8925,.09,"","POINTER","TIUDD")
 F I=1:1 S X=$P(TIUDD("POINTER"),";",I) Q:X=""   S Y(I)=$TR(X,":","^")
 Q
CANDO(Y,TIUDA,TIUACT) ; Boolean function to evaluate privilege
 N TIUPOP,TIUDPRM S TIUPOP=0
 ; **152** code added to prevent editing a completed document.
 I $P($G(^TIU(8925,TIUDA,0)),U,5)>6,(TIUACT="EDIT RECORD") S Y="0^ You may not edit a completed document" Q
 I $S(TIUACT["SIGN":1,TIUACT="EDIT RECORD":1,TIUACT="DELETE RECORD":1,1:0) D  Q:+TIUPOP=1
 . L +^TIU(8925,+TIUDA):1
 . E  S Y="0^ Another session is editing this entry.",TIUPOP=1
 . L -^TIU(8925,+TIUDA)
 I TIUACT["SIGN",+$$NEEDCS(TIUDA) S Y="0^ You must name a cosigner before signing this document." Q
 S Y=$$CANDO^TIULP(TIUDA,TIUACT)
 Q
NEEDCS(TIUDA) ; Does user need a cosigner?
 N TIUD0,TIUD12,TIUY,SIGNER,COSIGNER,XTRASGNR
 S TIUD0=$G(^TIU(8925,TIUDA,0)),TIUD12=$G(^(12))
 S SIGNER=$P(TIUD12,U,4),COSIGNER=$P(TIUD12,U,8),XTRASGNR=0
 I (DUZ'=SIGNER),(DUZ'=COSIGNER) S XTRASGNR=+$O(^TIU(8925.7,"AE",+TIUDA,+DUZ,0))
 I +XTRASGNR S TIUY=0
 E  I +$$REQCOSIG^TIULP(+TIUD0,TIUDA,DUZ),(+$P(TIUD12,U,8)'>0) S TIUY=1
 Q +$G(TIUY)
USRINACT(TIUY,TIUDA) ; Is user inactive?
 S TIUY=+$$GET1^DIQ(200,TIUDA_",",7,"I")
 Q
AUTHSIGN(TIUY,TIUDA,TIUUSR) ; Has Author signed?
 ; if TIUY = 
 ; 0 = Author has NOT signed & TIUUSR = Expected Cosigner
 ; 1 = Author HAS signed or TIUUSR '= Expected Cosigner
 ;
 N TIUD12,TIUD15
 S TIUD12=$G(^TIU(8925,TIUDA,12)),TIUD15=$G(^(15))
 S TIUY=1
 D:$P(TIUD12,U,8)=TIUUSR  Q
 . S:$P(TIUD12,U,2)'=$P(TIUD15,U,2) TIUY=0
 Q
TIUVISIT(TIUY,DOCTYP,DFN,VISIT) ;  DK - Check for a 1 time only doc
 ;  TIUY    =    return value
 ;          = 0 if can add more than one or none already exist
 ;          = 1 if cannot add more than one and one already exists
 ;  DOCTYP  =    Pointer to ^TUI(8925.1,   TIU DOCUMENT DEFINITION
 ;  DFN     =    Patient IEN
 ;  VISIT   =    Visit String "LOC;VDATE;VTYP"
 I $$PATCH^XPDUTL("OR*3.0*195") D
 . Q:($G(DOCTYP)="")!($G(DFN)="")!($G(VISIT)="")
 . N TIUDPRM,TIUTEST
 . D DOCPRM^TIULC1(DOCTYP,.TIUDPRM)
 . S TIUY=$S($P(TIUDPRM(0),U,10)="":1,1:$P(TIUDPRM(0),U,10))
 . I TIUY=1 S TIUY=0 Q
 . I $L(VISIT,";")=3 D
 . . S TIUTEST=$$EXIST^TIUEDI3(DFN,DOCTYP,VISIT)
 . . I TIUTEST S TIUY=1
 . . I 'TIUTEST S TIUY=0
 I '$$PATCH^XPDUTL("OR*3.0*195") D
 . Q:($G(DOCTYP)="")!($G(DFN)="")!($G(VISIT)="")
 . N X3
 . S X3=+$O(^TIU(8925.95,"B",DOCTYP,""))
 . S TIUY=$P($G(^TIU(8925.95,X3,0)),U,10) S TIUY=$S(TIUY=0:1,1:0)
 . Q:'TIUY
 . S VISIT=((9999999-$P(VISIT,"."))_"."_$P(VISIT,".",2))
 . S VISIT=+$O(^AUPNVSIT("AA",DFN,VISIT,""))
 . S TIUY=$S($D(^TIU(8925,"AV",DFN,DOCTYP,VISIT)):0,1:1)
 . S TIUY=$S(TIUY=0:1,1:0)
 Q
WHATACT(Y,TIUDA) ; Evaluate/return whether signature or cosignature
 N TIUD0,TIUD12,TIUSTAT,SIGNER,COSIGNER,XTRASGNR
 S TIUD0=$G(^TIU(8925,+TIUDA,0)),TIUD12=$G(^TIU(8925,+TIUDA,12))
 S SIGNER=$P(TIUD12,U,4),COSIGNER=$P(TIUD12,U,8)
 I (DUZ'=SIGNER),(DUZ'=COSIGNER) S XTRASGNR=+$O(^TIU(8925.7,"AE",+TIUDA,+DUZ,0))
 S TIUSTAT=+$P(TIUD0,U,5)
 S Y=$S(TIUSTAT'>5:"SIGNATURE",+$G(XTRASGNR):"SIGNATURE",1:"COSIGNATURE")
 Q
CANCHCOS(Y,TIUDA) ; Evaluate/return whether user can change cosigner
 S Y=$$MAYCHNG^TIURA1(TIUDA)
 Q
NEEDJUST(Y,TIUDA) ; Is justification required for deletion?
 N TIUD0 S TIUD0=$G(^TIU(8925,+TIUDA,0)),Y=0
 I +$P(TIUD0,U,5)'<6 S Y=1
 Q
GETTITLE(Y,TIUDA) ; Get the title from a TIU Document Record
 S Y=+$G(^TIU(8925,+TIUDA,0))
 Q
CANATTCH(Y,TIUDA) ; Can this document be attached as an ID Child
 N TITLEDA,PARENTDA
 S TITLEDA=+$G(^TIU(8925,TIUDA,0))
 I TITLEDA'>0 S Y="0^Document #"_TIUDA_" does not exist." Q
 S PARENTDA=+$G(^TIU(8925,TIUDA,21))
 S Y=$$POSSPRNT^TIULP(TITLEDA)
 I +Y S Y="-1"_U_$P(Y,U,2) Q
 I +$$ISCWAD^TIULX(TITLEDA) D  Q
 . S Y="0^ CWAD Documents may not be Attached as Interdisciplinary Entries."
 I +$$ISA^TIULX(TITLEDA,+$$CLASS^TIUCNSLT) D  Q
 . S Y="0^ Consult Results may not be Attached as Interdisciplinary Entries."
 S Y=$$CANDO^TIULP(TIUDA,"ATTACH TO ID NOTE")
 I PARENTDA D  ; action must be "detach"
 . I 'Y S Y="0^ You may not detach this note from an interdisciplinary note." Q
 . S Y=$$CANDO^TIULP(PARENTDA,"ATTACH ID ENTRY")
 . I 'Y S Y="0^ You may not detach this note from its interdisciplinary note."
 Q
CANRCV(Y,TIUDA) ; Can this document receive an ID Child?
 S Y=$$CANDO^TIULP(TIUDA,"ATTACH ID ENTRY")
 Q
