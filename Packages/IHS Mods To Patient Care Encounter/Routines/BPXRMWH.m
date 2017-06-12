BPXRMWH ; IHS/CIA/MGH - Women's health reminders. ;13-Jan-2016 09:57;DU
 ;;2.0;CLINICAL REMINDERS;**1001,1006**;Feb 04, 2005;Build 5
 ;===================================================================
 ;This routine will be used as a computed finding for the last pap smear
 ;and the last mammogram
 ;=====================================================================
LASTPAP(DFN,TEST,DATE,VALUE,TEXT) ;EP; -- returns last pap date and result
 NEW N,Y,BW,LINE
 I $P(^DPT(DFN,0),U,2)="M" Q ""
 S N=0 F  S N=$O(^BWPCD("C",DFN,N)) Q:'N  D
 .S Y=^BWPCD(N,0)
 .I $P(Y,U,4)=1 S DATE=$P(Y,U,12) D
 ..S BW("PAP",9999999-DATE)=DATE_U_$P(Y,U,5)_U_N
 I '$D(BW("PAP")) S TEST=0,DATE="",TEXT="No PAP on record" Q
 S N=$O(BW("PAP",0))
 I 'N S TEST=0,DATE="",TEXT="No PAP on record"
 E  D
 .S N=BW("PAP",N)
 .S TEST=1,DATE=(+N)
 .S TEXT="Result - "_$$GET1^DIQ(9002086.31,$P(N,U,2),.01)
 .S TEXT=TEXT_" ("_$$GET1^DIQ(9002086.1,$P(N,U,3),.14)_")"
 Q
 ;
