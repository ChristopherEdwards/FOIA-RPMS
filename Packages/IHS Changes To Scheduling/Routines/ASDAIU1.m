ASDAIU1 ; IHS/ADC/PDW/ENM - AIU BY CLINIC ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
CHOICE ; -- ask if printing for one patient or by clinic
 K DIR S DIR(0)="SAO^P:PATIENT;C:CLINIC",DIR("B")="C"
 S DIR("A")="PRINT by (P)ATIENT or by (C)LINIC: "
 S DIR("?",1)="Answer P - To an address update for one patient"
 S DIR("?",2)="Answer C - To print address updates by clinic"
 S DIR("?")=" "
 D ^DIR K DIR G END:$D(DIRUT) I Y="P" G ^ASDAIU
 ;
 W ! S DIV="" D DIV^SDUTL I $T D ROUT^SDDIV G:Y<0 END
 S (SDIQ,SDX,SDREP,SDSTART)="",SDX="ALL"
 ;
SORT ; -- ask user for sort option
 S ORDER=0
 K DIR S DIR(0)="SAO^C:CLINIC;P:PRINCIPLE CLINIC",DIR("B")="P"
 S DIR("A")="PRINT IN (C)LINIC or (P)RINCIPLE CLINIC ORDER: "
 S DIR("?",1)="Answer C - To see Address Updates printed by clinic"
 S DIR("?",2)="Answer P - To sort them by principle clinic"
 S DIR("?")=" "
 D ^DIR K DIR G END:$D(DIRUT) S ORDER=$S(Y="C":2,1:3)
 ;
 S VAUTD=$S(DIV="":1,1:DIV)
 I ORDER=2 S VAUTNI=1 D CLINIC^VAUTOMA G:Y<0 END
 D:'$D(DT) DT^SDUTL
 S %DT="AEXF",%DT("A")="PRINT ADDRESS/INSURANCE UPDATES FOR WHAT DATE: "
 D ^%DT K %DT("A") G:Y<1 END S SDATE=Y
 ;
A5 ;
 S (SDZHS,SDZMP,SDZEF)=1
 S VAR="VAUTD#^VAUTC#^DIV^SDX^ORDER^SDATE^SDIQ^SDREP^SDSTART^SDZHS^SDZMP^SDZEF"
 S DGPGM="START^ASDHS"
 S ADGDEV=$$VAL^XBDIQ1(40.8,$$DIV^ASDUT,9999999.06)
 I ADGDEV="" K ADGDEV
 D ZIS^DGUTQ G:POP END^SDROUT1
 G START^ASDHS:'$D(IO("Q"))
 ;
END ; -- eoj
 K ALL,DIV,ORD,ORDER,RMSEL,SDIQ,SDREP,SDSP,SDSTART
 K SDX,X,Y,C,V,I,SDEF,%I Q
