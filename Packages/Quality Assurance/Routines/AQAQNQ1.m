AQAQNQ1 ;IHS/ANMC/LJF - MORE CREDENTIALS REPORTS; [ 04/03/95  7:37 AM ]
 ;;2.2;STAFF CREDENTIALS;**2**;01 OCT 1992
 ;
MLIC ;EP;****> prints listing of all medical licenses due to expire
 W @IOF,!!?20,"MEDICAL LICENSURES DUE TO EXPIRE",!!
 W ?5,"This report will print a listing of all medical licenses"
 W !,"that are due to expire and those already overdue."
 W !,"The report will list the providers in alphabetical order.",!!
 ;
 K DIR S DIR(0)="N0^1:12",DIR("B")=1
 S DIR("A")="Print Licenses to come due how many months from now?"
 S DIR("?",1)="Enter 0 (zero) to see only those due NOW;"
 S DIR("?",2)="Enter 1 to see those due in the coming month;"
 S DIR("?",3)="Enter 2 to see those due in the next 2 months;"
 S DIR("?",4)="And so on up to 12 months."
 S DIR("?")="All reports include those currently OVERDUE"
 D ^DIR G MEND:$D(DIRUT) S AQAQNUM=Y
 S X1=DT,X2=Y*30 D C^%DTC S AQAQDUE=X
 ;
 ;***> select type of report
TYPE W ! K DIR S DIR("A",1)="Select Sorting Order for Report:"
 S DIR("A",2)="     1.  ALPHABETICALLY (By Provider Name)"
 S DIR("A",3)="     2.  By PROVIDER CLASS"
 S DIR("A",4)="     3.  By STAFF CATEGORY"
 S DIR("A")="Select (1, 2, or 3):  ",DIR(0)="NAO^1:3" D ^DIR
 G MEND:$D(DTOUT),MEND:X="",MEND:$D(DUOUT),TYPE:Y=-1 S AQAQTYP=Y
 I AQAQTYP=1 S AQAQSRT="" G MDEV
 ;
MALL ;***> choose one or all classes or categories
 K DIR S DIR(0)="Y"
 S DIR("A")=$S(AQAQTYP=2:"Print for All Classes",1:"Print for All Categories")
 S DIR("B")="NO" D ^DIR I Y=1 S AQAQSRT="" G MDEV ;all wards or serv
 I $D(DIRUT) G MEND ;check for timeout,"^", or null
 ;
MCHOOSE ;***> choose which class or category to print
 I AQAQTYP=2 D  G TYPE:'$D(AQAQSRT) G MDEV
 .K DIR,AQAQSRT S DIR(0)="PO^7:EMQZ" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .S AQAQSRT=$P(Y,U,2)
 E  D  G TYPE:'$D(AQAQSRT)
 .K DIR,AQAQSRT S DIR(0)="9002165,.02" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .S AQAQSRT=Y(0)
 ;
MDEV S %ZIS="NPQ" D ^%ZIS G MEND:POP I '$D(IO("Q")) G MLIC1
 K IO("Q") S ZTRTN="MLIC1^AQAQNQ1",ZTDESC="LICENSES DUE TO EXPIRE"
 F AQAQI="AQAQDUE","AQAQSRT","AQAQTYP","AQAQNUM" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK,AQAQDUE,AQAQSRT,AQAQTYP,AQAQNUM Q
 ;
MLIC1 ;**> set variables then call FileMan print
 S L=0,DIC=9002161.2,FLDS="[AQAQ LICENSE DUE]"
 S DHD="W ?0 D MHDR^AQAQNQ1"
 I AQAQTYP=1 S BY="@PROVIDER",(TO,FR)=""
 I AQAQTYP=2 S BY="@PROVIDER",(TO,FR)=AQAQSRT
 I AQAQTYP=3 S BY="STAFF CATEGORY,@PROVIDER",(TO,FR)=AQAQSRT
 S DIS(0)="S AQAQX=$P(^AQAQML(D0,0),U,2) I AQAQX]"""",(+$G(^VA(200,AQAQX,""I""))=0)!($G(^VA(200,AQAQX,""I""))>DT)" ;IHS/ORDC/LJF PATCH #2
 S IOP=ION,DIS(1)="D LASTMLIC^AQAQDUE I AQAQLAST<AQAQDUE"
 D EN1^DIP
 I '$D(ZTQUEUED) K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR W @IOF
 ;
 ;**> eoj
MEND D KILL^AQAQUTIL Q
 ;
 ;
MHDR ;**> SUBRTN for report header
 W !?8,"*****Confidential Medical Staff Data Covered by Privacy Act*****"
 W !,"Medical Licenses DUE TO EXPIRE in the next "_AQAQNUM_" months "
 S %H=$H D YX^%DTC W ?60,$P(Y,":",1,2)
 W !!,"PROVIDER NAME",?27,"STATE",?39,"EXPIRATION DATE"
 W ! S X="",$P(X,"=",80)="" W X,!!
 Q