LASTMAM(DFN,TEST,DATE,VALUE,TEXT) ;EP; -- returns last mammogram date and result
 NEW N,Y,BW,LINE,X
 I $P(^DPT(DFN,0),U,2)="M" Q ""
 S N=0 F  S N=$O(^BWPCD("C",DFN,N)) Q:'N  D
 . S Y=^BWPCD(N,0)
 . S X=+$P(Y,U,4) I (X'=25)&(X'=26)&(X'=28) Q   ;mamo iens are 25,26,28
 . S DATE=$P(Y,U,12)
 . S BW("MAM",9999999-DATE)=DATE_U_$P(Y,U,5)_U_N_U_$P(Y,U,4)
 I '$D(BW("MAM")) S TEST=0,DATE="",TEXT="No Mammogram on record" Q
 S N=$O(BW("MAM",0))
 I 'N S TEST=0,DATE="",TEXT="No Mammogram on record"
 E  D
 .S N=BW("MAM",N)
 .S TEST=1
 .S DATE=(+N)
 .S TEXT="Result - "_$$GET1^DIQ(9002086.31,+$P(N,U,2),.01)
 .S TEXT=TEXT_" ("_$$GET1^DIQ(9002086.1,$P(N,U,3),.14)_")"
 Q
CURPREG(DFN,TEST,DATE,VALUE,TEXT) ;EP Returns if pt is listed as pregnant in reproductive factors
 N PREG
 S PREG=$$GET1^DIQ(9000017,DFN,1101)
 I PREG="YES" D
 .S TEST=1,DATE=DT,TEXT="Currently Pregnant",VALUE=PREG
 I PREG="NO" D
 .S TEST=0,DATE=DT,VALUE=PREG,TEXT="Not pregnant"
 Q
DEDD(DFN,TEST,DATE,VALUE,TEXT) ;EP Returns true if DEDD+10 days (accounting for overdue) is less then today
 N DEDD,X1,X2,X,EXT,DUE
 S DEDD=$$GET1^DIQ(9000017,DFN,1311,"I")
 S EXT=$$GET1^DIQ(9000017,DFN,1311)
 I +DEDD D
 .S X1=DEDD,X2=+15
 .D C^%DTC
 .S DUE=X
 .I DT<DUE S TEST=1,DATE=DT,TEXT="Apparently Pregnant",VALUE=EXT
 .E  S TEST=0,DATE=DT,VALUE=EXT,TEXT="Apparently not pregnant"
 E  S TEST=0,DATE=DT,VALUE=0,TEXT="No due date found"
 Q
FIRST(DFN,TEST,DATE,VALUE,TEXT) ;Returns true if pt is in first trimester
 N DEDD,EXT,X1,X2,X
 S DEDD=$$GET1^DIQ(9000017,DFN,1311,"I")
 I DEDD="" S TEST=0,DATE=DT,VALUE=0,TEXT="No due date"
 E  D
 .S X1=DEDD,X2=DT D ^%DTC
 .I X>0 D
 ..I ((280-X)/7)<15 D
 ...S VALUE=$J((280-X)/7,4,1)_" weeks"
 ...S TEST=1,DATE=DT,TEXT="First Trimester"
 ..E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in first trimester"
 .E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in first trimester"
 Q
THIRD(DFN,TEST,DATE,VALUE,TEXT) ;Returns true if pt is in second trimester
 N DEDD,EXT,X1,X2,X
 S DEDD=$$GET1^DIQ(9000017,DFN,1311,"I")
 I DEDD="" S TEST=0,DATE=DT,VALUE=0,TEXT="No due date"
 E  D
 .S X1=DEDD,X2=DT D ^%DTC
 .I X>0 D
 ..I ((280-X)/7)>27 D
 ...S VALUE=$J((280-X)/7,4,1)_" weeks"
 ...S TEST=1,DATE=DT,TEXT="Third Trimester"
 ..E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in third trimester"
 .E  D
 ..I X<0&(X>-15) S TEST=1,DATE=DT,VALUE=$J((280-X)/7,4,1)_" weeks",TEXT="Overdue"
 ..E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in third trimester"
 Q
SECOND(DFN,TEST,DATE,VALUE,TEXT) ;Returns true if pt is in second trimester
 N DEDD,EXT,X1,X2,X
 S DEDD=$$GET1^DIQ(9000017,DFN,1311,"I")
 I DEDD="" S TEST=0,DATE=DT,VALUE=0,TEXT="No due date"
 E  D
 .S X1=DEDD,X2=DT D ^%DTC
 .I X>0 D
 ..I (((280-X)/7)>13)&(((280-X)/7)<28) D
 ...S VALUE=$J((280-X)/7,4,1)_" weeks"
 ...S TEST=1,DATE=DT,TEXT="Second Trimester"
 ..E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in second trimester"
 .E  S TEST=0,DATE=DT,VALUE=0,TEXT="Not in second trimester"
 Q
CONCEIVE(DFN,TEST,DATE,VALUE,TEXT) ;EP Returns true if pt has contraceptive method for unable to conceive
 N CONT,NODE,METHOD,IENS,NAME,FOUND
 S FOUND=0
 S CONT=0 F  S CONT=$O(^AUPNREP(DFN,2101,CONT)) Q:CONT=""!(FOUND=1)  D
 .S NODE=$G(^AUPNREP(DFN,2101,CONT,0))
 .Q:+$P(NODE,U,3)     ;Must be active so not ended
 .Q:+$P($G(^AUPNREP(DFN,2101,CONT,1)),U,2)  ;Must not be deleted
 .S IENS=CONT_","_DFN
 .S NAME=$$GET1^DIQ(9000017.02101,IENS,.01)
 .I NAME="NA MENOPAUSE"!(NAME="NA POST HYSTERECTOMY")!(NAME="STERILIZATION (FEMALE)") D
 ..S TEST=1,DATE=DT,TEXT="Unable to conceive",VALUE=NAME,FOUND=1
 .E  S TEST=0,DATE=DT,VALUE=NAME,TEXT="Able to conceive"
 Q
FEEDING(DFN,TEST,DATE,VALUE,TEXT) ;Checks infant feeding against input parameter
 N FEED,FIEN,FTIME,FTYP
 S FEED=$G(TEST)
 Q:FEED=""
 S FTIME=""
 S FTIME=$O(^AUPNVIF("AA",DFN,FTIME)) Q:FTIME=""  D
 .S FIEN=""  S FIEN=$O(^AUPNVIF("AA",DFN,FTIME,FIEN),-1) Q:'+FIEN  D
 ..S FTYP=$$GET1^DIQ(9000010.44,FIEN,.01)
 ..I FTYP=FEED S TEST=1,DATE=$$GET1^DIQ(9000010.44,FIEN,.03,"I"),VALUE=FEED,TEXT="Infant Feeding"
 ..E  S TEST=0,DATE=DT,VALUE=FEED,TEXT="Infant Feeding"
 Q
