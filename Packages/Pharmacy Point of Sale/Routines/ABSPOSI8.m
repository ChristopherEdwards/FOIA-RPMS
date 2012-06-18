ABSPOSI8 ; IHS/FCS/DRS - insurance selection - page 8 ;   [ 11/06/2002  1:26 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
FN() Q 9002313.522
INIT ;EP - from ABSPOSI7
 ;This initializes the page 8 data.
 ; It's called as the entry action for page 8.
 ;
 ; We have DIE, DA(1) and DA, which point us into
 ;    ^ABSP(9002313.51,DA(1),2,DA,*)
 ; We want to initialize the insurance data in
 ;    ^ABSP(9002313.51,DA(1),2,DA,"I",*)
 ;
 ; All the line items are already created, before we entered the form,
 ; and there's a fixed number of them.  Unpleasant, but true. 
 ; We tried various kludgey ways to call UPDATE^DIE and create a
 ; variable-length list at the time the page was loaded, but it
 ; had various problems and we gave up.  Hopefully, there are enough
 ; line items to hold everything that's needed.   If there aren't,
 ; let's try to always make SELF PAY the last one, always leaving
 ; room for SELF PAY.
 ;
 ; We always refresh with newest stuff from a call to ABSPOS25.
 ; But if we had an existing order, we will impose that order on
 ; the ABSPOS25 results.
 ;
 ;
 ; How many entries are there?  We can look at the global because
 ; the size is, regrettably, fixed.
 N NINS S NINS=$P(^ABSP(9002313.51,DA(1),2,DA,"I",0),U,4)
 ;
 ; What is the current order? (For efficient assignment later).
 N ORDER D
 . N I F I=1,2,3 D
 . . N X S X=$$GET^DDSVAL(DIE,.DA,"6.0"_I)
 . . I X]"" S ORDER(X)=I
 ; First, call ABSPOS25, giving ARRAY
1 N ARRAY D AVAIL() ; what insurance choices are available, per A/R?
 ; Fill in defaults for any 6.01,7.01,...,6.03,7.03 that are empty
 D  ; fill in any missing orders
 . N I S I=0 ; source pointer
 . N J,K S K=0 F J=1:1:3 I $$GET^DDSVAL(DIE,.DA,J/100+6)=""  S K=J Q
 . I 'K Q  ; all three slots already in use
 . ; J = first slot available
 . N STOP S STOP=0
 . F  D  Q:STOP
 . . S I=I+1 I I>ARRAY(0) S STOP=1 Q  ; exhausted the ARRAY()
 . . N PINS S PINS=$P(ARRAY(I),U,2) ; is this entry already in top 3?
 . . I $D(ORDER(PINS)) Q  ; yes, already in top 3
 . . D PUT^DDSVAL(DIE,.DA,J/100+6,PINS) ; not in top 3 yet, assign it
 . . D PUT^DDSVAL(DIE,.DA,J/100+7,$P(ARRAY(I),U),,"I") ; store corr. INSIEN
 . . S ORDER(PINS)=J
 . . I J=3 S STOP=1 Q
 . . S J=J+1 ; advance to next 
2 ; Do not delete old entries - we're not allowed to delete existing
 ; entries with PUT^DDSVAL, and we surely shouldn't KILL them off.
 I 0 D
 . N X S X="" N S S S="" F  S S=$O(ORDER(S)) Q:S=""  D
 . . S X=X_"ORDER("_S_")="_ORDER(S)_"; "
 . D MSGWAIT^ABSPOSI1(X)
3 D STOREARR() ; set up the database
 Q
MSGWAIT(X)         D MSGWAIT^ABSPOSI1(X) Q
AVAIL() ;Use ABSPOS25 to get the very latest insurance information.
 ; 
 K ARRAY ; fills ARRAY(*)
 D  ; set up parameters and make the call to ABSPOS25
 . N FRESH S FRESH=1 ; without regard to previous visits
 . N ABSBRXI S ABSBRXI=$$GET^DDSVAL(DIE,.DA,1.01)
 . N ABSBRXR S ABSBRXR=$$GET^DDSVAL(DIE,.DA,1.02)
 . N ABSBPATI S ABSBPATI=$$GET^DDSVAL(DIE,.DA,1.04)
 . N ABSBVISI S ABSBVISI=$$GET^DDSVAL(DIE,.DA,1.06)
 . D INSURER^ABSPOS25(.ARRAY,FRESH,NINS)
 ; ARRAY(0)=count and then some other stuff
 ; ARRAY(n)=insurer IEN ^ PINS
 QUIT
STOREARR() ; setup entries in database and on form, based on ARRAY(*)
 N ENTRY F ENTRY=1:1:$P(ARRAY(0),U) D SETUP1
 Q
SETUP1 ; for ARRAY(ENTRY)
 N INSIEN,PINS S INSIEN=$P(ARRAY(ENTRY),U),PINS=$P(ARRAY(ENTRY),U,2)
 N RECNUM S RECNUM=$$FIND(PINS) ; find the PINS record
 I 'RECNUM D
 . S RECNUM=$$NEW ; if not found, assign a new one and set it up
 E  D STORE(RECNUM,PINS,INSIEN)
 Q
