ABMEH63 ; IHS/FCS/DRS - HCFA-1500 EMC RECORD FB1 (Medical Segment) ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/FCS/DRS - ABM*2.4*9 - New routine - V2.4 Patch 9 Part 1c
 ;      In response to Envoy edit checks about line item provider.
 ;      (waiting to hear from them what kind of place of service
 ;      field is triggering the message about this record)
 ;
 ;      Rendering Provider info - Part 5c
 ;
 ;      $$TOS - Type of Service - Part 8
 ;
 ;      Rendering Provider Network ID - Part 19a
 ;          Stub only for now - waiting more info from site
 ;          regarding they insurer-specific requirements.
 ;
 ; FB1 line item data:  
 ;   Place of Service Name
 ;   Provider info for each of: 
 ;      Ordering, Referring, Rendering, Supervising
 ;
 ;   $P(ABMRV(J,K),U,7) is the line-item provider
 ;   If that's not present, we have ABMAPRV = the bill's attending prov
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
START ;START HERE
 K ABMR(63),ABMREC(63)
 D LOOP
 S ABME("RTYPE")=63 D S90^ABMERUTL
 S ABMEF("LINE")=ABMREC(63)
 D WRITE^ABMEF19
 Q
LOOP ;LOOP HERE
 N ABMEH63
 D
 .N X S X=$P(ABMRV(J,K,L),U,7) S:'X X=ABMAPRV
 .I X S ABMEH63("RENDERING")=X
 F I=10:10:250 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),63,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(63)=$G(ABMREC(63))_ABMR(63,I)
 Q
10 ;1-3 Record type
 S ABMR(63,10)="FB1"
 Q
20 ;4-5 Sequence 
 S ABMR(63,20)=ABME("S#")
 S ABMR(63,20)=$$FMT^ABMERUTL(ABMR(63,20),"2NR")
 Q
30 ;6-22 Patient Control Number
 S ABMR(63,30)=ABMP("PCN")
 S ABMR(63,30)=$$FMT^ABMERUTL(ABMR(63,30),17)
 Q
40 ;23-39 Line Item Control #
 S ABMR(63,40)=""
 S ABMR(63,40)=$$FMT^ABMERUTL(ABMR(63,40),17)
 Q
50 ;40^33^X^PLACE OF SVC NAME
 S ABMR(63,50)=""
 S ABMR(63,50)=$$FMT^ABMERUTL(ABMR(63,50),33)
 Q
60 ;73^20^X^ORDERING PROVIDER LAST NAME
 S ABMR(63,60)=""
 S ABMR(63,60)=$$FMT^ABMERUTL(ABMR(63,60),20)
 Q
70 ;93^12^X^ORDERING PROVIDER FIRST NAME
 S ABMR(63,70)=""
 S ABMR(63,70)=$$FMT^ABMERUTL(ABMR(63,70),12)
 Q
80 ;105^1^X^ORDERING PROVIDER MI
 S ABMR(63,80)=""
 S ABMR(63,80)=$$FMT^ABMERUTL(ABMR(63,80),1)
 Q
90 ;106^15^X^ORDERING PROVIDER UPIN
 S ABMR(63,90)=""
 S ABMR(63,90)=$$FMT^ABMERUTL(ABMR(63,90),15)
 Q
100 ;121^20^X^REFERRING PROVIDER LAST NAME
 S ABMR(63,100)=""
 S ABMR(63,100)=$$FMT^ABMERUTL(ABMR(63,100),20)
 Q
110 ;141^12^X^REFERRING PROVIDER FIRST NAME
 S ABMR(63,110)=""
 S ABMR(63,110)=$$FMT^ABMERUTL(ABMR(63,110),12)
 Q
120 ;153^1^X^REFERRING PROVIDER MI
 S ABMR(63,120)=""
 S ABMR(63,120)=$$FMT^ABMERUTL(ABMR(63,120),1)
 Q
130 ;154^15^X^REFERRING PROVIDER UPIN
 S ABMR(63,130)=""
 S ABMR(63,130)=$$FMT^ABMERUTL(ABMR(63,130),15)
 Q
140 ;169^20^X^RENDERING PROVIDER LAST NAME
 I $G(ABMEH63("RENDERING")) S ABMR(63,140)=$$LNM^ABMEEPRV(ABMEH63("RENDERING"))
 E  S ABMR(63,140)=""
 S ABMR(63,140)=$$FMT^ABMERUTL(ABMR(63,140),20)
 Q
150 ;189^12^X^RENDERING PROVIDER FIRST NAME
 I $G(ABMEH63("RENDERING")) S ABMR(63,150)=$$FNM^ABMEEPRV(ABMEH63("RENDERING"))
 E  S ABMR(63,150)=""
 S ABMR(63,150)=$$FMT^ABMERUTL(ABMR(63,150),12)
 Q
160 ;201^1^X^RENDERING PROVIDER MI
 I $G(ABMEH63("RENDERING")) S ABMR(63,160)=$$MI^ABMEEPRV(ABMEH63("RENDERING"))
 E  S ABMR(63,160)=""
 S ABMR(63,160)=$$FMT^ABMERUTL(ABMR(63,160),1)
 Q
