AQAOPC82 ; IHS/ORDC/LJF - PROVIDER PROFILE CALC ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code to find all occ activity for a provider
 ;in the occurrence files for a date range.
 ;
 K ^TMP("AQAOPC8",$J) K ^TMP("AQAOPC8A",$J) K ^TMP("AQAOPC8B",$J)
 ;
LOOP ; >> loop thru qi occ provider file for provider
 S AQAOX=0
 F  S AQAOX=$O(^AQAOCC(7,"B",AQAOPROV,AQAOX)) Q:AQAOX=""  D
 .Q:'$D(^AQAOCC(7,AQAOX,0))  S AQAOS=^(0) ;qi occ prv data
 .S AQAOIFN=$P(AQAOS,U,2),AQAOTYP=$P(AQAOS,U,5),AQAOAP=$P(AQAOS,U,6)
 .S:AQAOAP]"" AQAOAP="*" ;attributed action
 .S AQAOLV=$P(AQAOS,U,7) S:AQAOLV]"" AQAOLV=$P(^AQAO1(3,AQAOLV,0),U)
 .S AQAOLV=$E(AQAOLV_"    ",1,4),AQAOTYP=$E(AQAOTYP_"    ",1,4)
 .Q:$P($G(^AQAOC(AQAOIFN,1)),U)'=1  ;occ not closed
 .Q:$$EXCEP^AQAOLKP(AQAOIFN)
 .Q:'$D(^AQAOC(AQAOIFN,0))  S AQAOS=^(0),AQAOCID=$P(AQAOS,U) ;case#
 .S AQAOIND=$P(AQAOS,U,8) ;indicator ifn
 .I '$D(AQAOMSF(0)) Q:'$D(AQAOMSF(AQAOIND))  ;ind not in list
 .S AQAODT=$P(AQAOS,U,4) Q:AQAODT<AQAOBD  Q:AQAODT>AQAOED  ;date chk
 .;
 .; set variables for ^TMP nodes
 .S AQAOM=$S(AQAOMSF=1:10,$P(^AQAO(2,AQAOIND,1),U,3)]"":$P(^(1),U,3),1:10)
 .;S AQAOM=$P(^AQAO(2,AQAOIND,1),U,3) ;msf for ind
 .;S:AQAOM="" AQAOM=10
 .S AQAOIND=$P(^AQAO(2,AQAOIND,0),U)_U_AQAOIND ;ind # & name
 .Q:'$D(^AQAOC(AQAOIFN,"FINAL"))  S S=^("FINAL") ;no close data
 .S X=$P(S,U,4),AQAOF=$S(X="":"??",1:$P(^AQAO(8,X,0),U,2)) ;find
 .S X=$P(S,U,6),AQAOA=$S(X="":"??",1:$P(^AQAO(6,X,0),U,2)) ;action
 .S X=$P(S,U,3),AQAOP=$S(X="":" ",1:$P(^AQAO1(3,X,0),U)) ;potential
 .S X=$P(S,U,7),AQAOO=$S(X="":" ",1:$P(^AQAO1(3,X,0),U)) ;outcome
 .S X=$P(S,U,8),AQAOU=$S(X="":" ",1:$P(^AQAO1(3,X,0),U)) ;ultimate
 .;
 .S AQAOF=$E(AQAOF_"   ",1,4),AQAOA=$E(AQAOA_AQAOAP_"   ",1,4) ;$L = 4
 .S Z="/"
 .S X=AQAOCID_U_AQAOF_Z_AQAOA_Z_AQAOTYP_Z_AQAOLV_Z_Z_AQAOP_Z_AQAOO_Z_AQAOU
 .S ^TMP("AQAOPC8",$J,AQAOM,AQAOIND,AQAODT,AQAOIFN)=X
 .;
 .; increment counts
 .S X=AQAOF_Z_AQAOA_Z_AQAOTYP_Z_AQAOLV
 .S ^TMP("AQAOPC8A",$J,AQAOIND,X)=$G(^TMP("AQAOPC8A",$J,AQAOIND,X))+1
 .S X=AQAOP_Z_AQAOO_Z_AQAOU
 .S ^TMP("AQAOPC8B",$J,AQAOIND,X)=$G(^TMP("AQAOPC8B",$J,AQAOIND,X))+1
 ;
 ;
NEXT ; >> go to print rtn
 G ^AQAOPC83
