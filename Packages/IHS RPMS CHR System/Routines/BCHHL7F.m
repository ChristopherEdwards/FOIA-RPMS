BCHHL7F ; IHS/TUCSON/LAB - ADD NEW CHR ACTIVITY RECORDS ;  [ 04/28/06  3:21 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**16**;OCT 28, 1996
 ;
 ;  Driver for filing HL7 messages.
 ;  Array of data is passed from GIS
 ;  
 ;
MAIN ;EP - called from GIS interface
 S BHLNOST=1 D ^BHLSETI
 D ^BHLFO
 S U="^"
 I '$D(BHL) Q  ;no BHL array so don't bother
 D EN^XBVK("BCH")
 K BCHDAR ;array of data values for filing
 D CHECK  ;check for required pieces of data/valid data, if req element missing file error
 I BCHERR D ERRLOG,XIT Q
 D GETPAT
 I BCHERR D ERRLOG,XIT Q
 D FILEREC
 I $G(BCHERR) D ERRLOG
 D XIT
 Q
GETPAT ;
 S BCHPAT=""
 S BCHNAME=$P($G(BHL("PID",1,5)),U,1)_","_$P($G(BHL("PID",1,5)),U,2)
 S BCHCHRN=$P($G(BHL("PID",1,3)),"^",1)
 S BCHFACH=$E(BCHCHRN,1,6)
 S BCHFHRN=$O(^AUTTLOC("C",BCHFACH,0))
 S BCHHRN=+$E(BCHCHRN,7,99)
 I 'BCHFHRN Q
 S BCHSEX=$G(BHL("PID",1,8))
 S BCHDOB=""
 S X=$G(BHL("PID",1,7))
 I X]"" S X=$E(X,5,6)_"/"_$E(X,7,8)_"/"_$E(X,1,4),%DT="P" D ^%DT S BCHDOB=Y I Y=-1 S BCHDOB=""
 S X=0 F  S X=$O(^AUPNPAT("D",BCHHRN,X)) Q:X'=+X  I $D(^AUPNPAT("D",BCHHRN,X,BCHFHRN)) S BCHPAT=X
 I 'BCHPAT Q
 ;now check DOB and sex, if they don't match don't point to patient
 I $P(^DPT(BCHPAT,0),"^",2)'=BCHSEX S BCHPAT="" Q
 I $P(^DPT(BCHPAT,0),"^",3)'=BCHDOB S BCHPAT="" Q
 Q
FILEREC ;
 S X=$O(^BCHR("CUI",BCHUID,0)) I X S BCHACT="M"  ;says add but have that record
 I BCHACT="M" D MODIFY Q
 D ADD
 Q
ADD ;
 ;create and file BCHR record entry
 D ^XBFMK
 S DIC="^BCHR(",DIC(0)="L",X=BCHDOS,%DT="T" D ^%DT S X=Y,DLAYGO=90002,DIC("DR")=".16////"_DUZ_";.17////"_DT_";.22////"_DT_";.26////R" K DD,DO D FILE^DICN
 I Y=-1 S BCHERR=1,BCHERR("ERROR")="CREATING CHR RECORD ENTRY FAILED" Q
 S BCHR=+Y
 D EDITREC
 I BCHERR Q
 D POVS
 D FILEMEAS
 D FILEDMO
 D PCCLINK
 Q
EDITREC ;
 K BCHFDA
 S BCHFDA(90002,BCHR_",",.02)=BCHPROG
 S BCHFDA(90002,BCHR_",",.03)=BCHCHR
 I $G(BCHPAT) S BCHFDA(90002,BCHR_",",.04)=BCHPAT
 I $G(BCHFACL) S BCHFDA(90002,BCHR_",",.05)=BCHFACL
 S BCHFDA(90002,BCHR_",",.06)=BCHACTLI
 S BCHFDA(90002,BCHR_",",.07)=BCHREFT
 S BCHFDA(90002,BCHR_",",.08)=BCHREFF
 S BCHFDA(90002,BCHR_",",.09)=BCHEVAL
 S BCHFDA(90002,BCHR_",",.11)=BCHTRAV
 S BCHFDA(90002,BCHR_",",.12)=BCHNS
 S BCHFDA(90002,BCHR_",",.21)=BCHUID
 S BCHFDA(90002,BCHR_",",1108)=BCHTEMPR
 S BCHERR=""
 D FILE^DIE("KS","BCHFDA","BCHERR")
 I BCHERR S BCHERR("ERROR")="UPDATING CHR RECORD ENTRY FAILED FILEMAN"
 K BCHFDA
 Q
