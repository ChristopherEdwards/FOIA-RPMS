ACPTPST2 ; IHS/ASDST/DMJ,SDR - CPT POST INIT ;    [ 01/08/2004  10:18 AM ]
 ;;2.08;CPT FILES;;DEC 17, 2007
START ;START HERE
MOD ;EP - hcpcs modifier
 S ACPTFL="acpt2008.c"
 S ACPTCSV=""  ;acpt*2.06*1
 W !!,"Reading HCPCS MODIFIER file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTSFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open hcpcs modifier file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .;S ACPTCD=$E(ACPTCD,1,2)  ;acpt*2.06*1  ;acpt*2.07*1
 .S ACPTCD=$E(X,1,2)  ;acpt*2.07*1
 .;S ACPTCD=$E(X,4,5)  ;acpt*2.06*1  ;acpt*2.07*1
 .;I ACPTCD=ACPTCSV S ACPTFLAG=1  ;acpt*2.06*1  ;acpt*2.07*1
 .;start old code acpt*2.07*1
 .;S ACPTLNE=$E(X,6,10)  ;acpt*2.06*1
 .;S ACPTACDE=$E(X,293)  ;action code acpt*2.06*1
 .;Q:ACPTACDE=""  ;no action code acpt*2.06*1
 .;Q:ACPTACDE="N"  ;no change to code  acpt*2.06*1
 .;Q:ACPTACDE="P"  ;payment change-not stored acpt*2.06*1
 .;I ACPTACDE="D" D  Q  ;delete code and quit acpt*2.06*1
 .;.S ACPTIEN=$O(^AUTTCMOD("B",ACPTCD,0))  ;acpt*2.06*1
 .;.Q:+ACPTIEN=0  ;acpt*2.06*1
 .;.Q:$P($G(^AUTTCMOD(ACPTIEN,0)),"^",4)  ;acpt*2.06*1
 .;.S $P(^AUTTCMOD(ACPTIEN,0),"^",4)=ACPTYR  ;acpt*2.06*1
 .;end old code acpt*2.07*1
 .S A=$E(X,3,30) D DESC S ACPTSD=ACPTDESC
 .S A=$E(X,31,210) D DESC S ACPTLD=ACPTDESC
 .I '$D(^AUTTCMOD("B",ACPTCD)) D
 ..S ACPTIEN=$A($E(ACPTCD,1))_$A($E(ACPTCD,2))
 ..S ^AUTTCMOD(ACPTIEN,0)=ACPTCD
 ..S ^AUTTCMOD("B",ACPTCD,ACPTIEN)=""
 ..S $P(^AUTTCMOD(ACPTIEN,0),"^",3)=ACPTYR
 .;get IEN and edit existing entry
 .S ACPTIEN=$O(^AUTTCMOD("B",ACPTCD,0))
 .;Q:ACPTIEN'>0  ;acpt*2.07*1
 .;I +ACPTLN=1 D  ;acpt*2.06*1
 .;start old code acpt*2.07*1
 .;I +ACPTLNE=100 D  ;acpt*2.06*1
 .;.K ^AUTTCMOD(ACPTIEN,1)
 .;.S ^AUTTCMOD(ACPTIEN,1,0)=""
 .;S ACPTLN=$E(ACPTLNE,3)  ;acpt*2.06*1
 .;S ^AUTTCMOD(ACPTIEN,1,+ACPTLN,0)=ACPTLD  ;acpt*2.06*1
 .;S $P(^AUTTCMOD(ACPTIEN,1,0),"^",3,4)=+ACPTLN_"^"_+ACPTLN  ;acpt*2.06*1
 .;end old code start new code acpt*2.07*1
 .K ^AUTTCMOD(ACPTIEN,1)  ;acpt*2.07*1
 .S ^AUTTCMOD(ACPTIEN,1,1,0)=ACPTLD
 .S $P(^AUTTCMOD(ACPTIEN,1,0),"^",3,4)=1_"^"_1
 .;end new code acpt*2.07*1
 .S:ACPTSD'="" $P(^AUTTCMOD(ACPTIEN,0),"^",2)=ACPTSD
 .;the below modifiers are reused and no short description was sent so what is there is wrong for the new code
 .I ACPTCD="AE"!(ACPTCD="AF")!(ACPTCD="AG")!(ACPTCD="AK")!(ACPTCD="CB")!(ACPTCD="FP")!(ACPTCD="QA") S $P(^AUTTCMOD(ACPTIEN,0),"^",2)=""  ;acpt*2.07*1
 .S $P(^AUTTCMOD(ACPTIEN,0),U,2)=$$UPC($P($G(^AUTTCMOD(ACPTIEN,0)),U,2))  ;acpt*2.07*1
 .S $P(^AUTTCMOD(ACPTIEN,0),"^",4)=""  ;acpt*2.06*1
 .D DOTS^ACPTPOST(ACPTCNT)
 .S ACPTCSV=ACPTCD,ACPTFLAG=""
 D ^%ZISC
 K ACPTSD,ACPTLD  ;acpt*2.06*1
 K ACPTCSV,ACPTFLAG  ;acpt*2.06*1
 K ACPTLNE  ;acpt*2.06*1
 Q
DESC ;STRIP TRAILING BLANKS FROM DESCRIPTION FIELD
 S ACPTDESC=""
 N I F I=0:1:31 S A=$TR(A,$C(I))
 N I F I=1:1:$L(A," ") D
 .S ACPTWORD=$P(A," ",I)
 .Q:ACPTWORD=""
 .S:I>1 ACPTDESC=ACPTDESC_" "
 .S ACPTDESC=ACPTDESC_ACPTWORD
 S ACPTDESC=$$UPC(ACPTDESC)
 K ACPTWORD
 Q
UPC(X) ;EP - UPPER CASE
 N Y
 S Y=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q Y
XREF ;EP - RE-CROSS REFERENCE FILE
 W !,"WILL NOW RE-INDEX CPT MODIFIERS FILE.",!
 S DIK="^AUTTCMOD(" D IXALL^DIK
 Q
FIXCPT ; EP - removes entries where the .01 field is null and marked inactive
 S ACPTDA=0
 F  S ACPTDA=$O(^ICPT(ACPTDA))  Q:'ACPTDA  D
 .S ACPTCD=$P($G(^ICPT(ACPTDA,0)),"^")
 .I ACPTCD="" D  ;if no code
 ..K ^ICPT(ACPTDA)
 Q
