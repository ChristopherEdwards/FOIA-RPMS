INHUTS1 ;JMB; 17 Jul 95 14:21;Monitoring utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
RD(PROMPT,DEF,RANGE) ;Read a parameter
 ;INPUT:
 ;  PROMPT - prompt for user
 ;  DEF - default value (default to no or 0)
 ;  RANGE - type of question (yes/no (def) or numeric)
 ;             nuemric range = hi , lo  ex. "1,10"
 ;OUTPUT:
 ;  function - user's answer (or "^" if user aborted)
 ;
 N ANS
 S ANS=U
 ;Handle yes/no type questions
 I $G(RANGE)="YN"!($G(RANGE)="") S ANS=$$YN^UTSRD(PROMPT_": ;"_+$G(DEF)) S:ANS[U ANS=U Q ANS
 ;Handle numeric questions
 W ! D ^UTSRD(PROMPT_": ;;;;"_+$G(DEF)_";"_RANGE)
 S ANS=X S:X[U!$G(DTOUT) ANS=U
 Q ANS
 ;
DES0 ;Load array of queues to check
 ;  Includes Transmiters and Receivers
 ;  Includes the Format Controler and Output Controller
 ;OUTPUT:
 ;  INDEST - array of queues to check
 ;
 N BP,BP0
 K INDEST S BP=0
 ;Loop through Background Process Control file
 F  S BP=$O(^INTHPC(BP)) Q:'BP  S BP0=$G(^INTHPC(BP,0)) D
 .  ;Check if process is NOT active
 .  Q:'$P(BP0,U,2)
 .  ;Place into list of queues
 .  S INDEST(BP)=$P(BP0,U)
 Q
 ;
DES1 ;Load array of queues to check
 ; Includes Transmitters only (no Receivers)
 ; Does not include the Format Controller and Output Controller
 ;OUTPUT:
 ;  INDEST - array of queues to check
 ;            format -> queue name ^ location (global) of queue
 ;
 K INDEST S BP=2
 ;Loop through Background Process Control file
 F  S BP=$O(^INTHPC(BP)) Q:'BP  S BP0=$G(^INTHPC(BP,0)) D
 .  ;Check for a destination
 .  S D=$P(BP0,U,7) Q:'D
 .  ;Check if process is NOT active and no messages in queue 
 .  Q:'$P(BP0,U,2)&'$D(^INLHDEST(D))
 .  ;Check for transmitters only (no receivers)
 .  Q:$P(^INTHPC(BP,0),U)'["TRANSMIT"
 .  ;Place into list of queues
 .  S INDEST(BP)=$P(BP0,U)_U_"INLHDEST("_D_")"
 Q
