ADGICPQ ; IHS/ADC/PDW/ENM - CHART DEFICIENCY LIST BY PROV ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 K ^TMP("DGZICPL",$J)
A ;--main
 D DELDT,HDH,PROV I $D(DIRUT) D Q Q
 D COPY I $D(DIRUT) D Q Q
 D SUMM I $D(DIRUT)!(Y=-1) D Q Q
 D SCRN I $D(DIRUT) D Q Q
 D DEV I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D:'DGPR PA D:DGPR P1 D ^ADGICPP,Q
 Q
 ;
DELDT ;--delinquent chart date (today-(30days+holidaydays))
 N X,Y,Z,X1,X2 S Z=$P($G(^DG(43,1,9999999.02)),U,3)
 S X1=DT,X2=-$S(Z:Z,1:30) D C^%DTC
 F Y=0:0 S X=$O(^HOLIDAY(X)) Q:'X!(X>DT)  S Y=Y+1
 S X1=DT,X2=-$S(Z:Z,1:30)-Y D C^%DTC S DGDEL=X Q
 ;
HDH ;--intro
 W !!!?23,"Chart Deficiency List By Provider",!!
 W !!?10,"Charts with a discharge date earlier than "
 W !?29,$E(DGDEL,4,5)_"/"_$E(DGDEL,6,7)_"/"_$E(DGDEL,2,3)
 W !?15,"will be considered delinquent!" Q
 ;
PROV ;--all providers or just one?
 I '$D(^XUSEC("DGZICPALL",DUZ)) D SELF Q
 K DIR S DIR("A")="For All Providers",DIR(0)="Y",DIR("B")="YES"
 S DIR("?",1)="Answer YES to print the list for all providers."
 S DIR("?",2)="Answer NO to select sort logic.",DIR("?")=" "
 S (DGSCN,DGOPT,DGPR)=0 D ^DIR Q:Y  Q:$D(DIRUT)
 ;--select option
 W !!,"(1) for a Service",!,"(2) for a Class",!,"(3) for a Provider"
 K DIR S DIR("A")="Which Option (number)",DIR(0)="N^1:3"
 D ^DIR S DGOPT=+Y  Q:$D(DIRUT)
 ;--class
 I DGOPT=2 D  Q
 . K DIR S DIR("A")="Which Class",DIR(0)="P^7:EQZM"
 . D ^DIR S DGSCN=+Y
 ;--specialty
 I DGOPT=1 D  Q
 . K DIR S DIR("A")="Which Specialty",DIR(0)="P^45.7:EQZM"
 . D ^DIR S DGSCN=+Y
 ;--select provider
 K DIC S DIC("A")="Which Provider:  ",DIC=200,DIC(0)="AEQZM"
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 D ^DIC S DGPR=+Y Q
 ;
SELF ; -- set user to only provider for report
 W !!,"I will print Incomplete/Delinquent Charts for "
 W $P($G(^VA(200,DUZ,0)),U),!!
 S DGPR=DUZ
 Q
 ;
COPY ;--number of copies
 K DIR S DIR("A")="How Many Copies",DIR(0)="N^1:10",DIR("B")=1
 D ^DIR S DGNUM=Y Q
 ;
SUMM ;--print summaries at end of each provider?
 W !!,"Include in Report:",!,"(1) Individual Provider Lists Only"
 W !,"(2) Summary Page Only",!,"(3) BOTH"
 K DIR S DIR(0)="N^1:3",DIR("A")="Choose number"
 D ^DIR S DGSUMPG=Y Q
 ;
SCRN ;--include awaiting trans deficiency?
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Include 'AWAITING TRANS' deficiencies"
 D ^DIR S DGSCRN='Y Q
 ;
DEV ;--device selection
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ;--queued output     
 K IO("Q") S ZTRTN="EN^ADGICPQ",ZTDESC="PRINT CHART DEFICIENCY LIST"
 N I F I="DGPR","DGDEL","DGNUM","DGSUMPG","DGSCRN","DGOPT","DGSCN" S ZTSAVE(I)=""
 D ^%ZTLOAD,^%ZISC K ZTSK Q
 ;
EN ;--queued entry point
 D:'DGPR PA D:DGPR P1 D ^ADGICPP,Q Q
 ;
PA ;--all providers
 F  S DGPR=$O(^ADGIC("AC",DGPR)) Q:'DGPR  D
 . I DGOPT=2 D:$P($G(^VA(200,+DGPR,"PS")),U,5)=DGSCN P1 Q
 . D P1
 Q
 ;
P1 ;--one provider
 N DFN,DS,PM
 S DFN=0 F  S DFN=$O(^ADGIC("AC",DGPR,DFN)) Q:'DFN  D
 . F DS=0:0 S DS=$O(^ADGIC("AC",DGPR,DFN,DS)) Q:'DS  D
 .. I DGOPT=1,$P($G(^ADGIC(DFN,"D",DS,0)),U,4)'=DGSCN Q
 .. F PM=0:0 S PM=$O(^ADGIC("AC",DGPR,DFN,DS,PM)) Q:'PM  D 1
 Q
 ;
1 ;
 N NM,CHT,N,SUM,OP,PRN,CD,DSD
 S NM=$P($G(^DPT(DFN,0)),U),CHT=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 ;discharge date ;date summary dictated ;date op report dictated
 S N=^ADGIC(DFN,"D",DS,0),DSD=$P(N,U),SUM=$P(N,U,6),OP=$P(N,U,8)
 S PRN=$P($G(^VA(200,+DGPR,0)),U)
 ;--chart deficiencies
 N X,X1 S CD="",X=0 F  S X=$O(^ADGIC(DFN,"D",DS,"P",PM,"C",X)) Q:'X  D
 . S X1=$P(^ADGIC(DFN,"D",DS,"P",PM,"C",X,0),U)
 . I DGSCRN Q:^ADGCD(X1,0)["AWAITING TRANS"
 . ;Q:^ADGCD(X1,0)["CODED A SHEET"
 . S CD=$S(CD="":X1,1:CD_U_X1)
 ;--utility
 Q:CD=""  S ^TMP("DGZICPL",$J,PRN,DSD,NM,DFN)=CHT_U_SUM_U_OP_U_CD Q
 ;
Q ;--cleanup
 K DGPR,DIR,POP,DGFLG,DGDEL,DGSUMPG,DGSCRN,DGNUM,DGOPT,DGSCN
 D HOME^%ZIS Q