POVS ;
 D ^XBFMK
 Q:'$D(BCHPOVS)
 S APCDOVRR=1
 S BCHN=0 F  S BCHN=$O(BCHPOVS(BCHN)) Q:'BCHN  D
 .S X=$P(BCHPOVS(BCHN),U),X=$$UP^XLFSTR(X) I X="" S BHLERR=1,BHLERR("ERROR")="POV PROBLEM CODE FAILED" Q
 .S DIC="^BCHRPROB(",DIC("DR")=".02////^S X=$G(BCHPAT);.03////^S X=BCHR",DLAYGO=90002.01,DIADD=1,DIC(0)="L" K DD,DO D FILE^DICN K DIADD,DLAYGO
 .I Y=-1 S BHLERR=1,BCHERR("ERROR")="ERROR IN DICN ADDING A POV" Q
 .S BCHPOV=+Y
 .D ^XBFMK
 .S DA=BCHPOV,DIE="^BCHRPROB("
 .S BCHSRV=$P(BCHPOVS(BCHN),U,2),BCHSRV="`"_BCHSRV
 .S DR=".04///"_BCHSRV_";.05////"_$P(BCHPOVS(BCHN),U,3)_";.06///"_$P(BCHPOVS(BCHN),U,4)_";.07///"_$P(BCHPOVS(BCHN),U,5)
 .D ^DIE
 .I $D(Y) S BCHERR=1,BCHERR("ERROR")="ERROR UPDATING POV RECORD - DIE"
 .D ^XBFMK
 K APCDOVRR
 Q
 ;
FILEDMO ; get patient based on chart number passed, check dob and sex
 ; if same use IEN, otherwise do not
 ;
 Q:BCHPAT
 I BCHNAME="",BCHDOB="",BCHSEX="" Q  ;not a patient encounter
 S BCHSSN=$G(BHL("PID",1,19)) I BCHSSN'?9N S BCHSSN=""
 S BCHTRI=$P($G(BHL("ZP2",1,15)),"^",1) I BCHTRI S BCHTRI=$O(^AUTTTRI("C",BCHTRI,0))
 S BCHCOM=$G(BHL("ZHR",1,1)) I BCHCOM]"" S BCHCOMP=$O(^AUTTCOM("C",BCHCOM,0))
 D ^XBFMK
 S DIE="^BCHR(",DA=BCHR,DR="1101///"_BCHNAME_";1102////"_BCHDOB_";1103///"_BCHSEX_";1104///"_BCHSSN_";1111///"_BCHHRN_";1109////"_BCHFHRN
 S DR=DR_";1107////"_BCHCOM_";1105////"_BCHTRI_";1106////"_BCHCOMP
 D ^DIE
 I $D(Y) S BHLERR="ERROR UPDATING AN ITEM IN THE DEMO NODE"
 Q
 ;
FILEMEAS ; file all tests
 ;
 Q:'$D(BCHMEAS)
 S BCHN=0 F  S BCHN=$O(BCHMEAS(BCHN)) Q:'BCHN  S BCHMTYP=$P(BCHMEAS(BCHN),U,1),BCHVALUE=$P(BCHMEAS(BCHN),U,2) D
 .S BCHTIEN=$O(^BCHTMT("B",BCHMTYP,0)) I BCHTIEN="" S BCHERR=1,BCHERR("ERROR")="MEASUREMENT TYPE NOT FOUND IN TABLE" Q
 .S BCHFIELD=$P(^BCHTMT(BCHTIEN,0),U,3) I BCHFIELD="" Q  ;this is temporary ************ only fields 1201-1210 work, will do lab tests later
 .;file measurement
 .D ^XBFMK S DIE="^BCHR(",DA=BCHR,DR=BCHFIELD_"///"_BCHVALUE D ^DIE
 .I $D(Y) S BCHERR="DIE FAILED UPDATING "_BCHMTYP_" VALUE" Q
 .Q
 Q
