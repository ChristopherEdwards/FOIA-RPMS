LA7VORUA ;VA/DALOI/JMC - Builder of HL7 Lab Results NTE ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**61,64,1027**;NOV 01, 1997
 ;
 ;
NTE ; Build NTE segment
 ;
 N LA7NTE,LA7SOC,LA7TXT,LA7X,X
 ;
 ; Initialize segment set id
 S LA7NTESN=0
 ; Source of comment - handle other system's special codes, i.e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"AC",1:"L")
 ;
 ; Send "MI" specimen's comments
 I LA("SUB")="MI" D
 . K LA7NTE
 . S LA7TXT=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),99))
 . S LA7TXT=$$TRIM^XLFSTR(LA7TXT,"R"," ")
 . I LA7TXT="" Q
 . D NTE^LA7VORU1
 ;
 ; Send "CH" specimen's comments
 I LA("SUB")="CH" D
 . S LA7X=0
 . F  S LA7X=$O(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),1,LA7X)) Q:'LA7X  D
 . . K LA7NTE
 . . S LA7TXT=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),1,LA7X,0))
 . . D BNTE
 Q
 ;
 ;
PLC ; Performing lab comment
 N LA74,LA7DIV,LA7NTE,LA7RNLT,LA7SOC,LA7TSTN,LA7TXT,LA7X,X
 S (LA74,LA7DIV,LA7RNLT,LA7TSTN)=""
 ;
 ; Source of comment - handle other system's special codes, i.e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"DS",1:"L")
 ;
 ; Find reporting facility (division).
 I LA("SUB")="CH" D
 . S LA7X=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),$P(LA7VT,"^")))
 . S LA74=$P(LA7X,"^",9)
 . S LA7RNLT=$P($P(LA7X,"^",3),"!",2)
 I LA74="" S LA74=+$P($G(^XMB(1,1,"XUS")),"^",17)
 I LA74 S LA7DIV=$$NAME^XUAF4(LA74)
 ;
 ; Build result test name
 I LA7RNLT="" D
 . I $G(LA("NLT"))'="" S LA7RNLT=LA("NLT") Q
 . S LA7RNLT=$G(LA7NLT)
 I LA7RNLT D
 . S LA7X=$O(^LAM("E",LA7RNLT,0))
 . I LA7X S LA7TSTN=$$GET1^DIQ(64,LA7X_",",.01,"I")
 ;
 S LA7TXT=LA7TSTN_" results from "_LA7DIV_"."
 D NTE^LA7VORU1
 S X=$$PADD^XUAF4(LA74)
 S LA7TXT=$P(X,U)_" "_$P(X,U,2)_", "_$P(X,U,3)_" "_$P(X,U,4)
 D NTE^LA7VORU1
 Q
 ;
 ;
INTRP ; Send test interpretation
 ; Send "CH" subscript file #60 site/specimen's interpretation field (#5.5)
 ;
 N LA760,LA761,LA7NTE,LA7SOC,LA7TXT,LA7X,LA7Y,LRSB
 ;
 S LRSB=$P(LA7VT,"^"),LA7Y=0
 S LA761=+$P(LA763(0),"^",5)
 S LA7X=^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),LRSB)
 S LA760=+$P($P(LA7X,"^",3),"!",5)
 I LA760,$D(^LAB(60,LA760,1,LA761,1)) S LA7Y=1
 I 'LA760 D
 . S LA760=0
 . F  S LA760=$O(^LAB(60,"C","CH;"_LRSB_";1",LA760)) Q:'LA760  D  Q:LA7Y
 . . I $D(^LAB(60,LA760,1,LA761,1)) S LA7Y=1
 ;
 I 'LA7Y Q
 ;
 ; Source of comment - handle other system's special codes, i.e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"RI",1:"L")
 ;
 ; Build each line of interpretation as a NTE segment.
 S LA7X=0
 F  S LA7X=$O(^LAB(60,LA760,1,LA761,1,LA7X)) Q:'LA7X  D
 . S LA7TXT=$G(^LAB(60,LA760,1,LA761,1,LA7X,0))
 . D BNTE
 ;
 Q
 ;
 ;
BNTE ; Build NTE segment
 ;
 I $E(LA7TXT,1)="~" S LA7TXT=$$TRIM^XLFSTR(LA7TXT,"L","~")
 S LA7TXT=$$TRIM^XLFSTR(LA7TXT,"R"," ")
 I LA7TXT="" S LA7TXT=" "
 D NTE^LA7VORU1
 Q
