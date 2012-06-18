DBTSNWCK ;dmh/bao  Diabetes Tracker System [ 03/15/1999  12:44 AM ]
 ;checks to see if the patient is diagnosed with diabetes
 ; this routine is in the audit condition of V POV 
 S DBTSICD=$P($G(^AUPNVPOV(DA,0)),"^",1)
 I DBTSICD="" I DBTSICD="ZZ" Q
 S DBTSCODE=$P($G(^ICD9(DBTSICD,0)),"^",1)
 I DBTSCODE["250."
 K DBTSICD,DBTSCODE
 Q
