ABMDRCO ; IHS/ASDST/DMJ - PRINT LIST OF CO & DEPEN VISITS ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;02/07/96 12:22 PM
 ;This report lists outpatient and inpatients visits to a
 ;facility by commissioned officers and their dependents
 ;
 W !!,$C(7),$C(7),"THIS REPORT MUST BE PRINTED ON 132 COLUMN PAPER OR ON A PRINTER THAT IS",!,"SET UP FOR CONDENSED PRINT!!!",!,"IF YOU DO NOT HAVE SUCH A PRINTER AVAILABLE - SEE YOUR SITE MANAGER.",!
BDATE K ABMD S %DT="AEPQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S ABMD("BDT")=Y
EDATE S %DT="AEPQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S ABMD("EDT")=Y
 ;
VST S DIR(0)="S^1:Outpatient Visits Only;2:Inpatient Visits Only;3:Dental Visits Only;4:All"
 S DIR("?")="Enter either 1, 2, 3, or 4 for the report desired."
 S DIR("A")="Select (1, 2, 3, or 4)"
 S DIR("B")=4
 D ^DIR K DIR
 I $D(DUOUT)!($D(DIRUT))!($D(DIROUT))!($D(DTOUT)) G END
 I Y=1!(Y=4) S ABMD("TOP")=""
 I Y=2!(Y=4) S ABMD("TIP")=""
 I Y=3!(Y=4) S ABMD("TDEN")=""
 ;
 S ABMD("$J")=DUZ_"-"_$P($H,",",1)_"-"_$P($H,",",2)
 D INIT^ABMDRCO1
 S ABMQ("RC")="MAIN^ABMDRCO1",ABMQ("RP")="^ABMDRCO2",ABMQ("NS")="ABMD",ABMQ("RX")="END^ABMDRCO2"
 D ^ABMDRDBQ
 Q
END ;CLEAN UP AND QUIT
 K ABMD,ABMDSTOP Q
