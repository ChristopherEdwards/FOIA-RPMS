IBDFN8 ;ALB/CJM - ENCOUNTER FORM - PCE GDI INPUT TRANSFORMS;AUG 10, 1995
 ;;3.0;AUTOMATED INFO COLLECTION SYS;**25,38**;APR 24, 1997
 ;
INPUTCPT(X) ;changes X,a CPT code, into its ien
 ;
 ;   --input: cpt code
 ;   
 ;   --output: ien of cpt code (file #81)
 ;
 S X=$$UPP(X)
 S X=+$$CPT^ICPTCOD(X)
 I +X=-1 K X Q
 Q
 ;
INPUTICD(ICD) ;changes X, an ICD9 code, into its ien
 ;
 S ICD=$$UPP(ICD)
 S X=$O(^ICD9("BA",ICD_" ",0))
 K:'X X
 Q
 ;
UPP(X) ; -- convert lower case to upper case (especially when in codes above)
 Q $TR(X,"zxcvbnmlkjhgfdsaqwertyuiop","ZXCVBNMLKJHGFDSAQWERTYUIOP")
