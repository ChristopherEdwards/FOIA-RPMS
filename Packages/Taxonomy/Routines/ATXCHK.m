ATXCHK ; IHS/OHPRD/TMJ - CHECK ICD CODES AGAINST TAXONOMY ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;IHS/TUCSON/LAB - changed VCODE+2 $D TO $E 02/27/95
 ;
ICD(X,Y,Z) ;EP >>EXTRN FUNC to see if ICD code belongs in certain taxonomy
 ;input variables: X=dx ifn, Y=taxonomy ifn, Z=9 for dx or 0 for proc 1 for cpt
 N ATXICD,ATXBEG,ATXEND,ATXFLG
 S ATXFLG=0 I '$D(X)!'$D(Y)!'$D(Z) G EOJ
 I (X="")!(Y="") G EOJ
 ;S ATXICD=$S(Z=9:$P($G(^ICD9(X,0)),U),Z=0:$P($G(^ICD0(X,0)),U),Z=1:$P($G(^ICPT(X,0)),U),1:"")
 ;I ATXICD="" G EOJ
 S ATXICD=$S(Z=9:$P($$ICDDX^ICDCODE(X),U,2),Z=0:$P($$ICDOP^ICDCODE(X),U,2),Z=1:$P($$CPT^ICPTCOD(X),U,2),1:"")
 I ATXICD="" G EOJ
 S ATXBEG=0
 F  S ATXBEG=$O(^ATXAX(Y,21,"AA",ATXBEG)) Q:ATXBEG=""  Q:ATXFLG=1  D
 .S ATXEND=$O(^ATXAX(Y,21,"AA",ATXBEG,0)) Q:ATXEND=""
 .I ATXICD?1A.E D VCODE Q
 .Q:ATXICD<ATXBEG  ;already passed code
 .I ATXICD'>ATXEND S ATXFLG=1 Q  ;found code in taxonomy
EOJ Q ATXFLG
 ;
VCODE ;checks v codes and e codes
 I ATXBEG'?1A.E Q
 I $E(ATXICD)'=$E(ATXBEG) Q  ;don't mix v and e codes ;ihs/tucson/lab changed $D to $E 2/27/95
 Q:$E(ATXICD,2,9)<$E(ATXBEG,2,9)
 I $E(ATXICD,2,9)'>$E(ATXEND,2,9) S ATXFLG=1
 Q
