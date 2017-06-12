LEXXM5 ;ISL/KER - Convert Text to Mix Case (5) ;04/21/2014
 ;;2.0;General Lexicon Utilities;**80**;Sep 23, 1996;Build 10
 ;               
 ; Global Variables
 ;    None
 ;               
 ; External References
 ;    None
 ;               
 ; Local Variables NEWed or KILLed Elsewhere
 ;     LEXNXT,LEXPRE,LEXUSE Newed in LEXXM
 ;     Y set and returned to LEXXM
 ;               
T5 ; 5 Characters
 N XU,CHR,NUM,TRL,PRE,UIN,NXT,USE,P1,P2 S PRE=$G(LEXPRE),NXT=$G(LEXNXT),USE=$G(LEXUSE),UIN=$G(UIN),XU=$$UP(X),CHR=$E(XU,1)
 ;   Exceptions
 S P1=$E(XU,1,($L(XU)-2)),P2=$E(XU,($L(XU)-1),$L(XU)) I "^CC^ML^GM^"[("^"_P2_"^"),$E(P1,$L(P1))?1N S Y=$$LO(XU) Q
 S NUM=$E(XU,1,3),TRL=$E(XU,4,5) I +NUM=NUM,((TRL="TH")!(TRL="ST")!(TRL="RD")) S Y=$$LO(XU) Q:$L($G(Y))
 S:$E(XU,1)?1U&($E(XU,5)?1N) Y=XU Q:$L($G(Y))  S:$E(XU,1)?1N&($E(XU,5)?1U) Y=XU Q:$L($G(Y))
 S:XU="THREE"&($G(UIN)["DIMENSION") Y=$$MX(XU) Q:$L($G(Y))
 S:XU="AREAS"&($G(PRE)["MORE") Y=$$LO(XU) Q:$L($G(Y))
 ;   Special Case
 S:X="CVIBI" Y="CviBI" S:X="DNASE" Y="DNase" S:X="ECORI" Y="EcoRI" Q:$L($G(Y))
 S:X="GROEL" Y="GroEL" S:X="HAEII" Y="HaeII" S:X="HBSAG" Y="HBsAg" Q:$L($G(Y))
 S:X="HINFI" Y="HinfI" S:X="HNRNP" Y="hnRNP" S:X="HPAII" Y="HpaII" Q:$L($G(Y))
 S:X="HPGRF" Y="hpGRF" S:X="MBOII" Y="MboII" S:X="MELEU" Y="MeLeu" Q:$L($G(Y))
 S:X="MEPHE" Y="MePhe" S:X="MEPRO" Y="MePro" S:X="NEUAC" Y="NeuAc" Q:$L($G(Y))
 S:X="PTHRP" Y="PTHrP" S:X="RNASE" Y="RNase" S:X="SALGI" Y="SalGI" Q:$L($G(Y))
 S:X="SNRNP" Y="snRNP" Q:$L($G(Y))
 ;   Lower Case
 I "EQUAL"=XU&($E(USE,($L(USE)-12),$L(USE))["THAN OR") S Y=$$LO(X) Q
 I "^ABOVE^AFTER^BELOW^COULD^FIFTH^FIRST^FORTH^FOUND^GIVEN^HOURS"[("^"_XU_"^") S Y=$$LO(X) Q
 I "^LOWER^MAJOR^OFTEN^OTHER^OUTER^RIGHT^SITES^SIXTH^THERE^THESE"[("^"_XU_"^") S Y=$$LO(X) Q
 I "^THIRD^THREE^UPPER^USING^WHERE^WHICH^WOULD"[("^"_XU_"^") S Y=$$LO(X) Q
 ;   Mixed Case
 I "^APRIL^ARBOR^BARRE^BEACH^BLACK^BLUFF^BRONX^CLOUD^CREEK^DIEGO"[("^"_XU_"^") S Y=$$MX(X) Q
 I "^DRIVE^FALLS^FARGO^GOISE^GRAND^HAVEN^HILLS^HINES^JUNCT^LINDA"[("^"_XU_"^") S Y=$$MX(X) Q
 I "^LOUIS^LYONS^MARCH^MEADE^MIAMI^MILES^NORTH^OMAHA^PASSO^PERRY"[("^"_XU_"^") S Y=$$MX(X) Q
 I "^PINES^PITTS^POINT^PUGET^RIVER^RIVER^SAINT^SALEM^SIOUX^SOUND"[("^"_XU_"^") S Y=$$MX(X) Q
 I "^SOUTH^TAMPA^TEXAS^TOGUS^TOMAH^VEGAS^WALLA^WAYNE^WHITE"[("^"_XU_"^") S Y=$$MX(X) Q
 ;   Uppercase
 I "^1003F^1004F^1006F^1007F^1031C^2000F^2001F^2002F^2003F^2004F"[("^"_XU_"^") S Y=XU Q
 I "^ALLA1^AREDS^BRCA1^BRCA2^BRDCL^C1251^CCAAT^CCHIT^CCND1^CD117"[("^"_XU_"^") S Y=XU Q
 I "^COPD1^CTLSO^CTLSO^DDIT3^DOPAC^DPDPE^EPSDT^EPSDT^EPTFE^ERRB2"[("^"_XU_"^") S Y=XU Q
 I "^EWSR1^HBSAG^HCPCS^HGSIL^HKAFO^HKAFO^HNPCC^IGFBP^JAZF1^JJAZ1"[("^"_XU_"^") S Y=XU Q
 I "^KAPPA^LGSIL^MELAS^MERRF^MERRF^MYH11^NSAID^NADPH^NIDDM^NR4A3^PACAP"[("^"_XU_"^") S Y=XU Q
 I "^PDGFB^PPROM^QSART^RBF56^RUNX1^SAECG^SAIDS^SEWHO^SPECT^SPECT"[("^"_XU_"^") S Y=XU Q
 I "^STAAR^T1MIC^TCF12^THKAO^TKHAO^XVIII^XXIII^ZPACK"[("^"_XU_"^") S Y=XU Q
 Q
 ;          
LO(X) ; Lower Case
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UP(X) ; Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
MX(X) ; Mix Case
 Q $TR($E(X,1),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")_$TR($E(X,2,$L(X)),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
LD(X) ; Leading Character
 Q $TR($E(X,1),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")_$E(X,2,$L(X))
TRIM(X) ; Trim Spaces
 S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
 Q X
