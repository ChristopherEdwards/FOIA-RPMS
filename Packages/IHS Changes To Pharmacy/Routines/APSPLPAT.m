APSPLPAT ;IHS/MSC/PLS - APSP Last Pharmacy Patch Lister ;10-Nov-2011 15:07;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1009,1010,1013**;DEC 11, 2003;Build 33
 ;
EN ;EP
 N ROW,PKG,VER,LP,INFO,EHRREC,AWPDT
 W @IOF,!
 W !,$$CJ^XLFSTR("Pharmacy Related Packages",IOM)
 W !,$$CJ^XLFSTR("Last Patch Lister",IOM),!
 W !,"Package",?34,"Version",?45,"Last Patch",?60,"Date Installed"
 W ! F LP=1:1:IOM W "-"
 W !
 F ROW=0:1 S X=$P($T(PKG+ROW),";;",2) Q:'$L(X)  D
 .S PKG=$P(X,";"),VER=$P(X,";",2),VER=$$VERSION^XPDUTL(PKG)
 .S INFO=$$LAST(PKG,VER)
 .W !,$P(X,";"),?34,VER,?45,$S($P(INFO,U)=-1:"None",1:$P(INFO,U)),?60,$S($P(INFO,U)=-1:$$FMTE^XLFDT($P(INFO,U,3),"5Z"),1:$$FMTE^XLFDT($P(INFO,U,2),"5Z"))
 W !!
 ; Output last EHR install file
 S EHRREC=$$FND()
 I $L(EHRREC) D
 .W !,"The last EHR installation was ",$P(EHRREC,U,2)," on ",$$FMTE^XLFDT($P(EHRREC,U,3),"5Z"),"."
 E  W !,"EHR has not been installed at this site."
 W !
 ; Output last AWP update
 S AWPDT=$G(^APSPCTRL("AWP DATE"))
 I AWPDT D
 .W !,"Last Benchmark Price monthly update occurred on ",$$FMTE^XLFDT(AWPDT,"5Z")
 E  W !,"Benchmark Price has not been installed at this site."
 W !!
 D DIRZ^APSPUTIL()
 Q
 ; Find last EHR installation
FND() ;EP
 N LP,IEN,LSTDT,DAT,DATA,ERR
 D FIND^DIC(9.7,"","@;.01;17I","P","EHR",,,"","","DATA","ERR")
 S LP=0,IEN=0,LSTDT=0 F  S LP=$O(DATA("DILIST",LP)) Q:'LP  D
 .S DAT=DATA("DILIST",LP,0)
 .I $P(DAT,U,3)>LSTDT D
 ..S IEN=LP
 ..S LSTDT=$P(DAT,U,3)
 Q $S(IEN:DATA("DILIST",IEN,0),1:"")
 ;
LAST(PKG,VER) ;returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN,PKGIDT
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 S PKGIDT=$P(^DIC(9.4,PKGIEN,22,VERIEN,0),U,3)
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 .;I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST
 .Q:$P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)<LATEST
 .S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 Q PATCH_U_LATEST_U_PKGIDT
 ;
PKG ;;NATIONAL DRUG FILE;4.0
 ;;IHS PHARMACY MODIFICATIONS;7.0
 ;;ADVERSE REACTION TRACKING;4.0
 ;;PHARMACY POINT OF SALE;1.0
 ;;AUTOMATED DISPENSING INTERFACE;1.0
 ;;IHS SCRIPTPRO INTERFACE;1.0
 ;;BEX AUDIOCARE TELEPHONE REFILL;1.0
 ;;CONTROLLED DRUG EXPORT SYSTEM;1.0
 ;;
 ;;IHS PHARMACY AWP;6.1
 ;;CMOP;2.0
 ;;BAR CODE MED ADMIN;3.0
 ;;CONTROLLED SUBSTANCES;3.0
 ;;DRUG ACCOUNTABILITY;3.0
 ;;PHARMACY BENEFITS MANAGEMENT;4.0
 ;;OUTPATIENT PHARMACY;7.0
 ;;INPATIENT MEDICATIONS;7.0
 ;;PHARMACY DATA MANAGEMENT;1.0
