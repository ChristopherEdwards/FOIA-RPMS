ICDPREV ; IHS/ANMC/MWR - PRE-INIT FOR (IHS) DRG GROUPER ; AUGUST 14, 1992
 ;; VERSION 8.0;DRG GROUPER;;AUG 14, 1992
 ;ALB/GRR/EG -  PRE-INIT DRG GROUPER ; JAN 5 1990
 ;;8.0
 S:'$D(DTIME) DTIME=999
 ;
 G IHS  ; DELETE NEITHER DATA NOR DD'S  ;IHS/ANMC/MWR 12/30/91
 ;
 W !!,"This routine will DELETE both the data and data dictionary",!,"of the ICD Diagnosis (file 80) and ICD Operation/",!,"Procedure (file 80.1) files!!"
RD R !!,"Are you sure you want to do this? NO//",X:DTIME S:X="" X="N" G HELP:X["?",DONT:X="^"!(X["N")
 S U="^" D DT^DICRW F DIU=80,80.1 S DIU(0)="" D EN^DIU2 K DIU
 S X=0 F I=1:1 S X=$O(^ICD9(X)) Q:X=""  K ^ICD9(X)
 S X=0 F I=1:1 S X=$O(^ICD0(X)) Q:X=""  K ^ICD0(X)
 W !,"Routine completed, data and dictionaries deleted!"
 Q
DONT W !!,*7,"Nothing Deleted!" Q
HELP W !!,"Answer 'Yes' if you want to delete the data and dictionaries, otherwise",!,"answer 'No'" G RD
 ;
 ;
IHS ; CLEAR OUT OLD ^DD NODES
 D DT^DICRW
ICD9 ;
 K ^DD(80,505)
 K ^DD(80,500055)
 K ^DD(80,"B","ANTIBIOTIC DIAGNOSIS?")
 K ^DD(80,"B","COMPLICATION")
 K ^DD(80,"GL",500)
 K ^DD(80,"GL",505)
 K ^DD(80,0,"IX","ACOM")
 S DIU="80.01",DIU(0)="S" D EN^DIU2
 S DIU="80.02",DIU(0)="S" D EN^DIU2
 S DIU="80.03",DIU(0)="S" D EN^DIU2
ICD0 ;
 K ^DD("80.1",500055)
 K ^DD("80.1","B","ANTIBIOTIC OPERATION?")
 K ^DD("80.1","GL",500)
 K ^DD(80,0,"IX","AZ")
 S DIU="80.11",DIU(0)="S" D EN^DIU2
 S DIU="80.13",DIU(0)="S" D EN^DIU2
 S DIU="80.14",DIU(0)="S" D EN^DIU2
