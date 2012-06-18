ACHSYEX ;IHS/SET/GTH - EXTRACT SELECTED DOCS TO FILE ; [ 12/06/2002  10:36 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - New routine.
 ;
 ; Extract CHS Purchase Order info to a file (screen) in external
 ; format.  Format choices are R=Record, or C=Captioned.
 ; You'll need to know the Record format in order to read in the data.
 ; The Captioned format begins each record with "BEGIN" and ends with
 ; "END", only fields with data are written, and the first piece of the
 ; line is the field LABEL.
 ; You'll be asked for:
 ;      (1)  Begin and end document;
 ;      (2)  Device;
 ;      (3)  [R]ecord or [C]aptioned format.
 ; You can press the ESC key anytime to stop.
 ;
 W !!,"You'll be asked for a beginning and ending P.O. number."
 W !,"The info from the selected P.O.(s) will be extracted to the selected Device."
 W !,"Press the ESCAPE key to stop.",!!
 Q:'$$DIR^XBDIR("E")
 ;
 NEW ACHSBPO,ACHSDIEN,ACHSDR,ACHSEPO,ACHSR,ACHSTIEN
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
 D ^%ZIS
 Q:POP
 ;
 D @($$DIR^XBDIR("S^R:Record;C:Captioned"))
 ;
 D ^%ZISC,RTRN^ACHS
 ;
 Q
 ;
R ; --- Record output
 F  S ACHSBPO=$O(^ACHSF(DUZ(2),"D","B",ACHSBPO)) Q:'(ACHSBPO=+ACHSBPO)!(ACHSBPO>ACHSEPO)  D  Q:$$STOP
 . S ACHSDIEN=$O(^ACHSF(DUZ(2),"D","B",ACHSBPO,0))
 . U IO(0)
 . W !!,"Processing ",$$NUM(ACHSBPO),", to end at ",$$NUM(ACHSEPO),".",!
 . W !!,"Press the ESCAPE (Esc) key to stop...",!
 . U IO
 . S ACHSR="DOC^"
 . F ACHSDR=.01,1,2,3,4,5,6,7,8,9,10,11,12,13,13.1,13.2 S ACHSR=ACHSR_$$GET1^DIQ(9002080.01,ACHSDIEN_","_DUZ(2)_",",ACHSDR)_U
 . W ACHSR,!
 . S ACHSTIEN=0,ACHSR="TRA^"
 . F  S ACHSTIEN=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHSTIEN)) Q:'ACHSTIEN  D
 .. S ACHSR=ACHSR_$$GET1^DIQ(9002080.01,ACHSDIEN_","_DUZ(2)_",",.01)_U
 .. F ACHSDR=.01,1,2,3,4,5,6,7 S ACHSR=ACHSR_$$GET1^DIQ(9002080.02,ACHSTIEN_","_ACHSDIEN_","_DUZ(2)_",",ACHSDR)_U
 .. W ACHSR,!
 .. S ACHSR="TRA^"
 ..Q
 . U IO(0)
 .Q
 ;
 Q
 ;
C ; --- Captioned output.
 NEW ACHSDA
 S ACHSDA(1)=DUZ(2)
 F  S ACHSBPO=$O(^ACHSF(ACHSDA(1),"D","B",ACHSBPO)) Q:'(ACHSBPO=+ACHSBPO)!(ACHSBPO>ACHSEPO)  D  Q:$$STOP
 . S ACHSDA=$O(^ACHSF(ACHSDA(1),"D","B",ACHSBPO,0))
 . U IO(0)
 . W !!,"Processing ",$$NUM(ACHSBPO),", to end at ",$$NUM(ACHSEPO),".",!
 . W !!,"Press the ESCAPE (Esc) key to stop...",!
 . U IO
 . D RECORD(9002080.01,.ACHSDA)
 . U IO(0)
 .Q
 ;
 Q
 ;
RECORD(ACHSFILE,ACHSDA) ; Write all fields in one sub-file record.
 W "BEGIN RECORD "_$P($P(^DD(ACHSFILE,0),U,1)," SUB-FIELD",1),!
 NEW ACHSFLD,ACHSIENS
 S ACHSIENS=$$IENS^DILF(.ACHSDA),ACHSFLD=0
 F  S ACHSFLD=$O(^DD(ACHSFILE,ACHSFLD)) Q:'ACHSFLD  D
 . I $P(^DD(ACHSFILE,ACHSFLD,0),U,2) D SUBFILE(+$P(^(0),U,2),.ACHSDA) Q
 . S %=$$GET1^DIQ(ACHSFILE,ACHSIENS,ACHSFLD)
 . Q:'$L(%)
 . W $P(^DD(ACHSFILE,ACHSFLD,0),U,1),U,%,!
 .Q
 W "END RECORD "_$P($P(^DD(ACHSFILE,0),U,1)," SUB-FIELD",1),!
 Q
 ;
SUBFILE(ACHSFILE,ACHSDA) ; $O thru a subfile, all records.
 NEW ACHSREF,DA
 S ACHSREF=""
 D EN^XBSFGBL(ACHSFILE,.ACHSREF)
 S ACHSREF=$E(ACHSREF,1,($L(ACHSREF)-1))_")"
 F %=1:1 Q:'$D(ACHSDA(%))  S DA(%+1)=ACHSDA(%)
 S DA(1)=ACHSDA,DA=0
 F  S DA=$O(@ACHSREF) Q:'DA  D RECORD(ACHSFILE,.DA)
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
