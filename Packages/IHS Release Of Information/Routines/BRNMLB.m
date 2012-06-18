BRNMLB ; IHS/OIT/LJF - ROI MAILING LABELS  
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 01/24/2008 PATCH 1 Added routine; smae label spacing as Pat Reg
 ;
 ;
 NEW IEN,IEN2,PARTY,NAME,DATE,METH,COUNT,N,BRNCOP,X,Y,ARRAY,BRNJOB
 S BRNJOB=$J
 K ^TMP("BRNMLB",BRNJOB)
 ;
 ; loop through and collect disclosures
 S IEN=0 F  S IEN=+$$READ^BRNU("PO^90264:AEMQZ","Select Disclosure") Q:IEN<1  D
 . K PARTY S COUNT=0
 . ;
 . ; now find receiving parties for labels
 . S IEN2=0 F  S IEN2=$O(^BRNREC(IEN,23,IEN2)) Q:'IEN2  D
 . . S NAME=$$GET1^DIQ(90264.023,IEN2_","_IEN,.01)            ;receiving party name
 . . S DATE=$$GET1^DIQ(90264.023,IEN2_","_IEN,.02) Q:DATE=""  ;no label needed if no disclosure date
 . . S METH=$$GET1^DIQ(90264.023,IEN2_","_IEN,.03)            ;dissemination method
 . . S COUNT=COUNT+1,PARTY(COUNT)=IEN2_U_NAME_U_DATE_U_METH
 . ;
 . I COUNT=0 W !?5,"No receiving party found for labels; Not added to list",! Q
 . ;
 . I COUNT=1 S ^TMP("BRNMLB",BRNJOB,IEN,$P(PARTY(1),U))=PARTY(1) W !?5,$P(PARTY(1),U,2)," added to list",! Q
 . ;
 . ;   if more than one found, see if all need labels
 . E  K ARRAY D
 . . S N=0 F  S N=$O(PARTY(N)) Q:'N  D
 . . . S ARRAY(N)=$J(N,2)_": "_$$PAD($P(PARTY(N),U,2),30)_$$PAD($P(PARTY(N),U,3),20)_$P(PARTY(N),U,4)
 . . S Y=$$READ^BRNU("L^1:"_COUNT_":0"," Select ALL Receiving Parties for Labels",,,,.ARRAY) I Y<1 Q
 . . F  S X=$P(Y,",") Q:X=""  D
 . . . S ^TMP("BRNMLB",BRNJOB,IEN,$P(PARTY(X),U))=PARTY(X)
 . . . S Y=$P(Y,",",2,99)
 ;
 ; quit if none found or selected
 I '$D(^TMP("BRNMLB",BRNJOB)) Q
 ;
 ; ask how many copies
 S BRNCOP=$$READ^BRNU("N^1:5","How many COPIES of each label",1) Q:BRNCOP<1
 ;
 ;ask for device
 W !!?15,"(NOTE: Mailing Labels need to be loaded in the printer.)"
 D ZIS^BRNU("PQ","START^BRNMLB","ROI MAILING LABELS","BRNCOP;BRNJOB")
 Q
 ;
START ;EP; entry from queuing; start of print process
 U IO
 NEW IEN,IEN2,NAME,X,STREET,CITY,DFN,COPY
 ;
 ; loop through temp global for receiving parties
 S IEN=0 F  S IEN=$O(^TMP("BRNMLB",BRNJOB,IEN)) Q:'IEN  D
 . S IEN2=0 F  S IEN2=$O(^TMP("BRNMLB",BRNJOB,IEN,IEN2)) Q:'IEN2  D
 . . S NAME=$P(^TMP("BRNMLB",BRNJOB,IEN,IEN2),U,2)
 . . ;
 . . ; if party'=PATIENT then find address in ROI REQ PARTY file
 . . I NAME'="PATIENT" D  Q
 . . . S X=+$G(^BRNREC(IEN,23,IEN2,0)) Q:'X
 . . . S STREET=$$GET1^DIQ(90264.1,X,.03)
 . . . S CITY=$$GET1^DIQ(90264.1,X,.04)_", "_$$GET1^DIQ(90264.1,X,.05)_"  "_$$GET1^DIQ(90264.1,X,.06)
 . . . F COPY=1:1:BRNCOP W NAME,!,STREET,!,CITY,!!!!
 . . ;
 . . ; for PATIENT, reset printable name
 . . S DFN=$$GET1^DIQ(90264,IEN,.03,"I") Q:'DFN
 . . S NAME=$$NAMEPRT^BRNU(DFN)
 . . ;
 . . ; for PATIENT, look for mailing address in ROI file
 . . S STREET=$$GET1^DIQ(90264,IEN,2801) I STREET]"" D  Q
 . . . S CITY=$$GET1^DIQ(90264,IEN,2802)_", "_$$GET1^DIQ(90264,IEN,2803)_"  "_$$GET1^DIQ(90264,IEN,2804)
 . . . F COPY=1:1:BRNCOP W NAME,!,STREET,!,CITY,!!!!
 . . ;
 . . ; else look in Patient Registration
 . . S STREET=$$GET1^DIQ(9000001,DFN,1602.2)
 . . S CITY=$$GET1^DIQ(9000001,DFN,1603.2)_", "_$$GET1^DIQ(9000001,DFN,1604.2)_"  "_$$GET1^DIQ(9000001,DFN,1605.2)
 . . F COPY=1:1:BRNCOP W NAME,!,STREET,!,CITY,!!!!
 ;
 ;close device
 D ^%ZISC
 K ^TMP("BRNMLB",BRNJOB)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ;EP -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
