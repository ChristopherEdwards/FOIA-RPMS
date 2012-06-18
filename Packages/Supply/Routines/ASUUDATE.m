ASUUDATE ; IHS/ITSC/LMH -DATE UTILITY FUNCTIONS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which stores various versions of the Date
 ;and time data into local 'Constant' variables ASUK("DT") which are
 ;used by SAMS routines rather than the DT variable.  In this way, a
 ;date may be set before an update is run to be used as the 'As Of' date
 ;for the update. Normally, however the current computer date contained
 ;in variable DT is used to set up the ASUK("DT") array.
DAYTIM ;EP; -SET DATE AND TIME
 D DATE
 D TIME
 I $D(ASUT) S ASUT(ASUT,"TRKY")=ASUK("DT","FM")_"."_ASUK("TIME","F")_"."_DUZ
 Q
DATE ;EP; -SET ASUK("DT")
 N X
 I ($D(ASUK("DT"))#10)=0 D
 .D NOW^%DTC S Y=% X ^DD("DD")
 .D SETDT(X)
 Q
SETDT(X)          ;EP ;
 S ASUK("DT","FM")=X,ASUK("DT")=$P(Y,"@"),ASUK("DT","TIME")=Y
 S ASUK("DT","MOFM")=$E(ASUK("DT","FM"),1,5)_"00"
 S ASUK("DT","ENXYR")=$E(X,1,3)+1_"1231"
 S ASUK("DT","YEAR")=$P(ASUK("DT"),",",2),ASUK("DT","YMD")=$E(X,2,7)
 S ASUK("DT","YR")=$E(X,2,3),ASUK("DT","MO")=$E(X,4,5),ASUK("DT","DA")=$E(X,6,7)
 S ASUK("DT","CFYEDT")=$E(X,1,3)
 S ASUK("DT","MONTH")=$P(ASUK("DT")," ")
 S ASUK("DT","YRMO")=$E(X,2,5)
 S ASUK("DT","FYMO")=ASUK("DT","YRMO")
 S ASUK("DT","FYM#")=$E(ASUK("DT","FYMO"),3,4)+3 S:ASUK("DT","FYM#")>12 ASUK("DT","FYM#")=ASUK("DT","FYM#")-12
 S ASUK("DT","CFY")=ASUK("DT","YR")
 I +ASUK("DT","MO")>9 D
 .S ASUK("DT","CFYEDT")=ASUK("DT","CFYEDT")+1
 .S ASUK("DT","CFY")=$E(ASUK("DT","CFYEDT"),2,3)
 .S ASUK("DT","FYMO")=ASUK("DT","CFY")_ASUK("DT","MO")
 S ASUK("DT","PFYBDT")=ASUK("DT","CFYEDT")-1
 S ASUK("DT","PFY")=$E(ASUK("DT","PFYBDT"),2,3)
 S ASUK("DT","CFYEDT")=ASUK("DT","CFYEDT")_"1231"
 S ASUK("DT","PFYBDT")=ASUK("DT","PFYBDT")_"0131"
 S X1=ASUK("DT","FM"),X2=$E(ASUK("DT","FM"),1,3)_"0101" D ^%DTC
 S ASUK("DT","JUL")=X+1
 Q:'$D(%H)
 S ASUK("DT","H")=$P(%H,","),ASUK("TIME","H")=$P(%H,",",2)
 S ASUK("TIME")=$P(Y,"@",2)
 Q
ASKDATE ;EP -ASK FOR A DATE AND SET ASUK("DT") ARRAY
 N %DT S %DT="AS" D ^%DT S X=Y
 X ^DD("DD")
 D SETDT(X),TIME
 Q
TIME ;EP; -SET ASUK("TIME")
 N X
 S %H=$H D YX^%DTC
 S ASUK("TIME")=$P(Y,"@",2),ASUK("TIME","H")=$P(%H,",",2)
 S ASUK("TIME","F")=$P(ASUK("TIME"),":")_$P(ASUK("TIME"),":",2)_$P(ASUK("TIME"),":",3)
 I ($D(ASUK("DT"))#10) D
 .S ASUK("DT","TIME")=ASUK("DT")_"@"_ASUK("TIME")
 E  D
 .S ASUK("DT","TIME")=Y
 Q
GETRUN ;EP ; -GET RUN FISCAL YEAR AND MONTH
 I ($D(ASUK("DT"))#10)'=1 D DATE
 S DIR(0)="D" D ^DIR K DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUK("DT","RUN")=ASUK("DT","FM")
 S ASUK("DT","RUNMY")=$E(Y,4,5)_$E(Y,2,3)
 S ASUK("DT","RUNMO")=ASUK("DT","MO")
 S ASUK("DT","RUNYR")=ASUK("DT","CFY")
 I $E(ASUK("DT","RUNMO"))=0&($E(ASUK("DT","RUNMO"),2,2))>0 D
 .S ASUK("DT","RUNMO")=$E(ASUK("DT","RUNMO"),2,2)
 Q
SETMO(X) ;EP ; -SET MONTHLY RUN PARAMETERS
 S ASUP("MO")=X
 S ASUP("YR")=$S(X="09"&(ASUK("DT","MO")'="09"):ASUK("DT","PFY"),1:ASUK("DT","CFY"))
 S ASUP("MOYR")=ASUP("MO")_ASUP("YR")
 S ASUP("ERR")=0
 I ASUK("DT","MO")="01",ASUP("MO")="12",ASUK("DT","DA")'>ASUP("MOL") Q
 I ASUK("DT","MO")=ASUP("MO") Q
 I +ASUP("MO")=$S(ASUK("DT","MO")="01":12,1:ASUK("DT","MO")-1),ASUK("DT","DA")<ASUP("MOL") Q
 I ASUP("MO")>ASUK("DT","MO") S ASUP("ERR")=3 Q
 S ASUP("ERR")=2 Q
 Q
SETRUN ;EP ; -SET RUN DATE EQUAL DATE
 I ($D(ASUK("DT"))#10)'=1 D DATE
 S ASUK("DT","RUN")=ASUK("DT","FM")
 ;WAR 5/18/99 REM'd next line & added $E of ASUP("LSMO")
 ;I +$E(ASUK("DT","RUN"),4,5)>+ASUP("LSMO"),ASUP("MOL")<ASUP("MOE"),ASUK("DT","DA")<ASUP("MOL") D
 I +$E(ASUK("DT","RUN"),4,5)>+$E(ASUP("LSMO"),1,2),ASUP("MOL")<ASUP("MOE"),ASUK("DT","DA")<ASUP("MOL") D
 .S X=ASUK("DT","MO")-1 S:X<10 X="0"_X
 .S ASUK("DT","RUNMO")=X
 .S:ASUK("DT","RUNMO")="00" ASUK("DT","RUNMO")=12
 .S ASUK("DT","RUNYR")=ASUK("DT","CFY")
 .S:ASUK("DT","RUNMO")="09" ASUK("DT","RUNYR")=ASUK("DT","PFY")
 E  D
 .S ASUK("DT","RUNMO")=ASUK("DT","MO")
 .S ASUK("DT","RUNYR")=ASUK("DT","CFY")
 S ASUK("DT","RUNMY")=ASUK("DT","RUNMO")_ASUK("DT","RUNYR")
 S ASUK("DT","RUNLS")=$P(^ASUSITE(1,0),U,14),ASUK("DT","RUNNM")=$E(ASUK("DT","RUNLS"),1,2)+1
 S:ASUK("DT","RUNNM")=13 ASUK("DT","RUNNM")=1
 I +ASUK("DT","RUNNM")=+ASUK("DT","RUNMO") D
 .W " (MMYY)=",ASUK("DT","RUNMY")
 E  D
 .I ASUP("TYP")=2,ASUK("DT","RUNMO")[9 D
 ..W !,"Processing Yearly Closeout"
 .E  D
 ..W !,"The computer date indicates that this run should be part of month ",ASUK("DT","RUNMO"),","
 ..W !,"but the Run Control table ASUTBL SITE indicates the most recent Monthly",!,"run was for ",ASUK("DT","RUNLS"),", therefore "
 ..I $E(ASUK("DT","RUNLS"),1,2)=ASUK("DT","RUNMO") D
 ...W "a monthly run has already sucessfully completed",!,"for month ",ASUK("DT","RUNMO"),"."
 ..E  D
 ...I $E(ASUK("DT","RUNLS"),1,2)<ASUK("DT","RUNMO") D
 ....W "a month or more has passed without sucessful",!,"completion of monthly run(s)."
 ...E  D
 ....W "the most recent monthly run was for a month after the",!,"current computer date."
 ..W !!,"The computer program is unable to determine correct run Month",*7,*7,!!,"***** Notify your Supervisor to take corrective action *****",*7,*7,!!,*7,*7
 ..K DIR S DIR(0)="E" D ^DIR
 ..S DUOUT=1
 Q
SETQTR ;EP ;INPUT- DT AND ASUP("MO") OUTPUT- ASUP("QTR") IN YRQT FORMAT
 I ($D(ASUK("DT"))#10)'=1 D DATE
 I '$D(ASUP("MO")) S DIR("A")="Enter Month & Fiscal Year for Quarterly Reports (MMFY)" D ASK^ASUCORUN
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUV("YR")=$S($L(ASUP("YR"))=4:ASUP("YR"),ASUP("YR")<60:20_ASUP("YR"),1:19_ASUP("YR"))
 S ASUP("QTR")=ASUV("YR")_$S(ASUP("MO")<4:"02",ASUP("MO")<7:"03",ASUP("MO")>9:"01",1:"04")
 K ASUV("YR")
 Q