PCCLINK ;
 ;
 S BCHEV("TYPE")="A" ; add, edit or delete
 D PROTOCOL^BCHUADD1
 K BCHEV,BCHR
 Q
MODIFY ;
 S BCHR=$O(^BCHR("CUI",BCHUID,0))
 I BCHR="" D ADD Q  ;couldn't find this record so do add
 S BCHSTOP=1 D DELETE^BCHUDEL K BCHSTOP
 D ADD
 Q
ERRLOG ;
 ;file error into CHR
 D ^XBFMK K DLAYGO,DIADD
 S U="^"
 S X=$$NOW^XLFDT,DIC="^BCHHLER(",DIC(0)="L",DIADD=1,DLAYGO=90002
 K DD,D0,DO D FILE^DICN K DIADD,DLAYGO
 S BCHEIEN=+Y
 Q:'BCHEIEN
 D ^XBFMK
 S DIE="^BCHHLER(",DA=BCHEIEN,DR=".02////"_BCHERR("ERROR") D ^DIE
 S BCHTEXT="ERRF" F BCHX=1:1 S BCHDATA=$P($T(@BCHTEXT+BCHX),";;",2,99) Q:BCHDATA=""  D
 .D ^XBFMK
 .S V=$P(BCHDATA,";;",2) S X="" X V
 .S DR=$P(BCHDATA,";;",1)_"////"_X,DIE="^BCHHLER(",DA=BCHEIEN D ^DIE
 .Q
 ;now save off the BHL obr and obx arrays into 12 nodes
 S BCHC=0,BCHCNTR=0 F  S BCHC=$O(BHL("OBR",BCHC)) Q:BCHC'=+BCHC  D
 .S BCHD=0 F  S BCHD=$O(BHL("OBR",BCHC,BCHD)) Q:BCHD'=+BCHD  D
 ..Q:BHL("OBR",BCHC,BCHD)=""
 ..S BCHCNTR=BCHCNTR+1,^BCHHLER(BCHEIEN,12,BCHCNTR,0)=BHL("OBR",BCHC,BCHD)
 .S BCHE=0 F  S BCHE=$O(BHL("OBX",BCHC,BCHE)) Q:BCHE'=+BCHE  D
 ..S BCHF=0 F  S BCHF=$O(BHL("OBX",BCHC,BCHE,BCHF)) Q:BCHF'=+BCHF  D
 ...Q:BHL("OBX",BCHC,BCHE,BCHF)=""
 ...S BCHCNTR=BCHCNTR+1,^BCHHLER(BCHEIEN,12,BCHCNTR,0)=BHL("OBX",BCHC,BCHE,BCHF)
 ..Q
 .Q
 S ^BCHHLER(BCHEIEN,12,0)="^^"_BCHCNTR_"^"_BCHCNTR_"^"_DT_"^"
 Q
XIT ;
 D KILL^AUPNPAT
 D EN^XBVK("BCH")
 K BHL
 Q
