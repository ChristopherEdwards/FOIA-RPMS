AUM61P1 ;IHS/ASDST/DMJ,SDR - ICD9 MODS TO CODES FOR FY 2006 ; [ 08/18/2003  11:02 AM ]
 ;;06.1;TABLE MAINTENANCE;**1**;SEP 28,2001
 ;
START ;EP
 ;
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 S U="^"
 ;
 D RSLT("Beginning v6.1 p1 ICD Update.")
 D DASH,ICD9REV
 D DASH,ICD0REV
 D RSLT("End v6.1 p1 ICD Update.")
 Q
 ; -----------------------------------------------------
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE ;EP
 NEW @($P($T(SVARS),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
E(L) Q $P($P($T(@L),";",3),":",1)
DIK NEW @($P($T(SVARS),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2104",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO,DINUM) ;EP
 NEW @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
 ; -----------------------------------------------------
ICD9REV ;
 D RSLT($$E("ICD9REVC"))
 D RSLT($J("",8)_"CODE      REVISION")
 D RSLT($J("",8)_"----      ------------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9REVC+AUMI),";;",2) Q:AUMLN="END"  D PROCESS
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD9REV2+AUMI),";;",2) Q:AUMLN="END"  D
 .S Y=$$IXDIC("^ICD9(","IX","AB",$P(AUMLN,U),80)
 .I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 .S DA=+Y
 .S DR="3////"_$P(AUMLN,U,2)  ;diagnosis
 .I $P(AUMLN,U,3)'="" S DR=DR_";10////"_$P(AUMLN,U,3)  ;description
 .S DIE="^ICD9("
 .S AUMDA=DA
 .D DIE
 .I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 .D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 Q
 ;
PROCESS S Y=$$IXDIC("^ICD9(","IX","AB",$P(AUMLN,U),80)
 I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 S DA=+Y
 S DR=".01////"_$P(AUMLN,U,2)
 I $P(AUMLN,U,3)'="" S DR=DR_";3////"_$P(AUMLN,U,3)  ;diagnosis
 I $P(AUMLN,U,4)'="" S DR=DR_";10////"_$P(AUMLN,U,4)  ;description
 S DIE="^ICD9("
 S AUMDA=DA
 D DIE
 I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 Q
 ; -----------------------------------------------------
ICD0REV ;
 D RSLT($$E("ICD0REVC"))
 D RSLT($J("",8)_"CODE      DESCRIPTION")
 D RSLT($J("",8)_"----      -----------")
 NEW AUMDA,AUMI,AUMLN,DA,DIE,DR
 F AUMI=1:1 S AUMLN=$P($T(ICD0REVC+AUMI),";;",2) Q:AUMLN="END"  D
 . S AUMLN=$TR(AUMLN,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 . S Y=$$IXDIC("^ICD0(","IX","AB",$P(AUMLN,U))
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_$P(AUMLN,U)_"' FAILED.") Q
 . S DA=+Y
 . S DR="10///"_$P(AUMLN,U,2)         ;description
 . S DIE="^ICD0("
 . S AUMDA=DA
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_$P(AUMLN,U,1)_"' FAILED.") Q
 . D RSLT($J("",8)_$P(AUMLN,U,1)_$J("",4)_$E($P(AUMLN,U,2),1,30))
 .Q
 Q
PRNT ;;
 S U="^"
 W !," CODE",?10,"DIAGNOSIS",!?10,"DESCRIPTION",!," -----",?10,"-----------"
 NEW X,Y,P2,P3
 F X=1:1 S Y=$P($T(ICD9NEW+X),";;",3),P2=$P(Y,U,2),P3=$P(Y,U,3) Q:Y="END"  W !," ",$P(Y,U,1),?10,$S($L(P3):P3,1:P2),!?10,P2
 Q
ICD9REVC ;;ICD 9 DIAGNOSIS, REVISED CODES: OLD CODE NUMBER (#.01)^CODE NUMBER(#.01)
 ;;259.50^259.5
 ;;327.80^327.8
 ;;585.10^585.1
 ;;585.20^585.2
 ;;585.30^585.3
 ;;585.40^585.4
 ;;585.50^585.5
 ;;585.60^585.6
 ;;585.90^585.9
 ;;V18.90^V18.9
 ;;V69.50^V69.5
 ;;V85.00^V85.0
 ;;V85.10^V85.1
 ;;V85.40^V85.4
 ;;END
ICD9REV2 ;;CODE^DIAGNOSIS^DESCRIPTION
 ;;567.89^OTHER SPECIFIED PERITONITIS^OTHER SPECIFIED PERITONITIS
 ;;599.69^URINARY OBSTRUCTION, NEC
 ;;259.5^ANDROGEN INSENSITIVITY SYNDRME^ANDROGEN INSENSITIVITY SYNDROME
 ;;END
ICD0REVC ;;ICD 0 PROCEDURE, REVISED CODES: CODE NUMBER(#.01)^DESCRIPTION(#10)
 ;;86.94^Insertion or replacement of single array neurostimulator pulse generator, not specified as rechargeable
 ;;86.95^Insertion or replacement of dual array neurostimulator pulse generator, not specified as rechargeable
 ;;END
