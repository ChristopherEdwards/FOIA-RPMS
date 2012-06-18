PSNDATA ;BIR/DMA-post install routine to load data ;31 Aug 99 / 11:32 AM
 ;;4.0; NATIONAL DRUG FILE;**1,6,8,9,10,12,14,15,17,18,21,23,24,25,28,31,34**; 30 Oct 98
 ; Reference to ^PSDRUG supported by DBIA #2352
 ; Reference to ^PSDRUG supported by DBIA #3077
 N CT,DA,DIA,DIC,DIE,DIK,DR,FILE,FLDS,GROOT,GROOT1,IENS,J,JJ,K,NAME,NEW,POST,R1,ROOT,ROOT1,ROOT2,ROOT3,SUBS,X,XMDUZ,XMSUB,XMTEXT,XMY
 ;
 S PSNDF=1
 ;TO ALLOW ADDS TO 56
 ;MORE ELEGANT CHANGE LATER
 ;
 S X=$P($T(+2),"**",2),X=$P(X,",",$L(X,",")) I X I $$PATCH^XPDUTL("PSN*4.0*"_X) D BMES^XPDUTL("This patch has already been installed") S XPDQUIT=2 Q
 S FILE=0,GROOT=$NA(@XPDGREF@("DATANT"))
 ;load new entries first
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S DA=+DIA K FDA,IENS
 .I $$GET1^DIQ(FILE,DA,.01)]"" S FDA(FILE,DA_",",.01)=NEW D FILE^DIE("","FDA") Q
 .S DINUM=DA,X=NEW,DIC=ROOT,DIC(0)="L",DLAYGO=FILE,DIC("DR")="S Y=0" K DD,DO D FILE^DICN
 ;
 S FILE=0,GROOT=$NA(@XPDGREF@("DATAN"))
 ;load new multiple entries next
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S IENS=$P(DIA,"^")_",",FLDS=$P(DIA,"^",3),ROOT=FILE K FDA,IEN
 .I FLDS["," D
 ..;it should, but
 ..S LI=$P(DIA,"^",3) F J=1:1:$L(LI,",")-1 S ROOT=+$P(^DD(ROOT,+$P(LI,",",J),0),"^",2)
 ..S LI=$P(DIA,"^"),IENS="" F J=$L(LI,","):-1:1 S IENS=IENS_$P(LI,",",J)_","
 ..S DA=+IENS
 .;I $$GET1^DIQ(ROOT,IENS,.01)]"" S FDA(ROOT,IENS,.01)=NEW D FILE^DIE("","FDA") Q
 .S FDA(ROOT,"+"_IENS,.01)=NEW,IEN(DA)=DA D UPDATE^DIE("","FDA","IEN")
 ;
 S FILE=0,GROOT=$NA(@XPDGREF@("DATAO"))
 ;now load the rest of the data
 F  S FILE=$O(@GROOT@(FILE)) Q:'FILE  S ROOT=$$ROOT^DILFD(FILE) I ROOT]"" S GROOT1=$NA(@GROOT@(FILE)) F JJ=1:2 Q:'$D(@GROOT1@(JJ))  S DIA=@GROOT1@(JJ),NEW=@GROOT1@(JJ+1) D
 .S IENS=$P(DIA,"^")_",",FLDS=$P(DIA,"^",3),ROOT=FILE K FDA,IEN
 .I FLDS["," D
 ..S LI=$P(DIA,"^",3) F J=1:1:$L(LI,",")-1 S ROOT=+$P(^DD(ROOT,+$P(LI,",",J),0),"^",2)
 ..S LI=$P(DIA,"^"),IENS="" F J=$L(LI,","):-1:1 S IENS=IENS_$P(LI,",",J)_","
 ..S FLDS=$E(FLDS,",",$L(FLDS))
 .S FDA(ROOT,IENS,FLDS)=NEW D FILE^DIE("","FDA")
 ;
 ;
WORD S ROOT1=$NA(@XPDGREF@("WORD")),CT=0,ROOT2=$NA(@ROOT1@(0))
 F  S CT=$O(@ROOT2) Q:'CT  S ROOT2=$NA(@ROOT1@(CT)),NAME=@ROOT2,ROOT3=$NA(@ROOT2@("D")) K @NAME M @NAME=@ROOT3
 ;
 ;
MESSAGE K ^TMP($J) M ^TMP($J)=@XPDGREF@("MESSAGE") K ^TMP($J,0)
 ;
GROUP K XMY S X=$G(@XPDGREF@("GROUP")),XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 I $D(DUZ) S XMY(DUZ)=""
 ;
 S XMSUB="DATA UPDATE FOR NDF"
 S XMDUZ="NDF MANAGER"
 S XMTEXT="^TMP($J," N DIFROM D ^XMD
 ;
 ;NOW UPDATE LOCAL DRUG FILE
 K ^TMP($J)
 S PSN=$$PATCH^XPDUTL("PSS*1.0*34")
 S ROOT1=$NA(@XPDGREF@("GENERIC")),ROOT2=$NA(@XPDGREF@("PRODUCT")),ROOT3=$NA(@XPDGREF@("POE")),DA=0
 F  S DA=$O(^PSDRUG(DA)) Q:'DA  S X=$G(^(DA,"ND")),GE=+X,PR=+$P(X,"^",3) D
 .I $D(@ROOT1@(GE))!$D(@ROOT2@(PR)) S $P(^PSDRUG(DA,"ND"),"^",1,5)="^^^^",X=$P(^("ND"),"^",10),$P(^("ND"),"^",10)="",^TMP($J,$P(^(0),"^"))="" I X]"" K ^PSDRUG("AQ1",X,DA)
 .I PSN,$D(@ROOT3@(PR)) K ^PSDRUG(DA,"DOS"),^("DOS1"),^("DOS2")
 I $D(^TMP($J)) S DA="",LINE=0 K ^TMP("PSN",$J) D
 .F J=1:1 S X=$P($T(TEXT+J),";",3,30) Q:X=""  S LINE=LINE+1,^TMP("PSN",$J,LINE,0)=X
 .F  S DA=$O(^TMP($J,DA)) Q:DA=""  S LINE=LINE+1,^TMP("PSN",$J,LINE,0)=DA
 .S XMDUZ="NDF MANAGER",XMSUB="DRUGS UNMATCHED FROM NATIONAL DRUG FILE",XMTEXT="^TMP(""PSN"",$J,"
 .K XMY S X=$G(@XPDGREF@("GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 .S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 .I $D(DUZ) S XMY(DUZ)=""
 .N DIFROM D ^XMD I $D(XMZ) S DA=XMZ,DIE=3.9,DR="1.7///P;" D ^DIE
 ;package specific post install
 I $D(@XPDGREF@("POST")) S POST=^("POST") S:POST'["^" POST="^"_POST I @("$T("_POST_")]]""""") D @POST
 ;
QUIT K CT,DA,DIA,DIC,DIE,DIK,DINUM,DLAYGO,DR,FILE,FLDS,GE,GROOT,GROOT1,IENS,J,JJ,K,LI,LINE,NAME,NEW,POST,PR,PSN,PSNDF,R1,ROOT,ROOT1,ROOT2,ROOT3,SUBS,X,XMDUZ,XMSUB,XMTEXT,XMY,^TMP($J),^TMP("PSN",$J)
 Q
 ;
TEXT ;
 ;;The following entries in your local drug file have been unmatched
 ;;from the national drug file.  Until you rematch these entries to
 ;;NDF, they will not transmit to CMOP, drug-drug interaction checks
 ;;will not check for these products, and class-class checks will not
 ;;look at these products.  It is critical that you rematch these
 ;;products immediately.  You may also need to rematch your orderable
 ;;item.
 ;; 
