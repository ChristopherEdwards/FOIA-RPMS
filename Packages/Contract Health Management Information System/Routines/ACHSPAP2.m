ACHSPAP2 ; IHS/ITSC/PMF - MOVE MED DATA TO PATIENT CARE COMPONENT ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Clarify PCC link messages.
 ;I '$$LINK^ACHSPAP1 W !,*7,"FIX THE PARAMETERS!" D RTRN^ACHS Q;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 I '$$LINK^ACHSPAP1 W !,"No link to PCC : ",$P($$LINK^ACHSPAP1,U,2) D RTRN^ACHS Q  ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 ;
 W !!,"You'll be asked for a beginning and ending P.O. number."
 W !,"The medical data for P.O.'s included will be passed to the PCC."
 W !,"Press the ESCAPE key to stop.",!!
 Q:'$$DIR^XBDIR("E")
 ;
 N ACHSBPO,ACHSDIEN,ACHSDOCR,ACHSEPO
BPO ;
 S ACHSBPO=$$PO("Beginning")
 Q:$D(DUOUT)!$D(DTOUT)
EPO ;
 S ACHSEPO=$$PO("Ending")
 G BPO:$D(DUOUT)
 Q:$D(DTOUT)
 ;
 S ACHSBPO=("1"_$E(ACHSBPO)_$P(ACHSBPO,"-",3))-1
 S ACHSEPO="1"_$E(ACHSEPO)_$P(ACHSEPO,"-",3)
 ;
 I ACHSBPO>ACHSEPO W *7,!,"Beginning P.O. is later than the Ending P.O. ??" G BPO
 ;
 F  S ACHSBPO=$O(^ACHSF(DUZ(2),"D","B",ACHSBPO)) Q:'(ACHSBPO=+ACHSBPO)!(ACHSBPO>ACHSEPO)  D  Q:$$STOP
 . S ACHSDIEN=$O(^ACHSF(DUZ(2),"D","B",ACHSBPO,0))
 . S ACHSDOCR=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0))
 . Q:'$P(ACHSDOCR,U,22)
 . Q:'$D(^DPT($P(ACHSDOCR,U,22)))
 . W !!,"Processing ",$$NUM(ACHSBPO),", to end at ",$$NUM(ACHSEPO),".",!
 . D ^ACHSPAP
 . W !!,"Press the ESCAPE (Esc) key to stop...",!
 .Q
 ;
 D RTRN^ACHS
 Q
 ;
STOP() ;
 N X
 R *X:1
 I '(X=27) Q 0
 W *7
 F  R X:0 E  Q  ; Clear Keyboard buffer, if any.
 Q 1
 ;
NUM(X) ;
 Q $E(X,2)_"-"_ACHSFC_"-"_$E(X,3,7)
 ;
PO(ACHS) ;
 W !!!,"Select the ",ACHS," P.O. Number..."
 D ^ACHSUD
 I '$D(ACHSDIEN) S DUOUT="" Q ""
 Q $$DOC^ACHS(0,14)_"-"_$$FC^ACHS(DUZ(2))_"-"_$$DOC^ACHS(0,1)
 ;
