ORY124 ;SLC/DAN--Find potentially erroneous complex orders ;10/25/01  14:36
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**124**;Dec 17, 1997
 ;
 N DIC,X,Y,ORMSG,QUE,ORIOPTR,ORION,OREND,%ZIS
 I '$G(XPDENV)!($G(^XTMP("ORY124",0))) Q  ;Don't process if just loading distribution
 D CHECK Q:Y=-1
 S ORMSG(1)="A check will now be made to identify any complex pharmacy orders that have",ORMSG(2)="exactly 4 lines associated with them.  You should review each entry",ORMSG(3)="for accuracy."
 S ORMSG(4)="",ORMSG(5)="This report will be automatically queued to run in the background.",ORMSG(6)="Please select a printer.",ORMSG(7)=""
 D MES^XPDUTL(.ORMSG)
 S QUE=1
TASK ;
 S %ZIS="Q",%ZIS("B")="" S:$G(QUE) %ZIS("S")="I $G(^(""TYPE""))'=""VTRM""" D ^%ZIS I POP D EXIT Q
 I $G(QUE)!($D(IO("Q"))) S ZTRTN="DQ^ORY124",ZTDESC="Complex orders search",ZTSAVE("*")="" D ^%ZTLOAD D:'$D(ZTSK) EXIT Q
DQ ;Come here to start
 N ORID,ORIEN,DIC,X,Y
 K ^TMP($J,"FC")
 D CHECK Q:Y=-1
 U IO W:$E(IOST,1,2)="C-" !,"Searching..."
 S ORID=Y ;Install completion date
 S ORID=$$FMADD^XLFDT(ORID\1,-1,,,-1) ;Set start date to install date - 1 day and 1 second
 S ORIEN=$O(^OR(100,"AF",+$O(^OR(100,"AF",ORID)),0)) I ORIEN="" D PRINT Q  ;Get first order number associated with date of install
 F  S ORIEN=$O(^OR(100,ORIEN)) Q:'+ORIEN  D
 .Q:$$NMSP^ORCD($P($G(^OR(100,ORIEN,0)),"^",14))'="PS"  ;Quit if not a pharmacy order
 .Q:$$DOSE'=4  ;Quit if not 4 doses
 .S ^TMP($J,"FC",ORIEN)="" ;Save if pharmacy order with 4 doses
 D PRINT,^%ZISC
 S ^XTMP("ORY124",0)=$$FMADD^XLFDT(DT,60) ;Set automatic removal to 60 days.
 Q
 ;
DOSE() ;Returns number of doses associated with order
 N DOSE,I
 F I=0:0 S I=$O(^OR(100,ORIEN,4.5,"ID","DOSE",I)) Q:'+I  S DOSE=$G(DOSE)+1
 Q +$G(DOSE)
 ;
PRINT ;Print out info associated with order
 N PAGE,DATE,J
 S PAGE=1,DATE=$$FMTE^XLFDT(DT,"2D")
 D HDR
 I '$D(^TMP($J,"FC")) W "NO DATA TO REPORT." Q
 S J=0 F  S J=$O(^TMP($J,"FC",J)) Q:'+J  D
 .W !,J
 .W ?12,$$FMTE^XLFDT($P($G(^OR(100,J,8,1,0)),"^"),"2D")
 .W ?25,$$PNM(J)
 .W ?58,$P($$STATUS^ORQOR2(J),"^",2)
 .D:$Y>(IOSL-4) HDR
 Q
 ;
HDR ;
 N DASH
 K DASH
 W @IOF,!
 W "Complex Orders Search",?35,DATE,?70,"PAGE: ",PAGE,!
 W "ORDER #",?12,"ORDER DATE",?25,"PATIENT NAME",?58,"ORDER STATUS"
 S $P(DASH,"-",IOM)="" W !,DASH,!
 S PAGE=PAGE+1
 Q
 ;
PNM(ORIEN) ;Returns patient name
 N OBJ,FILE,NAME
 S OBJ=$P($G(^OR(100,ORIEN,0)),"^",2)
 I OBJ="" Q ""
 S FILE="^"_$P(OBJ,";",2)
 S NAME=$P($G(@(FILE_$P(OBJ,";")_",0)")),"^")
 Q NAME
 ;
EXIT ;
 D BMES^XPDUTL("Report not queued.  Please run TASK^ORY124 at a later time to see the report.") Q
 ;
CHECK ;Check for patch 94 existence
 N IEN
 S Y=-1,IEN=0 F  S IEN=$O(^XPD(9.7,"B","OR*3.0*94",IEN)) Q:'+IEN  I $P($G(^XPD(9.7,IEN,1)),"^",3)'="" S Y=$P(^(1),"^",3) Q  ;Get install date from earliest entry
 I Y=-1 D BMES^XPDUTL("Patch 94 not installed, complex orders report does not need to run.") Q
