BPXRMWH ; IHS/CIA/MGH - Women's health reminders. ;15-Apr-2008 14:21;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004,1005**;Jun 19, 2000
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
