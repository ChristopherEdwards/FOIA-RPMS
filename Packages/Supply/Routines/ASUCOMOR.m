ASUCOMOR ; IHS/ITSC/LMH -MONTH REPORT DRIVER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls the sequence for processing during a monthly
 ;closeout update run.
 D TIME^ASUUDATE
 S:$G(ASUP("TYP"))']"" ASUP("TYP")=2
 S ASUP("CKM")=+$G(ASUP("CKM"))
 Q:ASUP("CKM")>20
 S ASURX="W !,""S.A.M.S. Monthly Reports Procedure begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 G:ASUP("CKM")>1 SORT
XTR ;
 I ASUP("CKM")=0 D
 .I ASUP("UPLD")=1!(ASUP("UPLD")=3) D
 ..D TIME^ASUUDATE
 ..S ASURX="W !,""Month end Upload for SAMS Processing "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 ..I ASUP("CKM")=0
 ..D MO^ASUW2SAM(ASUP("MO")) Q:ASUP("HLT")  S ASUP("CKM")=1 D SETSM^ASUCOSTS
 ..D TIME^ASUUDATE
 ..S ASURX="W !,""Month end Upload for SAMS Completed "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 .I ASUP("UPLD")=2!(ASUP("UPLD")=3) D
 ..D TIME^ASUUDATE
 ..S ASURX="W !,""Month end Extract for STORES Processing "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 ..I ASUP("CKM")=0
 ..D MO^ASUW2STO(ASUP("MO")) Q:ASUP("HLT")  S ASUP("CKM")=1 D SETSM^ASUCOSTS
 ..D TIME^ASUUDATE
 ..S ASURX="W !,""Month end Extract for STORES Completed "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
SORT ;
 I ASUP("CKM")=1 S ASUP("CKM")=2 D SETSM^ASUCOSTS
 I ASUP("CKM")=2 D  Q:ASUP("HLT")
 .S ASURX="W !?3,""Monthly Extracts being built for reports: 10V""" D ^ASUUPLOG
 .;D ^ASUMCPSM,TRANS^ASUMCPSM Q:ASUP("HLT")
 .S ASUP("CKM")=3 D SETSM^ASUCOSTS
 I ASUP("CKM")=3 D  Q:ASUP("HLT")
 .S ASURX="W "" 12""" D ^ASUUPLOG
 .D SORT^ASURM12P Q:ASUP("HLT")  S ASUP("CKM")=4 D SETSM^ASUCOSTS
 I ASUP("CKM")=4 D  Q:ASUP("HLT")
 .S ASURX="W "" 14""" D ^ASUUPLOG
 .;D SORT^ASURM14P Q:ASUP("HLT")
 .S ASUP("CKM")=5 D SETSM^ASUCOSTS
 I ASUP("CKM")=5 D  Q:ASUP("HLT")
 .S ASURX="W "" 15""" D ^ASUUPLOG
 .;beginning Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block
 .D GET^ASURM15P Q:ASUP("HLT")
 .S ASUP("CKM")=6 D SETSM^ASUCOSTS
 I ASUP("CKM")=6 D  Q:ASUP("HLT")
 .S ASURX="W "" 16""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block
 .D GET^ASURM16P Q:ASUP("HLT")
 .S ASUP("CKM")=7 D SETSM^ASUCOSTS
 I ASUP("CKM")=7 D  Q:ASUP("HLT")
 .S ASURX="W "" 17""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block 
 .D GET^ASURM17P Q:ASUP("HLT")
 .S ASUP("CKM")=8 D SETSM^ASUCOSTS
 I ASUP("CKM")=8 D  Q:ASUP("HLT")
 .S ASURX="W "" 23""" D ^ASUUPLOG
 .D SORT^ASURM23P Q:ASUP("HLT")  S ASUP("CKM")=9 D SETSM^ASUCOSTS
 I ASUP("CKM")=9 D  Q:ASUP("HLT")
 .S ASURX="W "" 24""" D ^ASUUPLOG
 .D SORT^ASURM24P Q:ASUP("HLT")  S ASUP("CKM")=10 D SETSM^ASUCOSTS
 I ASUP("CKM")=10 D  Q:ASUP("HLT")
 .S ASURX="W "" 74""" D ^ASUUPLOG
 .D CMPT^ASURM74P Q:ASUP("HLT")  S ASUP("CKM")=11 D SETSM^ASUCOSTS
 I ASUP("CKM")=11 D  Q:ASUP("HLT")
 .S ASURX="W "" 76""" D ^ASUUPLOG
 .D ^ASURO760 Q:ASUP("HLT")  S ASUP("CKM")=12 D SETSM^ASUCOSTS
 I ASUP("CKM")=12 D  Q:ASUP("HLT")
 .S ASURX="W "" 79""" D ^ASUUPLOG
 .D CMPT^ASURM79P Q:ASUP("HLT")  S ASUP("CKM")=13 D SETSM^ASUCOSTS
 ;WAR 4/15/99 TEMP FIX FOR NOW... NEED TO REMOVE LATER
 S ASUP("CKM")=18 D SETSM^ASUCOSTS
 G SKIP  ; AGAIN, REMOVE THIS LATER
 I ASUP("CKM")=13 D  Q:ASUP("HLT")
 .S ASURX="W "" DBA""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block
 .D GET^ASURMDBA Q:ASUP("HLT")  S ASUP("CKM")=14 D SETSM^ASUCOSTS
 I ASUP("CKM")=14 D  Q:ASUP("HLT")
 .S ASURX="W "" DBC""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block 
 .D GET^ASURMDBC Q:ASUP("HLT")  S ASUP("CKM")=15 D SETSM^ASUCOSTS
 I ASUP("CKM")=15 D  Q:ASUP("HLT")
 .S ASURX="W "" DBH""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block
 .D GET^ASURMDBH Q:ASUP("HLT")  S ASUP("CKM")=16 D SETSM^ASUCOSTS
 I ASUP("CKM")=16 D  Q:ASUP("HLT")
 .S ASURX="W "" DBK""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block
 .N X F X=1:1:5,9,999 D
 ..S ASURPT="K"_X
 ..D GET^ASURMDBK Q:ASUP("HLT")
 .S ASUP("CKM")=17 D SETSM^ASUCOSTS
 I ASUP("CKM")=17 D  Q:ASUP("HLT")
 .S ASURX="W "" DBL""" D ^ASUUPLOG
 .;begin Y2K
 .;S ASUDT=$E(ASUK("DT","FM"),1,5)_"00",ASUTYP="M"
 .D Y2K         ;Y2000
 .;end Y2K fix block 
 .D GET^ASURMDBL Q:ASUP("HLT")  S ASUP("CKM")=18 D SETSM^ASUCOSTS