CHECK ;
 ;         - in order to file a record into the CHR Module
 ;         - the following field values must be present and valid
 ;           . there must be at least one OBR/OBX combination that is
 ;             not a test and measurement OBR this segment must have a
 ;             health problem code and activity code pair in OBX
 ;           . CHR - provider ID, OBR 32
 ;           . DATE OF SERVICE - OBR 7 
 ;           . CHR PROGRAM CODE - ZHR 2
 ;           . ACTIVITY LOCATION - ZHR 3
 ;   
 ; check for value and transform into fileable format in separate array   
 ; chr program code in variable BCHPROG, can be 4 slashed
 K BCHERR
 S BCHERR=0  ;if error then set to 1 and set BCHERR("ERROR")="error message"
 S X=$G(BHL("ZHR",1,2)) I X="" S BCHERR=1,BCHERR("ERROR")="Program code missing" Q
 S BCHPROG=$O(^BCHTPROG("C",X,0)) I X="" S BCHERR=1,BCHERR("ERROR")="Program code passed could not be found in table." Q
 ; check for chr activity location
 S (X,BCHACTL)=$G(BHL("ZHR",1,3)) S:X="-" (X,BCHACTL)="--" I X="" S BCHERR=1,BCHERR("ERROR")="Activity Location missing" Q
 S BCHACTLI=$O(^BCHTACTL("D",X,0)) I BCHACTLI="" S BCHERR=1,BCHERR("ERROR")="Invalid Activity Location passed" Q
 ;BCHACTLI can be 4 slashed when filing, internal format of pointer
 S BCHFACL=$G(BHL("PV1",1,3)) S:BCHACTL'="HC" BCHFACL="" I BCHACTL="HC" D  Q:BCHERR
 .I BCHFACL="" S BCHERR=1,BCHERR("ERROR")="Patient location missing and activity location is HC" Q
 .S BCHFACL=$O(^AUTTLOC("C",BCHFACL,0)) I BCHFACL="" S BCHERR=1,BCHERR("ERROR")="Invalid patient location passed for activity location HC" Q
 ; check and set OBR/OBX
 K BCHPOVS
 K BCHMEAS
 S BCHPOVC=0
 S BCHC=0 F  S BCHC=$O(BHL("OBR",BCHC)) Q:BCHC'=+BCHC!(BCHERR)  D
 . ;get date of service from field 7
 . S (BCHPROB,BCHSRV,BCHMIN,BCHNARR,BCHSUBST)=""
 . S BCHDOS=$G(BHL("OBR",BCHC,7)) I BCHDOS="" S BCHERR=1,BCHERR("ERROR")="Date of Service Missing" Q
 . S BCHDOS=$E(BCHDOS,1,7)
 . ;convert to internal fileman format
 . ;NEW G,X,Y,%DT S X=BCHDOS,%DT="P" D ^%DT S BCHDOS=Y I BCHDOS=-1 S BCHERR=1,BCHERR("ERROR")="Date of service invalid" Q
 . ;get provider from field 32
 . S BCHT=$G(BHL("OBR",BCHC,4))
 . I BCHT["TM^TESTS AND MEASUREMENTS" D MEAS Q
 . ;process problem code/service code obxs
 . S BCHCHR=$P($G(BHL("OBR",BCHC,32)),"^",2) I BCHCHR="" S BCHERR=1,BCHERR("ERROR")="CHR Provider missing" Q
 . S BCHCHR=$O(^VA(200,"GIHS",BCHCHR,0)) I BCHCHR="" S BCHERR=1,BCHERR("ERROR")="CHR Provider not found in Provider file (file 200)." Q
 . S BCHX=0 F  S BCHX=$O(BHL("OBX",BCHC,BCHX)) Q:BCHX'=+BCHX!(BCHERR)  D
 .. S BCHVAL=$G(BHL("OBX",BCHC,BCHX,3))
 .. S BCHT=$P(BCHVAL,"^",3)
 .. I BCHT="" S BCHERR=1,BCHERR("ERROR")="Error in OBX segment, unknown type" Q
 .. I BCHT'="99CHRHAC",BCHT'="99CHRSVC" S BCHERR=1,BCHERR("ERROR")="obr table definition not HAC OR SVC" Q
 .. I BCHT="99CHRHAC" D PROBLK Q:BCHERR
 .. I BCHT="99CHRSVC" D SRVLK Q:BCHERR
 .. S BCHMIN=BHL("OBR",BCHC,20) I BCHMIN="" S BCHMIN=1
 .. S BCHSUBST=$G(BHL("OBR",BCHC,21)) I BCHSUBST]"","YN"'[BCHSUBST S BCHSUBST=""
 .. I BCHT="99CHRSVC" S BCHNARR=$G(BHL("OBX",BCHC,BCHX,5)) I BCHNARR="" S BCHNARR=$P(^BCHTPROB(BCHPROB,0),U)_": "_$P(^BCHTSERV(BCHSRV,0),"^",1)
 . S BCHPOVC=BCHPOVC+1
 . S BCHPOVS(BCHPOVC)=BCHPROB_"^"_BCHSRV_"^"_BCHMIN_"^"_BCHNARR_"^"_BCHSUBST
 ;now get other stuff
 ;
 Q:BCHERR
 S BCHTRAV=$G(BHL("ZV1",1,23)) I BCHTRAV="" S BCHTRAV=0
 S BCHREFT="",X=$G(BHL("ZHR",1,4)) I X]"" S X=$O(^BCHTREF("D",X,0)) S:X BCHREFT=X I X="" S BCHERR=1,BCHERR("ERROR")="Invalid Referred to code passed" Q
 S BCHREFF="",X=$G(BHL("ZHR",1,5)) I X]"" S X=$O(^BCHTREF("D",X,0)) S:X BCHREFF=X I X="" S BCHERR=1,BCHERR("ERROR")="Invalid Referred from code passed" Q
 S BCHNS=$G(BHL("ZHR",1,7)) I BCHNS="" S BCHNS=0  ;number served
 S BCHEVAL=$G(BHL("ZHR",1,6)) I BCHEVAL]"",BCHEVAL'="UI",BCHEVAL'="CI",BCHEVAL'="FI",BCHEVAL'="PR" S BCHEVAL=""
 S BCHACT=$G(BHL("ZHR",1,9)) I BCHACT="" S BCHACT="A"
 S BCHUID=$G(BHL("ZHR",1,8))
 S BCHTEMPR=$G(BHL("PID",1,11)) S BCHTEMPR=$E(BCHTEMPR,1,30)
 Q
