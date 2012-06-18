PXRMPTTX ; SLC/PKR - Routines for taxonomy print templates ;08/03/2000
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;======================================================================
ICD0LIST ;Print expanded list of ICD0 codes.
 N CODE,END,IEN,IND,LOW,HIGH,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,80.1,D1,0)
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?6,"Code",?16,"ICD Operation/Procedure"
 W !,?6,"----",?16,"-----------------------"
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 . S CODE=$TR(IND," ","")
 . S IEN=$O(^ICD0("BA",IND,""))
 . I +IEN>0 S TEXT=$P($G(^ICD0(IEN,0)),U,4)
 . E  S TEXT="Unknown"
 . S IND=$O(^ICD0("BA",IND))
 . W !,?6,CODE,?16,TEXT
 Q
 ;
 ;======================================================================
ICD9LIST ;Print expanded list of ICD9 codes.
 N CODE,END,IEN,IND,LOW,HIGH,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,80,D1,0)
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?6,"Code",?16,"ICD Diagnosis"
 W !,?6,"----",?16,"-------------"
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 . S CODE=$TR(IND," ","")
 . S IEN=$O(^ICD9("BA",IND,""))
 . I +IEN>0 S TEXT=$P($G(^ICD9(IEN,0)),U,3)
 . E  S TEXT="Unknown"
 . S IND=$O(^ICD9("BA",IND))
 . W !,?6,CODE,?16,TEXT
 Q
 ;
 ;======================================================================
ICPTLIST ;Print expanded list of CPT codes.
 N CODE,END,IEN,IND,LOW,HIGH,TEMP,TEXT
 S TEMP=^PXD(811.2,D0,81,D1,0)
 S LOW=$P(TEMP,U,1)
 S HIGH=$P(TEMP,U,2)
 I HIGH="" S HIGH=LOW
 W !!,?6,"Code",?16,"CPT Short Name"
 W !,?6,"----",?16,"--------------"
 S IND=LOW
 S END=HIGH
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 . S CODE=$TR(IND," ","")
 . S IEN=$O(^ICPT("B",IND,""))
 . I +IEN>0 D
 .. S TEMP=$$CPT^ICPTCOD(IEN)
 .. S TEXT=$P(TEMP,U,3)
 . E  S TEXT="Unknown"
 . S IND=$O(^ICPT("B",IND))
 . W !,?6,CODE,?16,TEXT
 Q
 ;
 ;======================================================================
TAXLIST ;Taxonomy list.
 N CODES,CPT,CPTLIST,ICD0,ICD0LIST,ICD9,ICD9LIST,IND,NCODES
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,80,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,80,IND,0)
 . S ICD9LIST(IC)=CODES
 S NCODES=IC
 ;
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,80.1,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,80.1,IND,0)
 . S ICD0LIST(IC)=CODES
 S NCODES=$$MAX^XLFMTH(NCODES,IC)
 ;
 S (IC,IND)=0
 F  S IND=+$O(^PXD(811.2,D0,81,IND)) Q:IND=0  D
 . S IC=IC+1
 . S CODES=^PXD(811.2,D0,81,IND,0)
 . S CPTLIST(IC)=CODES
 S NCODES=$$MAX^XLFMTH(NCODES,IC)
 ;Print the list.
 F IC=1:1:NCODES D
 . S ICD9=$G(ICD9LIST(IC))
 . S ICD0=$G(ICD0LIST(IC))
 . S CPT=$G(CPTLIST(IC))
 . W !,?9,$P(ICD9,U,1),?19,$P(ICD9,U,2)
 . W ?29,$P(ICD0,U,1),?39,$P(ICD0,U,2)
 . W ?49,$P(CPT,U,1),?59,$P(CPT,U,2)
 Q
 ;
