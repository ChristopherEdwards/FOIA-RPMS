BGOPAUD ; IHS/BAO/TMD - Problem Details ;16-Dec-2015 17:17;DU
 ;;1.1;BGO COMPONENTS;**13,14,19**;Mar 20, 2007;Build 2
 ;---------------------------------------------
CHANGED(PROB,FLDS) ;EP check audit log for changes
 N GLO,E,T,AFIELD,AUTIME,BY,D,LIST,INVTIME,DATA
 S FILE=9000011
 S FLAGS="O"
 S GLO=^DIC(FILE,0,"GL")
 I '$G(START) S START=0
 I '$G(END) D NOW^%DTC S END=%
 S T="" F  S T=$O(^DIA(FILE,"B",PROB,T)) Q:'+T  D
 .S E=$G(^DIA(FILE,T,0)) Q:'E
 .S AFIELD=$P(E,U,3)
 .Q:AFIELD'=FLDS
 .I AFIELD=80001!(AFIELD="1301,.01")!(AFIELD="1701,.01")!(AFIELD="1801,.01") S AFIELD=$$CONCEPT(AFIELD)
 .I AFIELD=80002 S AFIELD=$$DESC(AFIELD)
 .Q:$G(^DIA(FILE,T,3))=""   ;There is no new value
 .S AUTIME=$P(E,U,2)
 .S BY=$P(E,U,4)
 .S INVTIME=9999999-AUTIME
 .S LIST(INVTIME)=T_U_AFIELD_U_BY_U_AUTIME
 S T=PROB_"," F  S T=$O(^DIA(FILE,"B",T)) Q:+T'=PROB  D
 .F D=0:0 S D=$O(^DIA(FILE,"B",T,D)) Q:'D  D
 ..S E=$G(^DIA(FILE,D,0)) Q:'E
 ..S AFIELD=$P(E,U,3)
 ..Q:AFIELD'=FLDS
 ..Q:$G(^DIA(FILE,D,3))=""   ;There is no new value
 ..I AFIELD=80001!(AFIELD="1301,.01")!(AFIELD="1701,.01")!(AFIELD="1801,.01") S AFIELD=$$CONCEPT(AFIELD)
 ..I AFIELD=80002 S AFIELD=$$DESC(AFIELD)
 ..S AUTIME=$P(E,U,2)
 ..S BY=$P(E,U,4)
 ..S INVTIME=9999999-AUTIME
 ..S LIST(INVTIME)=D_U_AFIELD_U_BY_U_AUTIME
 N X,Y,Z,BY,D,CNTP,TXT
 S X=0,CNTP=0
 F  S X=$O(LIST(X)) Q:X=""  D
 .S TXT=""
 .S DATA=$G(LIST(X))
 .S D=$P(DATA,U,1)
 .S T=$G(^DIA(FILE,D,2))
 .;IHS/MSC/MGH P14-not needed anymore
 .;I $P(DATA,U,2)=.05 D
 .;.S T=$TR(T," ","")
 .;.S TI=$P(T,"|",2)
 .;.I TI'="" D
 .;..S TXT=$$DESC(TI)
 .;..I TXT="" S TXT=$G(^DIA(FILE,D,2))
 .;..S TXT=TXT_"|"_$P(T,"|",1)
 .;.E  S TXT=T
 .S TXT=T
 .I TXT'="" D ADD2^BGOPRDD("  #   Previous value: "_TXT)
 .S Y=$$FMTDATE^BGOUTL($P(DATA,U,4))
 .S BY=$P(DATA,U,3)
 .S Z=$$GET1^DIQ(200,BY,.01)
 .S TXT="  #   Edited: "_Y_" by: "_Z
 .D ADD2^BGOPRDD(TXT)
 Q
TMPGBL(X) ;EP
 K ^TMP("BGOAUD",$J) Q $NA(^($J))
CONCEPT(X) ;Find the text of the code
 N RET,IN,OUT,SNO
 S RET=""
 ;S OUT="ARR",IN=X_U_36_U_U_1
 ;S X=$$CNCLKP^BSTSAPI(.OUT,.IN)
 ;I X>0 D
 ;.S RET=$G(ARR(1,"PRE","TRM"))
 S IN=X_"^^^1"
 S SNO=$$CONC^BSTSAPI(IN)
 S RET=$P(SNO,U,4)
 Q RET
DESC(X) ;Find the desc ct
 N RET
 S RET=""
 S RET=$P($$DESC^BSTSAPI(X_"^^1"),U,2)
 Q RET