170 ;202^15^X^RENDERING PROVIDER UPIN
 I $G(ABMEH63("RENDERING")) S ABMR(63,170)=$$UPIN^ABMEEPRV(ABMEH63("RENDERING"))
 E  S ABMR(63,170)=""
 S ABMR(63,170)=$$FMT^ABMERUTL(ABMR(63,170),15)
 Q
180 ;217^20^X^SUPERVISING PROVIDER LAST NAME
 S ABMR(63,180)=""
 S ABMR(63,180)=$$FMT^ABMERUTL(ABMR(63,180),20)
 Q
190 ;237^12^X^SUPERVISING PROVIDER FIRST NAME
 S ABMR(63,190)=""
 S ABMR(63,190)=$$FMT^ABMERUTL(ABMR(63,190),12)
 Q
200 ;249^1^X^SUPERVISING PROVIDER MI
 S ABMR(63,200)=""
 S ABMR(63,200)=$$FMT^ABMERUTL(ABMR(63,200),1)
 Q
210 ;250^15^X^SUPERVISING PROVIDER NPI
 S ABMR(63,210)=""
 S ABMR(63,210)=$$FMT^ABMERUTL(ABMR(63,210),15)
 Q
220 ;265^15^X^SUPERVISING PROVIDER UPIN 
 S ABMR(63,220)=""
 S ABMR(63,220)=$$FMT^ABMERUTL(ABMR(63,220),15)
 Q
230 ;280^20^X^FILLER-FB1-280
 S ABMR(63,230)=""
 S ABMR(63,230)=$$FMT^ABMERUTL(ABMR(63,230),20)
 Q
240 ;300^15^X^RENDERING PROVIDER NETWORK ID (ENVOY SPECIAL)
 S ABMR(63,240)="" ; 
 S ABMR(63,240)=$$FMT^ABMERUTL(ABMR(63,240),15)
 Q
250 ;315^6^X^FILLER-FB1-315
 S ABMR(63,250)=""
 S ABMR(63,250)=$$FMT^ABMERUTL(ABMR(63,250),6)
 Q
EX(ABMX,ABMY,ABMZ) ;EXTRINSIC FUNCTION HERE
 ;X=data element, Y=bill internal entry number
 S ABMP("BDFN")=ABMY D SET^ABMERUTL
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(63,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(63,ABMX),ABME,ABMX,ABMY,ABMZ,ABM
 Q Y
 ;
TOSTSTL ; Loop to test all
 D TOSTST("")
 N X S X=""
 F  S X=$O(^ICPT("B",X)) Q:X=""  D TOSTST(X)
 Q
 ;
TOSTST(CPT,J) ; devel - test $$TOS logic
 W "CPT=",CPT
 W " " D
 . I CPT]"" D
 . . N X S X=$O(^ICPT("B",CPT,0)) Q:'X
 . . W $$GET1^DIQ(81,X_",","SHORT NAME")
 . . W " ",$$GET1^DIQ(81,X_",","CPT CATEGORY")
 . W " -> TOS="
 . S:'$D(J) J=21
 N K,ABMRV S K=1,ABMRV(J,K,L)=U_CPT
 W $$TOS,! Q
 ;
TOS() ;EP - type of service (where x=multiple from 3P Bill File)
 ; Called from ABMEH61 and put here because we have $S well <10000
 ; Modified from TOS^ABMERUTL - some added precision
 ; We have J, K, and ABMRV(J,K)
 N CPT,TOS S CPT=$P(ABMRV(J,K,L),U,2)
 I CPT]"" D  Q:$D(TOS) TOS
 . I CPT="A9220" S TOS=10 Q  ; Blood
 . S CPTD0=$O(^ICPT("B",CPT,0)) Q:'CPTD0
 . N X S X=$G(^ICPT(CPTD0,0)) Q:X=""
 . I X["RADIATION THERAPY" S TOS="06" Q  ; Radiation Therapy
 . I X["CONSULTATION" S TOS="03" Q  ; Consultation
 . I X["OPINION" D  Q:$D(TOS)
 . . I X["2ND" S TOS="20" Q  ; Second Surgical Opinion
 . . I X["3RD" S TOS="21" Q  ; Third Surgical Opinion
 . I X["DIAGNOSTIC RADIOLOGY" S TOS="04" Q
 . N CAT S CAT=$P(X,U,3) Q:'CAT
 . S X=$G(^DIC(81.1,CAT,0)) Q:X=""
 . I $P(X,U,2)'="m" D  Q:X=""  ; replace X w/corr "major" node
 . . N MAJ S MAJ=$P(X,U,3) I MAJ="" S X="" Q
 . . S X=$G(^DIC(81.1,MAJ,0))
 . I X["MEDICINE" S TOS="01" Q
 . I X["SURGERY" S TOS="02" Q
 . I X["RADIOLOGY" S TOS="04" Q
 . I X["LABORATORY" S TOS="05" Q
 . I X["ANESTHESIA" S TOS="07" Q
 ; and if we didn't find it, set it based on J subscript
 Q:J=21 "02"
 Q:J=35 "04"
 Q:J=37 "05"
 Q:J=39 "07"
 Q:J=23 99
 Q "01"
