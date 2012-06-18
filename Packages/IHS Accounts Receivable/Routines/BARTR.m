BARTR ; IHS/SD/LSL - ENTER NEW TRANSACTION DEC 4,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 ; ITSC/SD/LSL - 10/10/02 - V1.7 - NOIS QAA-1200-130051
 ;        Modified NEW to a FILE^DICN call
 ;        Added MSG line tag
 ;
 ; IHS/SD/LSL - 06/09/03 - V1.7 Patch 1
 ;       Added UPLOAD line take to create new transaction for bills
 ;       That are uploaded to AR using Upload by Date or Upload
 ;       3P Bill.
 ;
 ; ********************************************************************
 ;
NEW() ;EP - extrensic call to establish a new transaction
 ; returns 0-lock on file, fm-dt/sec -IEN ; -1 not added
 N X,Y,%,DIC,DINUM,D,DA
 F I=1:1:5 L +^BARTR(DUZ(2)):2 S X=$T Q:X
 I 'X D  Q X
 . W *7,!!,"A/R TRANSACTION FILE LOCKED see your site manager",!!
 F  D NOW^%DTC Q:'$D(^BARTR(DUZ(2),"B",%))
 S X=%
 S DIC="^BARTR(DUZ(2),"
 S DIC(0)="NXL"
 S DLAYGO=90050
 S DINUM=X
 K DD,DO
 D FILE^DICN
 K DLAYGO
 L -^BARTR(DUZ(2))
 Q +Y
 ; *********************************************************************
 ;
EN(BART) ;EP
 ;
 N X,DIC,DA,DR,DIE
 S DR=""
 S X=""
 F  S X=$O(BART(X)) Q:X'>0  S DR=DR_X_"////^S X="_BART(X)_";"
 S DR=$E(DR,1,$L(DR)-1)
 ;
 S BART("DA")=+Y
 I $D(BART("WP")) D
 .S ^BARTR(DUZ(2),BART("DA"),10,0)="^^1^1^2950125^"
 .S %X="BART(""WP"","
 .S %Y="^BARTR(DUZ(2),BART(""DA""),10,"
 .D %XY^%RCR
 Q
 ; *********************************************************************
 ;
DSP(DA) ;EP display transaction (needs DA)
 N BARTMP,I
 D ENP^XBDIQ1(90050.03,DA,".01:500","BARTMP(")
 S I=0
 F  S I=$O(BARTMP(I)) Q:I'>0  W:BARTMP(I)]"" !,I,?10,$P(^DD(90050.03,I,0),U),?40,BARTMP(I)
 D EOP^BARUTL(0)
 Q
 ; *********************************************************************
 ;
TOTAL(BARTRDA) ;EP
 ; - **gather BARTOT(tran.cat.type) totals and ADJ in Ax & Tx
 D
 . D ENP^XBDIQ1(90050.03,BARTRDA,".01;2;3;4;101:103","BART(","I")
 . I $L(BART(102)) S BARTOT("A"_BART(102,"I"))=$G(BARTOT("A"_BART(102,"I")))+BART(2)-BART(3) I 1
 . E  S BARTOT("T"_BART(101,"I"))=$G(BARTOT("T"_BART(101,"I")))+BART(2)-BART(3)
ETOTAL . ;
 . S BARTOT($$NODE)=$G(BARTOT($$NODE))+BART(2)-BART(3)
 Q
 ; *********************************************************************
 ;
NODE() ;
 N X
 S X=BART(101,"I")_"."_BART(102,"I")_"."_BART(103,"I")
ENODE ;
 Q X
 ; *********************************************************************
 ;
PAY() ;EP ** Extrensic for PAYMENT field of transaction file
 ;** If new categories of adjustments or payments are added the
 ;   following code needs to be modified accordingly
 N BART
 D ENP^XBDIQ1(90050.03,D0,"3.5;101;102","BART(","I")
 F I=101,102 S BART(I)=BART(I,"I")
 S BART=BART(3.5)
 ;40 - payment
 I BART(101)=40 Q BART
 ;19 - refund
 I BART(102)=19 Q BART
 ;20 - payment credit
 I BART(102)=20 Q BART
 K BART
 Q ""
 ; *********************************************************************
 ;
ADJ() ;EP - ** Extrensic for ADJUSTMENT field of transaction file
 ;** If new categories of adjustments or payments are added the
 ;   following code needs to be modified accordingly
 N BART
 D ENP^XBDIQ1(90050.03,D0,"3.5;101;102","BART(","I")
 F I=102 S BART(I)=BART(I,"I")
 S BART=""
 F I=3,4,13,14,15,16 I BART(102)=I S BART=BART(3.5) Q
 Q BART
 ; *********************************************************************
 ;
VALADJ(BARTYP)     ;EP - ** Extrensic to return amount when given type of adjustment
 ; uses field 102
 N BARTR,X
 S BARTR=$$VALI^XBDIQ1(90050.03,D0,102)
 I BARTR'=BARTYP Q ""
 S X=$$VAL^XBDIQ1(90050.03,D0,3.5)
 Q X
 ; *********************************************************************
 ;
 ; dd computed field
PAR() ;EP - return 1 if transaction is a PAY!ADJ!REF
 N X,Y
 S X=1
 S Y=$P($G(^BARTR(DUZ(2),D0,1)),U)
 I Y'=39,Y'=40,Y'=43,Y'=108 S X=0
 Q X
 ; *********************************************************************
 ;
PRMBLAMT() ;EP  Extrinsic to return Prime Bill Amount
 ; if tran = 49:BILL NEW field 101 1:p1
 ; if Bill Type = P'rimary field 16 0:p16
 ; return debit field 3 0:p3
 S X=""
 I +$G(^BARTR(DUZ(2),D0,1))'=49 Q X
 I $E($P(^BARTR(DUZ(2),D0,0),U,16))'="P" Q X
 S X=$P(^BARTR(DUZ(2),D0,0),U,3)
 Q X
 ; *********************************************************************
 ;
MSG(X) ; EP - error message
 ;  X = Bill IEN
 N XVAL
 S XVAL=$$GET1^DIQ(90050.01,X,.01)
 W:BARTRIEN'=0 !!,*7,$$CJ^XLFSTR("Could not create an entry in A/R Transaction File.",IOM)
 W !,$$CJ^XLFSTR("Please verify postings for "_XVAL_" and repost if necessary.",IOM)
 Q
 ; ********************************************************************
 ;
UPLOAD() ;
 ; EP - New transaction if bill Uploaded.
 N X,Y,DIC
 F I=1:1:5 L +^BARTR(DUZ(2)):5 S X=$T Q:X
 I 'X Q X     ; File in use. quit.
 S DIC="^BARTR(DUZ(2),"
 S DIC(0)="XLN"
 S DLAYGO=90050
 S BARHRS=230000
 S BARDONE=0
 F  D  Q:BARDONE  Q:BARHRS>235959
 . S BARHRS=BARHRS+1
 . I $E(BARHRS,5,6)=60 D  Q:BARHRS>235959
 . . S BARHRS=$E(BARHRS,1,4)_"00"
 . . S BARHRS=BARHRS+100
 . S X=+($P(@BAR3PUP@("DTAP"),".")_"."_BARHRS)
 . Q:$D(^BARTR(DUZ(2),"B",X))
 . S BARDONE=1
 Q:'BARDONE
 K DD,DO
 D ^DIC
 K DLAYGO
 L -^BARTR(DUZ(2))
 S BARTRIEN=+Y
 Q BARTRIEN
