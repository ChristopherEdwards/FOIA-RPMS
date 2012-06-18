APCLFY ; IHS/CMI/LAB - FISCAL YEAR process routine ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;CMI/TUCSON/LAB - patch 3 Y2K and fixed FY prompting
 ;
START ;beginning of routine 
 ;beginning Y2K.  This entire routine has been modified.
 ;It was not properly handling FY's that begin in a month other
 ;than October or January.  This really isn't related to the Year
 ;2000.  Years were being handled properly, it is the calculating
 ;of the beginning and ending dates of the FY that was not
 ;working right.  CMI/TUCSON/LAB 11/4/1998
 ;Y2000
 K APCL
 I $P($G(^APCCCTRL(DUZ(2),0)),U,8)]"" D MONTH
 E  S APCL("FY MONTH")=10
GETFY ;get FY
 K %DT S %DT="AE",%DT("A")="Enter FISCAL YEAR:  ",%DT("B")=(1700+$E(DT,1,3)) D ^%DT K %DT
 I Y=-1 S APCL("FY")=-1 D XIT Q
 S APCL("FY")=1700+$E(Y,1,3) ;external year (e.g. 1998, 2000)
 S APCL("FY YEAR")=Y
 I APCL("FY MONTH")'=10 D GETDATES,XIT Q  ;if a beginning month other than 10 or 1 get beginning and ending dates from user
 S APCL("FY BEG DATE")=($E(APCL("FY YEAR"),1,3)-1)_1001
 S APCL("FY WORKING DT")=$$FMADD^XLFDT(APCL("FY BEG DATE"),-1)
 S APCL("FY END DATE")=$E(APCL("FY BEG DATE"),1,3)+1_$E(APCL("FY WORKING DT"),4,7)
 D XIT
 Q
 ;
GETDATES ;new subroutine
 W !!!,"The PCC Master Control file indicates that your FY begins in a month other",!,"than October so you must indicate the beginning and ending dates",!,"for your FY ",APCL("FY"),".",!
B ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning date of FY "_APCL("FY") D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCL("FY")=-1 D XIT Q
 S APCL("FY BEG DATE")=Y
E ;get ending date
 W ! S DIR(0)="D^"_APCL("FY BEG DATE")_"::EP",DIR("A")="Enter ending Date of FY "_APCL("FY") D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G B
 S APCL("FY END DATE")=Y
 S X1=APCL("FY BEG DATE"),X2=-1 D C^%DTC S APCL("FY WORKING DT")=X
 D XIT
 Q
 ;Y2000
 ;end Y2K
 ;K APCL
 ;I $D(^APCCCTRL(DUZ(2))),($P(^(DUZ(2),0),U,8)]"") D MONTH
 ;E  S APCL("FY MONTH")=10
 ;S Y=DT D DD^%DT S APCL("FY TODAY")=Y
FYYEAR ;process FISCAL YEAR 
 ;S %DT="AE",%DT("A")="Enter FISCAL YEAR:  ",%DT("B")=$E(DT,2,3) D ^%DT K %DT
 ;G:Y=-1 XIT
 ;S APCL("FY")=X
 ;I $E(APCL("FY MONTH"),1)=1 S APCL("FY YEAR")=$E(Y,1,3),APCL("FY YEAR")=APCL("FY YEAR")-1
 ;S:'$D(APCL("FY YEAR")) APCL("FY YEAR")=$E(Y,1,3)
FYDATE ;process beginning DATE for fiscal year
 ;S APCL("FY BEG DATE")=APCL("FY YEAR")_APCL("FY MONTH")_"01"
 ;S Y=APCL("FY BEG DATE") X ^DD("DD")
 ;S APCL("FY PRINTABLE BDATE")=Y
WORKDATE ;setup WORKING start day
 ;S X1=APCL("FY BEG DATE"),X2=-1 D C^%DTC
 ;S APCL("FY WORKING DT")=X_".9999"
FYEND ;set up END date for fiscal year
 ;S APCL("FY YR ADD")=$E(APCL("FY WORKING DT"),1,3)+1
 ;S APCL("FY END DATE")=APCL("FY YR ADD")_$E(APCL("FY WORKING DT"),4,7)
 ;S Y=APCL("FY END DATE") X ^DD("DD")
 ;S APCL("FY PRINTABLE EDATE")=Y
XIT ;end of routine
 K %DT
 Q
 ;---------------------------------------------------------------------
MONTH ;setup MONTH for process
 S APCL("FY MONTH")=$P(^APCCCTRL(DUZ(2),0),U,8)
 S APCL("FY MONTH NAME")=$$EXTSET^XBFUNC(9001000,.08,APCL("FY MONTH"))
 S:$L(APCL("FY MONTH"))'=2 APCL("FY MONTH")=0_APCL("FY MONTH")
 Q
FYENDDT ;set up END date for fiscal year
 S APCL("FY YR ADD")=$E(APCL("FY WORKING DT"),1,3)+1
 S APCL("FY END DATE")=APCL("FY YR ADD")_$E(APCL("FY WORKING DT"),4,7)
 S Y=APCL("FY END DATE") X ^DD("DD")
 S APCL("FY PRINTABLE EDATE")=Y
 Q
ENDDATE ;if FLAG=1
 D:APCL("FYEND FLAG")=1 FYENDDT
