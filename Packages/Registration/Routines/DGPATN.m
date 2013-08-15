DGPATN ;ALB/MRL - NEW PATIENT ENTRY ; 11/4/09 8:57pm
 ;;5.3;PIMS;**41,278,1007,1015,1016**;JUN 30, 2012;Build 20
 ;IHS/ANMC/LJF 8/25/2000 make sure DFN>0 in S subroutine
 ;IHS/OIT/LJF 4/4/2007 PATCH 1007 for merge project 
 ;Name Changed/Patient Deleted Bulletin
 I $S('$D(DFN):1,'$D(X):1,1:0) Q
 I $D(DGNEWVAL),(DGNEWVAL=X) Q  ; edit and edited to same value
 S DGDATA=X D ^DGPATV S DGB=$S(DGNAME'=X:3,1:9) G Q:'DGB S XMSUB="PATIENT "_$S(DGB=3:"NAME CHANGED",1:"DELETED")
 ;
 ;Delete entries in PT/IHS file when entries deleted from PT file.
 I XMSUB="PATIENT DELETED" D
 . Q:$G(XDRGID)  ;IHS/OIT/LJF 4/4/2007 skip if within patient merge
 . N DA,DIK
 . S DA=DFN,DIK="^AUPNPAT(" D ^DIK
 ;
 S DGTEXT(1,0)="NAME:  "_DGNAME,DGTEXT(2,0)="SSN :  "_$P(SSN,"^",2),DGTEXT(3,0)="DOB :  "_$P(DOB,"^",2),DGTEXT(4,0)="" I DGB=3 S DGTEXT(5,0)="Previous name was '"_DGDATA_"'."
 G T
 ;
S ;SSN Changed/New Patient Added Bulletin
 ;I $S('$D(DFN):1,'$D(X):1,1:0) Q  ;IHS/ANMC/LJF 8/25/2000
 I $S('$G(DFN):1,'$D(X):1,1:0) Q  ;IHS/ANMC/LJF 8/25/2000
 S DGDATA=X D ^DGPATV S DGB=$S(SSN=X:2,SSN="UNSPECIFIED":2,DGDATA'=$P(SSN,"^",1):4,1:0) I 'DGB G Q
 S XMSUB=$S(DGB=2:"NEW PATIENT ADDED TO SYSTEM",1:"SSN CHANGED"),DGTEXT(1,0)="NAME:  "_DGNAME,DGTEXT(2,0)="SSN :  "_$E(DGDATA,1,3)_"-"_$E(DGDATA,4,5)_"-"_$E(DGDATA,6,10),DGTEXT(3,0)="DOB :  "_$P(DOB,"^",2)
 I DGB=4 S DGTEXT(4,0)="",DGTEXT(5,0)="Previous SSN was '"_$P(SSN,"^",2)_"'."
 I DGB=2 D H^DGUTL D       ;New patient Who & When
 .N DGFDART
 .S DGFDART(1,2,DFN_",",.097)=DGDATE
 .S:$G(DUZ) DGFDART(1,2,DFN_",",.096)=DUZ
 .D UPDATE^DIE(,"DGFDART(1)")
T K XMTEXT D ^DGBUL
Q S X=DGDATA D KILL^DGPATV K DGDATA,DGTIME,DGDATE Q