MEAS ;
 K BCHMEAS
 S BCHMEAS=0
 S BCHX=0 F  S BCHX=$O(BHL("OBX",BCHC,BCHX)) Q:BCHX'=+BCHX!(BCHERR)  D
 . S BCHVAL=$G(BHL("OBX",BCHC,BCHX,3))
 . S BCHVAL=$P(BCHVAL,"^",1)
 . S BCHMFIEL=$O(^BCHTMT("B",BCHVAL,0))
 . I BCHMFIEL="" S BCHERR=1,BCHERR("ERROR")="Error in measurement/test type "_BCHVAL Q
 . S BCHMFIEL=$P(^BCHTMT(BCHMFIEL,0),U,3) I BCHMFIEL="" S BCHERR=1,BCHERR("ERROR")="Error in measurement type field number" Q
 . S BCHMRES=$G(BHL("OBX",BCHC,BCHX,5))
 . I BCHVAL="VU"!(BCHVAL="VC") S BCHMRES=$P($P(BCHMRES,"~"),"/",2)_"/"_$P($P(BCHMRES,"~",2),"/",2)
 . K BCHZ D CHK^DIE(90002,BCHMFIEL,"E",BCHMRES,.BCHZ)
 . I BCHZ="^" S BCHERR=1,BCHERR("ERROR")="Invalid measurement/test value passed "_BCHVAL_" - "_BCHMRES Q
 . S BCHMEAS=BCHMEAS+1,BCHMEAS(BCHMEAS)=BCHVAL_"^"_BCHMRES_"^"_BCHMFIEL
 . Q
 Q
PROBLK ;
 S X=$P(BCHVAL,"^",1)
 S Y=$O(^BCHTPROB("C",X,0))
 I Y="" S BCHERR=1,BCHERR("ERROR")="Invalid problem code passed "_X Q
 S BCHPROB=Y
 Q
SRVLK ;
 S X=$P(BCHVAL,"^",1)
 S Y=$O(^BCHTSERV("D",X,0))
 I Y="" S BCHERR=1,BCHERR("ERROR")="Invalid service code passed "_X Q
 S BCHSRV=Y
 Q
ERRF ;
 ;;1101;;S X=$G(BHL("OBR",1,7))
 ;;1102;;S X=$G(BHL("ZHR",1,2))
 ;;1103;;S X=$P($G(BHL("OBR",1,32)),U,2)
 ;;1104;;S X=$P($G(BHL("PID",1,5)),U,1)_","_$P($G(BHL("PID",1,5)),U,2)
 ;;1105;;S X=$TR($G(BHL("PID",1,3)),U,"~")
 ;;1106;;S X=$G(BHL("PID",1,8))
 ;;1107;;S X=$G(BHL("PID",1,9))
 ;;1108;;S X=$TR($G(BHL("ZP2",1,15)),"^","~")
 ;;1109;;S X=$TR($G(BHL("ZHR",1,2)),"^","~")
 ;;1110;;S X=$TR($G(BHL("PID",1,19)),"^","~")
 ;;1111;;S X=$TR($G(BHL("ZHR",1,3)),"^","~")
 ;;1301;;S X=$TR($G(BHL("ZHR",1,32)),"^","~")
 ;;
