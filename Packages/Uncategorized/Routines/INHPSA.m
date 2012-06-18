INHPSA ; FRW ; 10 Jun 99 14:45; Interface Control Program - Main Application Interface
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
PROCINT(INTER,INPAR,INNAME,INDATA,INMESS) ;Process one interface
 ;This is called as the control routine for most interfaces
 ;Called from PROC^INHPSAM
 ;INPUT:
 ;  INTER - interface application identifier
 ;  INPAR - array of parameters
 ;  INNAME - name of application
 ;  INDATA - executable MUMPS code to get data array
 ;             should leave data in the array INDAT
 ;  INMESS - executable code to be done after the load is complete
 ;
 N HDR,INMTF,INTIME
 S INNAME=$G(INNAME),INTER=$G(INTER),INDATA=$G(INDATA),INMESS=$G(INMESS)
 Q:'$L(INTER) 0
 N INERR,INDAT
 S INERR=""
 ;Get default name
 S:'$L(INNAME) INNAME=$P($G(INPAR("APPL",INTER)),U)
 ;
 S INMTF=$$GETMTF(),INTIME=$$CDATASC^%ZTFDT($H,1,1)
 S HDR(1)="INMTF,?(IOM-27),INTIME,"" PAGE:"",$J(INPAGE,4)"
 S HDR(2)="""Interface Name: "_INNAME_""""
 S HDR(3)="",$P(HDR(3),"-",IOM)="",HDR(3)=""""_HDR(3)_""",!"
 D HEADER^INHMG
 ;
 ;Create array of data for application
 K INDAT
 ;Check for custom defined data builder code
 I $L(INDATA) X INDATA I INERR D T^INHMG1 W "ERROR:  ",INNAME," - no action taken" S INERR=1 Q 0
 ;Execute standard data builder
 I '$L(INDATA) I '$$CREDAT(.INDAT) D T^INHMG1 W "ERROR:  Unable to create data array." S INERR=1 Q 0
 ;Process application
 D ONE(INTER,.INDAT,.INPAR) Q:$G(DUOUT) $S('INERR:1,1:0)
 ;post-processing logic
 D:INPAR("ACT")'=2 POST^INHPSA2(INTER,INMESS)
 I INPAR("ACT")=2,$G(INDISCRP) D DISCREP^INHPSA4(ININT,.INDAT)
 ;Quit positive if no errors, null if errors encoutnered
 Q $S('INERR:1,1:0)
 ;
ONE(INTER,INDAT,INPAR) ;Activate/Deactivate one interface
 ;INPUT:
 ;   INTER - interface application to activate
 ;   INDAT - data array of control file records for application (PBR)
 ;   INPAR - array of parameters (pass by ref)
 ;
 ;Background Process(es)
 D BACK(INTER,.INDAT,.INPAR)
 ;Transaction Type(s)
 D TT(INTER,.INDAT,.INPAR) Q:$G(DUOOUT)
 ;Script Generator Messages
 D MSG(INTER,.INDAT,.INPAR)
 ;
 Q
 ;
MSG(INTER,INDAT,INPAR) ;Script Generator Messages
 ;
 ;Not currently supported - assumes all messages will be active
 Q
 ;
MSGONE(DA,INST) ;Activate/Deactivate one message   //??? where is this called from
 ;
 S INST=+$G(INST) N DIE,DR,INSTMSG
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 ;Set INACTIVE flag
 S DIE=4011,DR=".08///"_$S('INST:1,1:0) D ^DIE
 W:'$G(INVERBOS) !,"Script Generator Message: ",$P(^INTHL7M(DA,0),U),"    ",INSTMSG
 Q
 ;
 ;?? Compile Message
 ;?? Should transaction types for messages also be deactivated
 ;?? Should scripts for message also be deactivated
 ;?? Should anything be done with the Message Replication File - DEFER
 Q
 ;
BACK(INTER,INDAT,INPAR) ;Background Process(es)
 ;
 ;Activate background process
 N INREC S INREC=0
 F  S INREC=$O(INDAT(INTER,4004,INREC)) Q:'INREC  S:'$$BPCONE(INREC,+$G(INPAR("ACT"))) INERR=1
 ;
 Q
 ;
BPCONE(DA,INST) ;Activate/Deactivate one background process
 ;INPUT:
 ;  DA - entry to process in INDAT
 ;  INST - what to do  0 - deactivate (def) ; 1 - activate, 2 - show
 ;
 N DIC,X,Y,DIE,DR,INSTMSG,INNAME
 S INST=+$G(INST)
 S (INNAME,X)=$P($G(INDAT(INTER,4004,DA)),U,1),DIC=4004,DIC(0)="",Y=$$DIC(DIC,X,"",DIC(0)),DA=+Y
 I INNAME'=$P(Y,U,2) D T^INHMG1 W "ERROR: Wanted background process ",INNAME," but found ",$P(Y,U,2)," (",+Y,")." Q 0
 I DA<0 D T^INHMG1 W "ERROR:  Background Process: ",INNAME," not found." Q 0
 I INST=2 D  Q 1
 .S INSTMSG=$S('$P($G(^INTHPC(DA,0)),U,2):"INACTIVE",1:"ACTIVE")
 .D T^INHMG1 W "Background Process: ",$P(^INTHPC(DA,0),U),?68,INSTMSG
 ;
 S INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 S DIE=4004,DR=".02///"_INST
 ;If activated, then check debug level
 I INST,+$P($G(^INTHPC(DA,9)),U,1)'=0 D
 .D T^INHMG1 W "Debug will be turned off for Background Process: ",INNAME
 .S DR=DR_";"_9.01_"///0"
 D ^DIE
 I +$P($G(^INTHPC(DA,9)),U,1)'=0 D T^INHMG1 W "Warning:  Background Process: ",INNAME," debug is still ON"
 I $P($G(^INTHPC(DA,0)),U,2)'=INST D T^INHMG1 W "ERROR:  Background Process: ",INNAME," not ",INSTMSG S INERR=1 Q 0
 I '$G(INVERBOS) D T^INHMG1 W "Background Process: ",$P(^INTHPC(DA,0),U),?68,INSTMSG
 Q 1
 ;
 ;Need to handle other data nodes for record if present
 ;
TT(INTER,INDAT,INPAR) ;Transaction Types
 ;
 ;De/Activate Transaction Type
 N INREC S INREC=0
 F  S INREC=$O(INDAT(INTER,4000,INREC)) Q:'INREC  S:'$$TTONE(INREC,+$G(INPAR("ACT"))) INERR=1 Q:$G(DUOUT)
 ;
 Q
 ;
TTONE(DA,INST) ;Deactivate/activate one transaction type
 ;
 N DIC,X,Y,DIE,DR,INSTMSG,INNAME
 N INHIER   ;this array is used to show the transaction hierarchy
 S INHIER("PARENT")=""
 S INHIER("CHILD")=""
 S INHIER("BASE")=""
 ;
 S INST=+$G(INST)
 ;Quit if deactivating and suppress deactivation flag is set
 Q:'INST&$P($G(INDAT(INTER,4000,DA)),U,2) 1
 ;Quit if activating and suppress activation flag is set
 Q:INST&$P($G(INDAT(INTER,4000,DA)),U,3) 1
 S (INNAME,X)=$P($G(INDAT(INTER,4000,DA)),U,1),DIC=4000,DIC(0)="",Y=$$DIC(DIC,X,"",DIC(0)),DA=+Y
 I INNAME'=$P(Y,U,2) D T^INHMG1 W "ERROR: Wanted transaction type ",INNAME," but found ",$P(Y,U,2)," (",+Y,")." Q 0
 I DA<0 D T^INHMG1 W "ERROR:  Transaction Type: ",INNAME," not found." Q 0
 Q:'$$TTEDT(DA,INST,.INHIER,"CHILD") 0
 ;
 ;Process Base (if DA is Replicant TT)
 Q:'$$TTBASE^INHPSA4(DA,INST,.INHIER) 0
 ;
 ;Process Parent
 Q:'$$TTPAR(DA,INST,.INHIER) 0
 D WRITE^INHPSA4(.INHIER,INST)
 ;
 Q 1
 ;
TTPAR(DA,INST,INHIER) ;Process parent transaction types
 ;DA - ien of child transaction type
 ;
 N INCHTT,INPATT,OK,INCUST,TT
 Q:'$D(^INRHT(+$G(DA),0)) 0
 S INCHTT=+DA,INPATT=+$P(^INRHT(DA,0),U,6)
 ;If no parent quit with no error
 Q:'INPATT 1
 ;If parent doesn't exist quit with error
 I '$D(^INRHT(INPATT,0)) D T^INHMG1 W "ERROR: Parent transaction type deleted for ",$P($G(^INRHT(+DA,0)),U,1),"   ",INPATT Q 0
 ;
 ;Get current status of parent
 S INCUST=$P(^INRHT(INPATT,0),U,5)
 ;
 ;Perform activation process
 I INST=1 D:'INCUST
 .  ;Parent is NOT active - check for active children
 .  S TT="" F  S TT=$O(^INRHT("AC",INPATT,TT)) Q:'TT  D
 ..    ;no warning if TT is calling child or is inactive
 ..    Q:(TT=DA)!('$P($G(^INRHT(TT,0)),U,5))
 ..    D T^INHMG1 W "WARNING:  Transaction type ",$P(^INRHT(TT,0),U)," was active.  "
 ..    D T^INHMG1 W "          Messages will now be generated for this transaction type."
 ;
 ;Perform deactivation process
 I 'INST S OK=1 D:INCUST  Q:'OK 1  ; exit if NOT OK to deactivate parent
 .  ;Parent is active - check for active children
 .  ;no deactivation if TT is NOT the calling child & is active
 .  S TT="" F  S TT=$O(^INRHT("AC",INPATT,TT)) Q:'TT  I TT'=DA,$P($G(^INRHT(TT,0)),U,5) S OK=0 Q
 ;
 ; De/Activate parent TT
 Q:'$$TTEDT(INPATT,INST,.INHIER,"PARENT") 0
 ;
 Q 1
 ;
TTEDT(DA,INST,INHIER,INODE) ;Edit transaction type
 ;
 S:INST'=2 INSTMSG=$S('INST:"DEACTIVATED",1:"ACTIVATED")
 I INST'=2 S DIE=4000,DR=".05///"_INST D ^DIE
 I INST'=2,$P($G(^INRHT(DA,0)),U,5)'=INST D T^INHMG1 W "ERROR:  Transaction Type: ",INNAME," not ",INSTMSG Q 0
 S:INST=2 INSTMSG=$S($P($G(^INRHT(DA,0)),U,5)=1:"ACTIVE",1:"INACTIVE")
 S INHIER(INODE)=DA
 Q 1
 ;
 ;Should anything be done with the Message Replication File - DEFER
 ;Should script be recompiled if activating - probably
 ;
CREDAT(INDAT) ;Create data array of control records
 ;
 N INERR,L1,TXT S INERR=1
 ;Load data into array
 F LI=1:1 S TXT=$P($$TEXT^INHPSA1(INTER,LI),";;",2,99) Q:'TXT  I '$$LOAD(.INDAT,TXT,INTER) S INERR=0
 Q INERR
 ;
LOAD(INDAT,TXT,INTER) ;Load a node of data into data array
 ;INPUT:
 ;   INDAT - data array of control file records for application (PBR)
 ;   TXT   - line of data to load into array (from INHPSA1)
 ;             foramt -> file # ^ node ^ data
 ;   INTER - interface application
 ;
 N INREC
 ;Check for comment line
 Q:$E(TXT,1)[";" 1
 ;Error if no file has been defined
 Q:'TXT 0
 ;Set record counter to last record used for file
 S INREC=$G(INDAT(INTER,+TXT))
 ;Check for new record (2nd piece = null)
 I '$L($P(TXT,U,2)) D  Q 1
 .  ;Increment record counter
 .  S INREC=INREC+1,INDAT(INTER,+TXT)=INREC
 .  ;Used for the lookup value to DIC call
 .  S INDAT(INTER,+TXT,INREC)=$P(TXT,U,3,99)
 ;Capture any data nodes
 S INDAT(INTER,+TXT,INREC,+$P(TXT,U,2))=$P(TXT,U,3,99)
 Q 1
 ;
DIC(DIC,X,DLAYGO,%IPS,DOA,%L,DINUM) ;dic lookup
 ;
 ; 10/17/95  Matches lookup in DIC^INHSYS05 (which may not be present
 ; during GIS s/w installation).
 ;
 ;input:
 ;  DIC - Global Root: Can be a string or file number
 ;        If a file number, this function returns -1
 ;             when looking at a multiple
 ;  X - Stuff this bud
 ;  DLAYGO - file number and formatting
 ;  %IPS - input parameter string; see DIC(0) documentation
 ;  DOA  - array of previous DA values; passed by referrence
 ;  %L   - current level
 ;  DINUM (opt) - force this ien
 ;output:
 ;  Y    - What DIC returns
 N G,DA,I,Y
 I DIC Q:DIC'>0!($G(DOA)&$G(%L)) -1 S DIC=$G(^DIC(DIC,0,"GL")) Q:DIC="" -1
 I $G(DOA),($G(%L)) D
 .F I=%L:-1:2 S DA(I)=DOA(I-1)
 .S DA(1)=DOA
 S G=DIC_"0)" S:'$D(@G) @G="^"_DLAYGO_"^^"
 ;Ugly cross ref lookup since ^DIC chokes on >30 Xact match lookups
 I $L(X)>30 S Y=$O(@(DIC_"""B"","""_X_""","""")")) Q $S(Y:Y_U_$P(@(DIC_Y_",0)"),U),1:-1)
 S DIC(0)=%IPS
 I '$D(DINUM) D ^DIC
 I $D(DINUM) D ^DICN
 Q Y
 ;
GETMTF() ;Get the name of the primary MTF (only one per CHCS system)
 N Y,X
 S Y=$G(^DD("SITE",1)) Q:'Y ""
 S X=$P($G(^DIC(4,Y,0)),U)
 Q X
 ;
