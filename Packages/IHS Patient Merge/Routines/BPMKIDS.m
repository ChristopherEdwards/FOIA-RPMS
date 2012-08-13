BPMKIDS ;IHS/OIT/LJF - PRE INSTALL & ENVIRON CHECK
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;Contains several subroutines written by Anne Fugatt, Phx Area Office
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ;CHECKS FOR PACKAGES AND PATCHES HERE
 NEW PATCH S PATCH="APSP*7.0*1004"
 I ($O(^PSRX(0))),('$$PATCH^XPDUTL(PATCH)) D
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;
 S PATCH="LR*5.2*1024"
 I ($O(^LAB(60,0))),('$$PATCH^XPDUTL(PATCH)) D
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;
 ;IHS/OIT/ENM 02/03/2010 THE FOLLOWING CODE WAS DISABLED AND FIXED BELOW
 ;S PATCH="BQI*1.0*3"
 ;I $O(^BQICARE(0)),('$$PATCH^XPDUTL(PATCH)) D
 ;. W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;IHS/OIT/ENM 02/03/2010
 I $O(^BQICARE(0)),+$$VERSION^XPDUTL("BQI")<1.1 D
 . W !,"You must first install iCare Version 1.1 or Greater." S XPDQUIT=2
 Q
 ;
PRE ;EP;
 ; clean out old AXDR entry in Package file
 NEW DA,DIK
 S DA=$O(^DIC(9.4,"C","AXDR",0)) Q:'DA
 S DIK="^DIC(9.4,"
 D ^DIK
 Q
 ;
POST ;EP; post init subroutine
 D SITE,PKG,DIKZ55,CHS,DUPTEST,XPAR,OLDMRG,ZEROS,POS323
 Q
 ;
SITE ;----- EDIT SITE PARAMETERS ;IHS/PHXAO/AEF
 ;SETS 'DAYS BEFORE FINAL VERIFY' AND 'DAYS BETWEEN VERIFY AND MERGE'
 ;TO ZERO IN THE DUPLICATE RESOLUTION FILE #15.1
 ;
 D BMES^XPDUTL("EDITING DUPLICATE RESOLUTION SITE PARAMETERS")
 ;
 N DA,DIE,DR,FILE,X,Y
 ;
 S FILE=0
 F  S FILE=$O(^VA(15.1,FILE)) Q:'FILE  D
 . S DIE="^VA(15.1,"
 . S DA=FILE
 . S DR=".13////0;.14////0;1.03///180"
 . D ^DIE
 ;
 Q
 ;
PKG ;----- CLEAN UP PACKAGE FILE ;IHS/PHXAO/AEF
 ;
 D BMES^XPDUTL("CLEANING UP PACKAGE FILE...")
 ;
 ;----- CLEAN UP ENTRIES WITH MISSING ZERO NODES
 D BMES^XPDUTL("CLEANING UP ENTRIES WITH MISSING ZERO NODES...")
 N DA,DIK,IEN,X,Y
 S IEN=0
 F  S IEN=$O(^DIC(9.4,IEN)) Q:'IEN  D
 . Q:$D(^DIC(9.4,IEN,0))
 . S DIK="^DIC(9.4,"
 . S DA=IEN
 . D ^DIK
 . D BMES^XPDUTL(IEN)
 ;
 ;----- CLEAN UP AFFECTS REC0RD MERGE MULTIPLE
 N IEN
 D BMES^XPDUTL("CLEANING UP 'AFFECTS RECORD MERGE' MULTIPLE...")
 S IEN=0
 F  S IEN=$O(^DIC(9.4,IEN)) Q:'IEN  D
 . K ^DIC(9.4,IEN,20)
 ;
 ; Now clean up AMRG xref ;IHS/OIT/LJF
 K ^DIC(9.4,"AMRG")
 NEW DIK,DA S DIK="^DIC(9.4,DA(1),20,",DIK(1)=".01^AMRG"
 S DA(1)=0
 F  S DA(1)=$O(^DIC(9.4,DA(1))) Q:'DA(1)  D ENALL^DIK
 ;
 Q
 ;
DIKZ55 ;----- FIXING PHARMACY PATIENT FILE #55 TO WORK WITH MERGE
 ; released with APSP patch 1005 but not called during install
 ; it also recompiles all xrefs for the file
 D BMES^XPDUTL("Removing duplicate xref 9999999902 in Pharmacy Patient File.")
 D DELIX^DDMOD(55.03,.01,999999902,"W")
 ;
 Q
 ;
CHS ;----- REINDEX "AC" XREF ON PATIENT FIELD OF THE TRANSACTION RECORD;IHS/PAO/AEF
 ;      SUBFIELD OF THE DOCUMENT SUBFIELD OF THE CHS FACILITY FILE
 ;
 N BPMDA1,BPMDA2,DA,DIK,X,Y
 ;
 D BMES^XPDUTL("Re-indexing the ""AC"" xref in the CHS Facility file...")
 ;
 S BPMDA2=0
 F  S BPMDA2=$O(^ACHSF(BPMDA2)) Q:'BPMDA2  D
 . S BPMDA1=0
 . F  S BPMDA1=$O(^ACHSF(BPMDA2,"D",BPMDA1)) Q:'BPMDA1  D
 . . S DA(1)=BPMDA1
 . . S DA(2)=BPMDA2
 . . S DIK="^ACHSF("_DA(2)_",""D"","_DA(1)_",""T"","
 . . S DIK(1)="2^AC"
 . . D ENALL^DIK
 Q
 ;
DUPTEST ; stuff Duplicate Tests multiple in file 15.1
 ; may contain old uncertified merge calls so replacing whole subfile
 D BMES^XPDUTL("Updating Duplicate Tests Logic")
 ;
 NEW DA,DIK,DIC,DLAYGO,DIE,DR,X,Y,BPMN
 ; first delete everything in multiple
 S DIK="^VA(15.1,2,11,",DA(1)=2
 S BPMN=0 F  S BPMN=$O(^VA(15.1,2,11,BPMN)) Q:'BPMN  S DA=BPMN D ^DIK
 ;
 ; now add in the current logic
 S DIC="^VA(15.1,2,11,",DA(1)=2,DIC(0)="L",DLAYGO=15.111
 F BPMN=1:1:9 D
 . S X=$P($T(TESTS+BPMN),";;",2) K DD,DO D FILE^DICN Q:'Y
 . S DIE=DIC,DA=+Y
 . S DR=".02///"_$P($T(TESTS+BPMN),";;",3)_";.03///"_$P($T(TESTS+BPMN),";;",4)_";.04///"_$P($T(TESTS+BPMN),";;",5)
 . S DR=DR_";.05///"_$P($T(TESTS+BPMN),";;",6)_";.06///"_$P($T(TESTS+BPMN),";;",7)_";.07///"_$P($T(TESTS+BPMN),";;",8)
 . D ^DIE
 Q
 ;
XPAR ; add an instance of BPM USE IHS LOGIC parameter
 D BMES^XPDUTL("Adding IHS parameter BPM USE IHS LOGIC")
 D ADD^XPAR("PKG","BPM USE IHS LOGIC",1,1)
 D CHG^XPAR("PKG","BPM USE IHS LOGIC",1,1)
 Q
 ;
OLDMRG ; clean up databases if old merge software used
 ; need to add -9 nodes and remove "B" cross-references
 D BMES^XPDUTL("Cleaning up old patient merge entries")
 NEW NAME,DFN
 S NAME="*"
 F  S NAME=$O(^DPT("B",NAME)) Q:NAME'["*"  D
 . S DFN=0 F  S DFN=$O(^DPT("B",NAME,DFN)) Q:'DFN  D
 . . Q:$P($G(^DPT(DFN,0)),U,19)<1    ;not an old merge
 . . ;Q:$G(^DPT(DFN,-9))              ;already has -9 node
 . . S ^DPT(DFN,-9)=$P(^DPT(DFN,0),U,19)
 . . S ^AUPNPAT(DFN,-9)=^DPT(DFN,-9)
 . . K ^DPT("B",NAME,DFN)
 . . K ^AUPNPAT("B",DFN,DFN)
 Q
 ;
ZEROS ; clean up globals with extra zero nodes
 D BMES^XPDUTL("Cleaning up extra zero nodes in RPMS globals")
 NEW FILE,GLB,FAC,X,NODE
 S FILE=1
 F  S FILE=$O(^DIC(FILE)) Q:'FILE  D
 . S GLB=$G(^DIC(FILE,0,"GL")) Q:GLB=""  Q:GLB["^DIC"
 . S GLB=GLB_"0)"
 . ;
 . ; look for non-standard globals
 . I GLB["DUZ(2)" D  Q
 . . S GLB=$P(GLB,"(",1)
 . . S FAC=0 F  S FAC=$O(@GLB@(FAC)) Q:'FAC  Q:'$D(^AUTTLOC(FAC,0))  D
 . . . S GLB=GLB_"("_FAC_",0)"
 . . . S X="" F  S X=$O(@GLB@(X)) Q:X=""  D
 . . . . D BMES^XPDUTL("Deleting "_$P(GLB,")",1)_","_X_")")
 . . . . S NODE=$P(GLB,")",1)_","_$S(X=+X:X,1:""""_X_"""")_")" K @NODE
 . . . S GLB=$P(GLB,"(",1)
 . ;
 . ; process normal globals
 . S X="" F  S X=$O(@GLB@(X)) Q:X=""  D
 . . D BMES^XPDUTL("Deleting "_$P(GLB,")",1)_","_X_")")
 . . S NODE=$P(GLB,")",1)_","_$S(X:X,1:""""_X_"""")_")" K @NODE
 Q
 ;
POS323 ; clean out data in field .323 in file 2
 ;IHS does not use PERIOD OF SERVICE field but there is old data there
 D BMES^XPDUTL("Cleaning out old Period of Service data")
 NEW DFN
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:'DFN  D
 . Q:$P($G(^DPT(DFN,.32)),U,3)=""    ;skip if no data
 . S $P(^DPT(DFN,.32),U,3)="" W "."
 Q
 ;
TESTS ;;
 ;;NAME;;1;;XDRPTN;;2;;.01;;100;;-60
 ;;SSN;;5;;XDRPTSSN;;2;;.09;;100;;-60
 ;;SEX;;10;;XDRPTSX;;2;;.02;;20;;-90
 ;;DATE OF DEATH;;20;;XDRPTDOD;;2;;.351;;50;;-50
 ;;MOTHER'S MAIDEN NAME;;25;;XDRPTMMN;;2;;.2403;;50;;-90
 ;;LAST SEPARATION DATE;;31;;XDRPTLSD;;2;;.327;;50;;-40
 ;;CLAIM NUMBER;;32;;XDRPTCLN;;2;;.313;;80;;-60
 ;;DATE OF BIRTH;;17;;XDRPTDOB;;2;;.03;;60;;-40
 ;;TRIBE OF MEMBERSHIP;;7;;BPMPTTR;;9000001;;1108;;5;;-5
