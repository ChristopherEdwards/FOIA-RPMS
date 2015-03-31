APSPFNC4 ;IHS/MSC/DKM E-Prescribing Support ;10-Sep-2013 13:59;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007,1009,1016**;Sep 23, 2004;Build 74
 ;==============================================================
 ; Pharmacy List Update Functions
 ; Patch 1016 added XUMF variable
PHLFIL(DIR,FIL,MAX) ; EP - Import updates from a file
 N ERR,POP,CNT,XUMF
 D OPEN^%ZISH(,DIR,FIL,"R")
 I POP W "File not found",! Q
 S ERR="",MAX=+$G(MAX)
 S XUMF=1
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
 N LP,CTL,ERR,FDA,NCPDPID,IEN,SFN,SFNC,STNAME,IENS
 S NCPDPID=$TR($E(REC,1,7)," "),SFNC=1,DEBUG=$G(DEBUG)
 Q:'$L(NCPDPID) "Missing NCPDP ID"
 S STNAME=$TR($E(REC,43,78)," ")
 Q:'$L(STNAME) "Missing Store Name"
 S IEN=$O(^APSPOPHM("C",NCPDPID,0))
 I IEN D DELSPEC(IEN)
 S FDA=$NA(FDA(9009033.9,$S(IEN:IEN,1:"+1")_","))
 F LP=0:1 S CTL=$P($T(CTL44+LP),";;",2,99) Q:'$L(CTL)  D  Q:$D(ERR)
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
 ..;S:'$D(SFN(SFN)) SFNC=SFNC+1,SFN(SFN)="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 ..S:FNUM=.01 SFNC=SFNC+1,IENS="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 ..Q:'$L($G(IENS))
 ..S:FNUM=.01!$D(FDA(SFN,IENS,.01)) FDA(SFN,IENS,FNUM)=X
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
 S:X'?10N.(1"x"1.14N) X=""
 Q
SPEC(X) ; Put specialty into upper case
 D SCHAR(.X)
 S X=$$UP^XLFSTR(X)
 Q
SCHAR(X) ; Remove characters that interfere with fileman
 S X=$TR(X,"^&","")
 Q
DELSPEC(IEN) ;Delete exisiting specialties
 K NUM,DA,DIK
 S NUM=0 F  S NUM=$O(^APSPOPHM(IEN,8,NUM)) Q:NUM=""  D
 .S DA(1)=IEN,DA=NUM
 .S DIK="^APSPOPHM(IEN,8,"
 .D ^DIK
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
 ;Import control data for version 4.4
 ;Format is:
 ;;<SS field name>;<FM field #>;<offset>;<length>;<transform>
CTL44 ;;NCPDPID;.02;1;7;D SCHAR(.X)
 ;;StoreNumber;.03;8;35;D SCHAR(.X)
 ;;StoreName;.01;43;35;D SCHAR(.X)
 ;;StoreName;.1;43;35;D SCHAR(.X)
 ;;AddressLine1;1.1;78;35;D SCHAR(.X)
 ;;AddressLine2;1.2;113;35;D SCHAR(.X)
 ;;City;1.3;148;35;D SCHAR(.X)
 ;;State;1.4;183;2;D SCHAR(.X)
 ;;Zip;1.5;185;11;D SCHAR(.X) S X=$E(X,1,5)
 ;;PhonePrimary;2.1;196;25;D PHONE(.X)
 ;;Fax;2.2;221;25;D PHONE(.X)
 ;;Email;2.3;246;80;D SCHAR(.X)
 ;;PhoneAlt1;9009033.93:.01;326;25;D PHONE(.X)
 ;;PhoneAlt1Qualifier;9009033.93:.02;351;3;D SCHAR(.X)
 ;;PhoneAlt2;9009033.93:.01;354;25;D PHONE(.X)
 ;;PhoneAlt2Qualifier;9009033.93:.02;379;3;D SCHAR(.X)
 ;;PhoneAlt3;9009033.93:.01;382;25;D PHONE(.X)
 ;;PhoneAlt3Qualifier;9009033.93:.02;407;3;D SCHAR(.X)
 ;;PhoneAlt4;9009033.93:.01;410;25;D PHONE(.X)
 ;;PhoneAlt4Qualifier;9009033.93:.02;435;3;D SCHAR(.X)
 ;;PhoneAlt5;9009033.93:.01;438;25;D PHONE(.X)
 ;;PhoneAlt5Qualifier;9009033.93:.02;463;3;D SCHAR(.X)
 ;;ActiveStartTime;7.1;466;22;D DT(.X)
 ;;ActiveEndTime;7.2;488;22;D DT(.X)
 ;;ServiceLevel;.05;510;5;D SCHAR(.X)
 ;;PartnerAccount;7.3;515;35;D SCHAR(.X)
 ;;LastModifiedDate;7.4;550;22;D DT(.X)
 ;;CrossStreet;1.6;572;35;D SCHAR(.X)
 ;;RecordChange;6.1;607;1;D SCHAR(.X)
 ;;OldServiceLevel;5.1;608;5;D SCHAR(.X) S X=$S(X<0:"@",1:X)
 ;;TextServiceLevel;5.2;613;100;D SCHAR(.X)
 ;;TextServiceLevelChange;5.3;713;100;D SCHAR(.X)
 ;;Version;6.2;813;5;D SCHAR(.X)
 ;;NPI;.04;818;10;D SCHAR(.X)
 ;;SpecialtyType1;9009033.98:.01;828;35;D SPEC(.X)
 ;;SpecialtyType2;9009033.98:.01;863;35;D SPEC(.X)
 ;;SpecialtyType3;9009033.98:.01;898;35;D SPEC(.X)
 ;;SpecialtyType4;9009033.98:.01;933;35;D SPEC(.X)
 ;;MedicareNumber;6.3;1038;35;D SCHAR(.X)
 ;;MedicaidNumber;6.4;1073;35;D SCHAR(.X)
 ;;
