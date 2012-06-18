APSPFNC4 ;IHS/MSC/DKM E-Prescribing Support ;03-Aug-2010 12:42;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007,1009**;Sep 23, 2004
 ; Pharmacy List Update Functions
PHLFIL(DIR,FIL,MAX) ; EP - Import updates from a file
 N ERR,POP,CNT
 D OPEN^%ZISH(,DIR,FIL,"R")
 I POP W "File not found",! Q
 S ERR="",MAX=+$G(MAX)
 F CNT=1:1 D  Q:POP!(CNT=MAX)
 .N REC,LP
 .U IO
 .D READNXT^%ZISH(.REC)
 .I '$L($G(REC)) S POP=1 Q
 .S LP=0
 .F  S LP=$O(REC(LP)) Q:'LP  S REC=REC_REC(LP)
 .U IO(0)
 .S ERR=$$PHLREC(REC)
 .W:$L(ERR) CNT,": ",ERR,!
 D CLOSE^%ZISH()
 Q
PHLGBL(GBL) ; EP - Import updates from a local or global array
 N LP,ERR
 S (LP,ERR)=""
 F  S LP=$O(@GBL@(LP)) Q:'$L(LP)  S ERR=$$PHLREC(@GBL@(LP)) Q:$L(ERR)
 Q ERR
PHLREC(REC,DEBUG) ; EP - Import updates from a single record
 N LP,CTL,ERR,FDA,NCPDPID,IEN,SFN,SFNC
 S NCPDPID=$TR($E(REC,1,7)," "),SFNC=1,DEBUG=$G(DEBUG)
 Q:'$L(NCPDPID) "Missing NCPDP ID"
 S IEN=$O(^APSPOPHM("C",NCPDPID,0))
 S FDA=$NA(FDA(9009033.9,$S(IEN:IEN,1:"+1")_","))
 F LP=0:1 S CTL=$P($T(CTL+LP),";;",2,99) Q:'$L(CTL)  D  Q:$D(ERR)
 .N X,FNUM,FNAM
 .S FNAM=$P(CTL,";"),FNUM=$P(CTL,";",2)
 .S X=$P(CTL,";",3),X=$E(REC,X,X+$P(CTL,";",4)-1)
 .F  Q:$A(X,$L(X))'=32  S X=$E(X,1,$L(X)-1)
 .X $P(CTL,";",5)
 .I DEBUG U IO(0) W $P(CTL,";"),"=",X,!
 .I $D(ERR) S ERR="Error processing field "_FNAM_": "_ERR
 .E  Q:'$L(X)
 .E  I FNUM'[":" S @FDA@(FNUM)=X
 .E  D
 ..S SFN=+FNUM,FNUM=$P(FNUM,":",2)
 ..S:'$D(SFN(SFN)) SFNC=SFNC+1,SFN(SFN)="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 ..S:FNUM=.01!$D(FDA(SFN,SFN(SFN),.01)) FDA(SFN,SFN(SFN),FNUM)=X
 Q:$D(ERR) ERR
 K:IEN ^APSPOPHM(IEN,3),^(4)
 D UPDATE^DIE("E","FDA",,"ERR")
 I $G(ERR("DIERR",1)) D  Q ERR
 .S LP=0,ERR=""
 .F  S LP=$O(ERR("DIERR",1,"TEXT",LP)) Q:'LP  S ERR=ERR_$S($L(ERR):" ",1:"")_ERR("DIERR",1,"TEXT",LP)
 Q ""
 ; Convert SS date format to FM
DT(X) S:$L(X) X=+($TR($P(X,"T"),"-")-17000000_"."_$TR($P($P(X,"T",2,99),"."),":"))
 Q
 ; Normalize phone format
PHONE(X) S X=$TR(X,"X() -","x")
 S:X'?10N.(1"x"1.6N) X=""
 Q
 ;Import control data
 ;Format is:
 ;;<SS field name>;<FM field #>;<offset>;<length>;<transform>
CTL ;;NCPDPID;.02;1;7
 ;;StoreNumber;.03;8;35
 ;;ReferenceNumberAlt1;9009033.94:.01;43;35
 ;;ReferenceNumberAlt1Qualifier;9009033.94:.02;78;3
 ;;StoreName;.01;81;35
 ;;StoreName;.1;81;35
 ;;AddressLine1;1.1;116;35
 ;;AddressLine2;1.2;151;35
 ;;City;1.3;186;35
 ;;State;1.4;221;2
 ;;Zip;1.5;223;11;S X=$E(X,1,5)
 ;;PhonePrimary;2.1;234;25;D PHONE(.X)
 ;;Fax;2.2;259;25;D PHONE(.X)
 ;;Email;2.3;284;80
 ;;PhoneAlt1;9009033.93:.01;364;25;D PHONE(.X)
 ;;PhoneAlt1Qualifier;9009033.93:.02;389;3
 ;;PhoneAlt2;9009033.93:.01;392;25;D PHONE(.X)
 ;;PhoneAlt2Qualifier;9009033.93:.02;417;3
 ;;PhoneAlt3;9009033.93:.01;420;25;D PHONE(.X)
 ;;PhoneAlt3Qualifier;9009033.93:.02;445;3
 ;;PhoneAlt4;9009033.93:.01;448;25;D PHONE(.X)
 ;;PhoneAlt4Qualifier;9009033.93:.02;473;3
 ;;PhoneAlt5;9009033.93:.01;476;25;D PHONE(.X)
 ;;PhoneAlt5Qualifier;9009033.93:.02;501;3
 ;;ActiveStartTime;7.1;504;22;D DT(.X)
 ;;ActiveEndTime;7.2;526;22;D DT(.X)
 ;;ServiceLevel;.05;548;5
 ;;PartnerAccount;7.3;553;35
 ;;LastModifiedDate;7.4;588;22;D DT(.X)
 ;;TwentyFourHourFlag;.06;610;1
 ;;CrossStreet;1.6;611;35
 ;;OldServiceLevel;5.1;647;5;S X=$S(X<0:"@",1:X)
 ;;TextServiceLevel;5.2;652;100
 ;;TextServiceLevelChange;5.3;752;100
 ;;NPI;.04;857;10
 ;;
