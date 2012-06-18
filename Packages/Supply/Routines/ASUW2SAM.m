ASUW2SAM ; IHS/ITSC/LMH - UPLOAD TO HEADQUARTERS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
MO(X) ;EP ;UPLOAD FOR MONTH IN X
 S ASUP("MO")=X
 D:$G(ASUP("MOE"))']"" SETCTRL^ASUCOSTS
 D:$G(ASUP("MOYR"))']"" SETMO^ASUUDATE(X)
 D TIME^ASUUDATE
 S ASUW("DT EXT")=ASUK("DT","FM")
 S ASURX="W !,""S.A.M.S. Upload data for SAMS Procedure Begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 S ASUW("TY RUN")=^ASUSITE(1,0)
 K ^XTMP("ASUW") S ASUHDA="",^XTMP("ASUW",0)=ASUK("DT","FM")_U_ASUK("DT","FM")+100000
 F  S ASUHDA=$O(^ASUH("C","U",ASUHDA)) Q:ASUHDA'?1N.N  D
 .M ^XTMP("ASUW","H",ASUHDA)=^ASUH(ASUHDA)
 .Q:ASUP("UPLD")=3
 .D UPDTHIST ;DFM P1 8/28/98
 D LOGNTRY(ASUP("MO"))
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Upload data for SAMS Procedure Ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 Q
UPDTHIST ;EP ;Update History record as extracted SUBROUTINE ADDED ;DFM P1 8/28/98
 S DA=ASUHDA,DIE="^ASUH(" ;DFM P1 8/28/98
 S DR=".09///"_ASUW("DT EXT")_";.1///X" D ^DIE ;DFM P1 8/28/98
 Q  ;DFM P1 8/28/98
LOGNTRY(X) ;EP ;Enter extract data in Log master
 S ASUP("MO")=X
 K DD,D0
 I '$D(ASUP("QTR")) D SETQTR^ASUUDATE
 S ASUW("LOG","DT")=$S($L(X)=1:"0"_X,1:X)_"/00/"_$E(ASUK("DT","FM"),2,3)
 S ASURX="W !,""Run Month="_X_" Run Quarter="_ASUP("QTR")_" Log Date="_ASUW("LOG","DT")_"""" D ^ASUUPLOG
 ;begin Y2K
 ;S ASUW("LOG","KY")=$S(ASUP("YR")<98:2,1:3)_ASUP("YR")_$E(ASUP("MOYR"),1,2)_"00"
 S X=ASUP("MOYR")        ;Y2000
 D START^ASUUY2K(.X,1,U,"N")  ;Y2000
 S:$E(X,3,4)="00" $E(X,3,4)=$P("31^28^31^30^31^30^31^31^30^31^30^31",U,+$E(X,1,2)) ;*** TESTING - AEF *** TO PUT A DAY IN THE DATE SO THAT FILEMAN22 WILL ACCEPT IT
 S ASUW("LOG","KY")=X    ;Y2000
 ;end Y2K
 K DIC,DD,DO
 S DIC="^ASUML(",DIC(0)="LZM",X=ASUW("LOG","KY")
 S DIC("DR")=".01///"_ASUW("LOG","KY")_";.02///"_ASUL(1,"AR","AP")_";2///"_ASUP("QTR")
 D FILE^DICN
 I +Y<0 D
 .S ASURX="W !,""Add New Months entry to Extract Log file unsucessful - "",Y,!"
 .D ^ASUUPLOG Q
 E  D
 .S ASUW("DA")=+Y
 .I '$D(^ASUML(ASUW("DA"),1,0)) S ^ASUML(ASUW("DA"),1,0)="^9002039.981DA^0^"
 .S ASUW("DA",1)=$O(^ASUML(ASUW("DA"),"B",ASUK("DT","FM"),""))
 .I ASUW("DA",1)']"" D
 ..S ASUW("DA",1)=$P(^ASUML(ASUW("DA"),1,0),U,3)+1
 ..S $P(^ASUML(ASUW("DA"),1,0),U,3)=ASUW("DA",1)
 ..S $P(^ASUML(ASUW("DA"),1,0),U,4)=$P(^ASUML(ASUW("DA"),1,0),U,4)+1
 ..S ^ASUML(ASUW("DA"),"B",ASUK("DT","FM"),ASUW("DA",1))=""
 .F X=1:1:7 I '$D(ASUC(X)) S ASUC(X)=""
 .S ^ASUML(ASUW("DA"),1,ASUW("DA",1),0)=ASUK("DT","FM")_U_ASUC(1)_U_ASUC(2)_U_ASUC(3)_U_ASUC(4)_U_ASUC(5)_U_ASUC(6)_U_ASUC(7)
 .I Y<0 S ASURX="W !,""Add New Extract Date to Extract Log file unsucessful"",!" D ^ASUUPLOG Q
 .S ASURX="W !,""Entry to Extract Log file made"",!" D ^ASUUPLOG
 K ASUW("LOG","DT"),ASUW("DA"),X,Y
 Q
