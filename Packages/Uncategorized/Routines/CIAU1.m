CIAU1 ;MSC/IND/PLS - General Purpose Utilites - Con't ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Parameterized call to ScreenMan interface
DDS(DDSFILE,DR,DA,DDSPARM,DDSCHANG,CIAERR) ;
 S CIAERR=0
 D:'$D(IOST(0)) HOME^%ZIS
 D ENS^%ZISS
 D ^DDS
 S:$D(DTOUT) CIAERR=1
 I $D(DIMSG)!($D(DIERR)) D
 .S CIAERR=1
 .;D SHOWDLG(23)
 .W !,?5,"The Screen Manager could not edit this record."
 .H 5
 Q
 ; Prompt for single date date
 ; PMT = Prompt
 ; DFL = Default value (optional)
 ; MIN = Minimum value (optional)
 ; OPT = Additional options (optional)
ASKDATE(PMT,DFL,MIN,OPT) ;
 N %DT,Y
 S %DT="APEX"_$G(OPT)
 S %DT("A")=PMT
 S:$G(MIN) %DT(0)=MIN
 I $G(DFL) D
 .S Y=DFL
 .D DD^%DT
 .S %DT("B")=Y
 D ^%DT
 S:Y<0 POP=1
 Q Y
