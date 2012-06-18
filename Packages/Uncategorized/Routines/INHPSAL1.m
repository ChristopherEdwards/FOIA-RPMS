INHPSAL1 ;KN; 16 Apr 96 14:42; MFN Loader Activates Software Application
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
PROCINT(INTER,INPAR,INNAME,INDATA,INMESS) ;Process one interface
 ;This is called as the control routine for most interfaces
 ;Called from PROC^INHPSAL
 ;INPUT:
 ;  INTER - interface application identifier
 ;  INPAR - array of parameters
 ;  INNAME - name of application
 ;  INDATA - executable MUMPS code to get data array
 ;           should leave data in the array INDAT
 ;  INMESS - executable code to be done after the load is complete
 ;
 S INNAME=$G(INNAME),INTER=$G(INTER),INDATA=$G(INDATA),INMESS=$G(INMESS)
 Q:'$L(INTER) 0
 N INERR,INDAT
 S INERR=""
 ;Get default name
 S:'$L(INNAME) INNAME=$P($G(INPAR("APPL",INTER)),U)
 ;Create array of data for application
 K INDAT
 ;Check for custom defined data builder code
 I $L(INDATA) X INDATA I INERR W !,"ERROR:  ",INNAME," - no action taken" S INERR=1 Q 0
 ;Execute standard data builder
 I '$L(INDATA) I '$$CREDAT(.INDAT) W !,"ERROR:  Unable to create data array." S INERR=1 Q 0
 ;Process application
 W !!,"Processing ",INNAME
 D TT(INTER,.INDAT,.INPAR)
 ;Quit positive if no errors, null if errors encoutnered
 Q $S('INERR:1,1:0)
 ;
TT(INTER,INDAT,INPAR) ;Transaction Types
 ;
 ;Process Transaction Type
 N INREC S INREC=0
 F  S INREC=$O(INDAT(INTER,4000,INREC)) Q:'INREC  S:'$$TTONE(INREC,+$G(INPAR("ACT"))) INERR=1
 ;
 Q
 ;
TTONE(DA,INST) ;Process one transaction type
 ;
 N DIC,X,Y,DIE,DR,INSTMSG,INNAME
 S INST=+$G(INST)
 ;Quit if deactivating and suppress deactivation flag is set
 Q:'INST&$P($G(INDAT(INTER,4000,DA)),U,2) 1
 ;Quit if activating and suppress activation flag is set
 Q:INST&$P($G(INDAT(INTER,4000,DA)),U,3) 1
 S (INNAME,X)=$P($G(INDAT(INTER,4000,DA)),U,1),DIC=4000,DIC(0)="",Y=$$DIC^INHPSA(DIC,X,"",DIC(0)),DA=+Y
 I INNAME'=$P(Y,U,2) W !,"ERROR: Wanted transaction type ",INNAME," but found ",$P(Y,U,2)," (",+Y,")." Q 0
 I DA<0 W !,"ERROR:  Transaction Type: ",INNAME," not found." Q 0
 ; Deactivate all the active children except the calling child
 Q:'$$TTCHILD(DA,INST) 0
 ; Set the destination according to user selection
 Q:'$$DSTEDT(DA,INST) 0
 ;
 Q 1
 ;
TTCHILD(DA,INST) ;Deactivate all child transaction types except for 
 ; the one selected by user
 ;DA - ien of child transaction type selected
 ;
 N INCHTT,INPATT
 ;find the parent of calling child INPATT
 S INCHTT=+DA,INPATT=+$P(^INRHT(DA,0),U,6)
 ;loop through all the children of this parent
 S TT="" F  S TT=$O(^INRHT("AC",INPATT,TT)) Q:'TT  D
 .; in case of not a calling child
 . I TT'=DA D
 ..; check if it is active, then deactivate it
 .. I $P($G(^INRHT(TT,0)),U,5)  D
 ... Q:'$$TTEDT^INHPSA(TT,0)
 . E  D
 ..; in case the calling child is not active, then activate it
 .. I '$P(^INRHT(TT,0),U,5)  Q:'$$TTEDT^INHPSA(TT,1)
 Q 1
 ;      
DSTEDT(DA,INST) ;Edit destination
 ;
 N INTMP,INNEW,INNIEN
 ;INTMP is current destination ien
 ;INNEW is new destination the user want to change
 ;INNIEN is the new destination ien
 S INTMP=$P(^INRHT(DA,0),U,2),INNIEN=$G(INPAR("DESTIEN")),INNEW=$P(^INRHD(INNIEN,0),U,2)
 ;change the destination
 S DIE=4000,DR=".02///`"_INNIEN D ^DIE
 Q 1
 ;
CREDAT(INDAT) ;Create data array of control records
 ;
 N INERR,L1,TXT S INERR=1
 ;Load data into array
 F LI=1:1 S TXT=$P($$TEXT^INHPSAL2(INTER,LI),";;",2,99) Q:'TXT  I '$$LOAD^INHPSA(.INDAT,TXT,INTER) S INERR=0
 Q INERR
 ;