SKIP ;
 I ASUP("CKM")=18 D  Q:ASUP("HLT")
 .S ASURX="W !?3,""Station Master PAMIQ and RPQ recalculating""" D ^ASUUPLOG
 .D PAMIQ Q:ASUP("HLT")  S ASUP("CKM")=19 D SETSM^ASUCOSTS
 I ASUP("CKM")=19 D  Q:ASUP("HLT")
 .S ASURX="W !?3,""Clearing and Updating YTD ISSUE DATA fields""" D ^ASUUPLOG
 .D MO^ASUMYDPS Q:ASUP("HLT")  S ASUP("CKM")=20 D SETSM^ASUCOSTS
 I ASUP("CKM")=20 D  Q:ASUP("HLT")
 .S ASURX="W !?3,""Clearing and Updating ISSUE BOOK fields""" D ^ASUUPLOG
 .D CLMO^ASUMKBPS Q:ASUP("HLT")  S ASUP("CKM")=21 D SETSM^ASUCOSTS
 .I ASUP("OLIB") D CRMSTR^ASUJOLIB
 D TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S. Monthly Closeout Procedure ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 Q
PAMIQ ;END OF MONTH RECALCULATE PAMIQ
 ;This sub routine is used to calculate a new Projected
 ;Average Issue Quantity (PAMIQ) for each Index number. The PAMIQ is
 ;used in calculating the Economic Order Quantity (EOQ) whenever stock
 ;for the Index item gets low enough appear on the Requirements
 ;Analysis Report (Report 13) entry.
 S (ASUMS("RPQ"),ASUMS("E#","IDX"),ASUMS("PMIQ"))=""
 S ASUMS("E#","STA")=0
 F  S ASUMS("E#","STA")=$O(^ASUMS(ASUMS("E#","STA"))) Q:ASUMS("E#","STA")'?1N.N  S ASUMS("E#","IDX")=0 D
 .F  S ASUMS("E#","IDX")=$O(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"))) Q:ASUMS("E#","IDX")'?1N.N  D
 ..D ^ASUMSTRD
 ..Q:ASUF("DLIDX")
 ..S ASUMS("RPQ-O")=ASUMS("RPQ") ;Save Old Review Point Quantity
 ..S X=ASUMS("ESTB") S:+($E(X,6,7))=0 X=X+30 ;If day = 0 set to 30
 ..D H^%DTC S X(2)=%H
 ..S X=ASUK("DT","FM") D H^%DTC S X(3)=%H
 ..S X(2)=X(3)-X(2) K X(3) ;Get diff of today - date estb
 ..I X(2)<366 D  ;Less than a year since established
 ...S ASUMS("PMIQ-F")=ASUMS("PMIQ")*.60 ;Old PAMIQ weight 60%
 ...S ASUV("CISSWT")=ASUMS("DMD","QTY",+ASUP("MO"))*.40 ;Current Month issues weight 40%
 ..I X(2)>365 D  ;More than a year since established
 ...S ASUMS("PMIQ-F")=ASUMS("PMIQ")*.90 ;Old PAMIQ weight 90%
 ...S ASUV("CISSWT")=ASUMS("DMD","QTY",+ASUP("MO"))*.10 ;Current Month issues weight 10%
 ..K X
 ..S ASUMS("PMIQ")=$FN(ASUMS("PMIQ-F")+ASUV("CISSWT"),"-",0) ;Calculate new PAMIQ and round to even number
 ..S ASUV("MO")=ASUP("MO")+1 S:ASUV("MO")=13 ASUV("MO")=1
 ..S ASUMS("DMD","QTY",ASUV("MO"))="" ;Reset Demand Quantity for this month next year
 ..S ASUMS("DMD","CALL",ASUV("MO"))="" ;Reset Demand Calls for this month next year
 ..I ASUMS("EOQ","TP")'="P" D
 ...S ASUMS("RPQ")=$FN(((ASUMS("LTM")+ASUMS("SFSKM"))*ASUMS("PMIQ")),"-",0) ;Calculate new RPQ and round off to even quantity
 ..D ^ASUMSTWR ;Update Station master
 Q
Y2K ;begin Y2K
 S X=$E(ASUK("DT","FM"),2,5)  ;Y2000    CYYMM
 D START^ASUUY2K(.X,1,U,"Y")       ;Y2000
 S ASUDT=Y                    ;Y2000
 S ASUTYP="M"                 ;Y2000
 ;end Y2K fix block
 Q
