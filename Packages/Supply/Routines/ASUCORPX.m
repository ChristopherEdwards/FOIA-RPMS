ASUCORPX ; IHS/ITSC/LMH -PROCESS REPORT EXTRACTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine controls 'Compute' or 'Sort' step in preparing extracts
 ;for all reports created for any daily (including monthly and yearly)
 ;update.
 D DATE^ASUUDATE,TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S Report Extracts build Begun "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 D:$G(ASUN("TYP"))']"" ^ASUURANG
 S ASUP("CKX")=+($G(ASUP("CKX")))
 I ASUP("CKX")=0 S ASUP("CKX")=1 D SETSX^ASUCOSTS
 I ASUP("CKX")=1 D
 .S ASUP("CKX")=6 D SETSX^ASUCOSTS
 I ASUP("CKX")=6 D
 .S ASURX="W !?5,""Report 10V extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD10V S ASUP("CKX")=7 D SETSX^ASUCOSTS
 I ASUP("CKX")=7 D
 .S ASURX="W !?5,""Report 7A extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD07A S ASUP("CKX")=8 D SETSX^ASUCOSTS
 I ASUP("CKX")=8 D
 .S ASURX="W !?5,""Report 08 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD08P S ASUP("CKX")=9 D SETSX^ASUCOSTS
 I ASUP("CKX")=9 D
 .S ASURX="W !?5,""Report 09 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD09P S ASUP("CKX")=10 D SETSX^ASUCOSTS
 I ASUP("CKX")=10 D
 .S ASURX="W !?5,""Report 10 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD10P S ASUP("CKX")=11 D SETSX^ASUCOSTS
 I ASUP("CKX")=11 D
 .S ASURX="W !?5,""Report 11 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD11P S ASUP("CKX")=13
 I $G(ASUD("R13","SEL")) D
 .S ASURX="W !?5,""Report 13 extracts building""" D ^ASUUPLOG
 .I ASUP("CKX")=13 D CMPT^ASURD13P S ASUP("CKX")=14 D SETSX^ASUCOSTS
 E  D
 .I ASUP("CKX")=13 S ASUP("CKX")=70 D SETSX^ASUCOSTS
 I ASUP("CKX")=70 D
 .S ASURX="W !?5,""Report 70 extracts building""" D ^ASUUPLOG
 .D ^ASURD700 S ASUP("CKX")=71 D SETSX^ASUCOSTS
 I ASUP("CKX")=71 D
 .S ASURX="W !?5,""Report 71 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD71P S ASUP("CKX")=72 D SETSX^ASUCOSTS
 I ASUP("CKX")=72 D
 .D CMPT^ASURD72P S ASUP("CKX")=73 D SETSX^ASUCOSTS
 .S ASURX="W !?5,""Report 72 extracts building""" D ^ASUUPLOG
 I ASUP("CKX")=73 D
 .S ASURX="W !?5,""Report 73 extracts building""" D ^ASUUPLOG
 .D CMPT^ASURD73P S ASUP("CKX")=74 D SETSX^ASUCOSTS
 I $G(ASUP("TYP"))=1 D  ;Monthly reports
 .I ASUP("CKX")=74 D
 ..S ASURX="W !?5,""Report 74 extracts building""" D ^ASUUPLOG
 ..D CMPT^ASURM74P S ASUP("CKX")=76,ASUF("RPT75")=1 D SETSX^ASUCOSTS
 .I ASUP("CKX")=76 D
 ..S ASURX="W !?5,""Report 76 extracts building""" D ^ASUUPLOG
 ..D ^ASURO76D S ASUP("CKX")=79 D SETSX^ASUCOSTS
 .I ASUP("CKX")=79 D
 ..S ASURX="W !?5,""Report 79 extracts building""" D ^ASUUPLOG
 ..D CMPT^ASURM79P S ASUP("CKX")=83 D SETSX^ASUCOSTS
 .I ASUP("CKX")=83 D
 ..S ASURX="W !?5,""Report 83 extracts building""" D ^ASUUPLOG
 ..D CMPT^ASURM83P S ASUP("CKX")=90 D SETSX^ASUCOSTS
 .I ASUP("CKX")=90 D
 ..S ASUP("CKX")=0 D SETSX^ASUCOSTS
 E  D
 .I ASUP("CKX")=74 D
 ..S ASUP("CKX")=0 D SETSX^ASUCOSTS
 I ASUP("CKX")'=0 S ASUP("HLT")=1
 D DATE^ASUUDATE,TIME^ASUUDATE
 S ASURX="W !,""S.A.M.S Report Extracts Build Ended "_ASUK("DT","TIME")_"""" D ^ASUUPLOG
 Q