FIND(PINS) ; given DA(1),DA - does it exist?
 ; return record number, or false if not found
 N RET,STOP,FN S (RET,STOP)=0,FN=$$FN
 S DA(2)=DA(1),DA(1)=DA
 N RECNUM F RECNUM=1:1:NINS D  Q:STOP
 . N ERR
 . S DA=RECNUM
 . I $$GET^DDSVAL(FN,.DA,.04)=PINS S (RET,STOP)=DA ; found
 S DA=DA(1),DA(1)=DA(2) K DA(2) ; restore state of DA
 Q RET
NEW() ; given DA(1),DA,PINS,INSIEN - init a new record
 N RECNUM S RECNUM=$$FIND("") ; first one with a null PINS
 I RECNUM="" Q 0 ; none available
 D STORE(RECNUM,PINS,INSIEN)
 Q:$Q RECNUM Q
STORE(RECNUM,PINS,INSURER)   ;
 S DA(2)=DA(1),DA(1)=DA,DA=RECNUM ; set up DA for this level
 N FN S FN=$$FN
 D PUT^DDSVAL(FN,.DA,.02,$G(ORDER(PINS))) ;
 D PUT^DDSVAL(FN,.DA,.03,INSURER,,"I")
 D PUT^DDSVAL(FN,.DA,.04,PINS)
 S DA=DA(1),DA(1)=DA(2) K DA(2) ; restore state of DA
 Q:$Q RECNUM Q
ERASEALL ;EP - from ABSPOSI1
 ;erase all data in the "I" multiple
 ; given DA(1)=entry number in 9002313.51
 ;       DA = line number in LINE ITEMS multiple
 ; Refer to the global only for figuring how many of these there are
 ; This is needed because if someone DELETEs a prescription line,
 ; we have to erase all the data associated with that line.  This is
 ; called from ABSPOSI1, where the DELETE is handled.
 I $O(DA(1)) D IMPOSS^ABSPOSUE("P","TI","At wrong data level in form",,"ERASEALL",$T(+0)) Q  ; make sure you're really at this level DA(1) not DA(2)
 S DA(2)=DA(1),DA(1)=DA,DA=0
 N FN S FN=$$FN
 F  S DA=$O(^ABSP(9002313.51,DA(2),2,DA(1),"I",DA)) Q:'DA  D
 . Q:'$$GET^DDSVAL(FN,.DA,.03)  ; no insurer on this line
 . N F F F=.02,.03,.04,1.01 D
 . . D PUT^DDSVAL(FN,.DA,F,"",,"I")
 S DA=DA(1),DA(1)=DA(2) K DA(2) ; restore the DA array
 Q
POST02 ; POST ACTION ON CHANGE for ORDER, field .02
 ; DA=which insurer line  DA(1)=which prescription line  DA(2)=IEN
 ; X=new internal value, DDSOLD = previous internal value
 ; This has side effects:
 ;     Example:  assign order #2 to some item
 N THISDA S THISDA=DA
 F DA=1:1 Q:'$D(^ABSP(9002313.51,DA(2),2,DA(1),"I",DA))  D
 . Q:DA=THISDA  ; but skip the one you're changing right now
 . ; For each field, get its current order
 . N THISORD S THISORD=$$GET^DDSVAL(DIE,.DA,.02,,"I")
 . ;
 . ; DDSOLD=""   example:  pick one unassigned and make it #2
 . ; then #3 disappears and old #2 becomes #3
 . I DDSOLD="" D
 . . I THISORD="" ;do nothing, it remains blank
 . . E  I THISORD=3 D
 . . . D PUT^DDSVAL(DIE,.DA,.02,"",,"I")
 . . E  I THISORD'<X D
 . . . D PUT^DDSVAL(DIE,.DA,.02,THISORD+1,,"I")
 . . . D SET70X(THISORD+1) ; ABSP*1.0T7*8
 . ;
 . ; X>DDSOLD  example:  change 2nd to be 3rd ; X=3,DDSOLD=2
 . E  I X>DDSOLD D  ; so 3rd moves up to 2nd (1st unaffected)
 . . I THISORD="" Q  ; unassigned ones unaffected
 . . I THISORD>DDSOLD,THISORD'>X D
 . . . D PUT^DDSVAL(DIE,.DA,.02,THISORD-1,,"I")
 . . . D SET70X(THISORD-1) ; ABSP*1.0T7*8
 . ;
 . ; X<DDSOLD  example:  change 2nd to be 1st ; X=1,DDSOLD=2
 . E  I X<DDSOLD D  ; so 1st drops to 2nd and 3rd is unaffected
 . . I THISORD="" Q  ; unassigned ones unaffected
 . . I THISORD<DDSOLD,THISORD'<X D
 . . . D PUT^DDSVAL(DIE,.DA,.02,THISORD+1,,"I")
 . . . D SET70X(THISORD+1) ; ABSP*1.0T7*8
 S DA=THISDA ; restore original value!
 Q
SET70X(ORDER) ; update 9002313.512 fields 7.01, 7.02, 7.03 ; ABSP*1.0T7*8
 ; ORDER = 1, 2, 3
 N INS,SAVEDA,FN
 S INS=$$GET^DDSVAL(DIE,.DA,.03,"I") ; insurer IEN
 S FN=9002313.512 ; the LINE ITEMS multiple
 M SAVEDA=DA K DA S DA=SAVEDA(1),DA(1)=SAVEDA(2)
 D PUT^DDSVAL(FN,.DA,"7.0"_ORDER,INS,,"I")
 K DA M DA=SAVEDA ; restore original DA
 Q
