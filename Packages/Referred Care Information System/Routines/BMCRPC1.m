BMCRPC1 ; IHS/CAS/AU - GUI REFERRED CARE INFO SYSTEM (1/4);     
 ;;4.0;REFERRED CARE INFO SYSTEM;**7,8**;JAN 09, 2006;Build 51
 ;
 ;
 ; RPC code for RCIS GUI Application
 ; Routines contains code for Reading data from RCIS files
SRCHREF(RSLT,PATIENT,REFPRVDR,STRTDATE,ENDDATE,RECNMBR,STATUS) ; search referral w.r.t patient, referring provider and date range
 ;; PATIENT = DFN
 ;  REFPRVDR = Provider Ien
 ; STRTDATE = start date ,  ENDDATE = end date ,  search referrels between start and end date
 ; NMBRREC   = Number of recrods to return
 ;S RSLT="Test Referaal Data" Q
 ;S ^TMP("FAR234")=$G(PATIENT)_"^"_$G(REFPRVDR)_"^"_$G(STRTDATE)_"^"_$G(ENDDATE)_"^"_$G(RECNMBR)_"^"_$G(STATUS)
 ;S PATIENT=""
 ;S STRTDATE="8/14/2012"
 ;S ENDDATE="8/14/2013"
 ;S REFPRVDR="3043"
 ;S STATUS="Active"
 ;D SRCHREF^BMCRPC1(.R,PATIENT,REFPRVDR,STRTDATE,ENDDATE,"",STATUS) ZW @R
 ;S DI="S X=$P($G("_"^"_"(0)),U,2) D LIST^DIC(8992.5,,""@;.01;.02IE;.03IE;.04;.05;.06;.09;1"",""IP"",1,X-1,X,""#"",,,""OUT1""_@X) D EN^DDIOL($G(OUT1_@X(""DILIST"",1,0)))"
 N OUT,ERR,SCR
 S SCR="I 1"
 I ($D(STATUS)&($G(STATUS)'="")) D
 . I $G(STATUS)="Active" S STATUS="A"
 . I $G(STATUS)="Approved" S STATUS="A1"
 . I $G(STATUS)="Closed-Completed" S STATUS="C1"
 . I $G(STATUS)="Closed-Not Completed" S STATUS="X"
 K ^TMP($J,"PRNRCTMP")
 I +RECNMBR'>0 S RECNMBR="*"
 I ($D(PATIENT)&(PATIENT'="")) S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",3))="_PATIENT_")" ;D EN^DDIOL($G(OUT1("DILIST",1,0)))
 I ($D(REFPRVDR)&(REFPRVDR'="")) S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",6))="_REFPRVDR_")"
 I ($D(STATUS)&($G(STATUS)'="")) D
 . I $G(STATUS)'="Active/Approved" D
 . . S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",15))="""_$G(STATUS)_""")"
 . I $G(STATUS)="Active/Approved" D
 . . S SCR=SCR_" & ((($P($G("_"^"_"(0)),""^"",15))=""A"") ! (($P($G("_"^"_"(0)),""^"",15))=""A1""))"
 I ($D(STRTDATE)&(STRTDATE'="")) D DT^DILF("TS",STRTDATE,.STRTDATE,,"") S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))>="_STRTDATE_")"
 I ($D(ENDDATE)&(ENDDATE'="")) D DT^DILF("TS",ENDDATE,.ENDDATE,,"") S SCR=SCR_" & (($P($G("_"^"_"(0)),""^"",1))<="_ENDDATE_")"
 I ($D(PATIENT)&(PATIENT'="")) D LIST^DIC(90001,"","@;.01;.02;101;.03IE;.05I;.06;.0999;1105;1112;1201;1114;1301;.15;1306;1307;1308","BQ",RECNMBR,,PATIENT,"D",SCR,"","^TMP($J,""PRNRCTMP"")") D CRTMSG^BMCRPC4(.RSLT,0) Q RSLT
 I ($D(REFPRVDR)&(REFPRVDR'="")) D LIST^DIC(90001,"","@;.01;.02;101;.03IE;.05I;.06;.0999;1105;1112;1201;1114;1301;.15;1306;1307;1308","BQ",RECNMBR,,REFPRVDR,"E",SCR,"","^TMP($J,""PRNRCTMP"")") D CRTMSG^BMCRPC4(.RSLT,0) Q RSLT
 I ($D(STRTDATE)&(STRTDATE'="")) D
 .I ($D(ENDDATE)&(ENDDATE'="")) D LIST^DIC(90001,"","@;.01;.02;101;.03IE;.05I;.06;.0999;1105;1112;1201;1114;1301;.15;1306;1307;1308","",RECNMBR,,,"B",SCR,"","^TMP($J,""PRNRCTMP"")") D CRTMSG^BMCRPC4(.RSLT,0) Q
 Q RSLT
GTRFBYID(RSLT,REFIEN) ;; get referral
 ;; D GTRFBYID^BMCRPC1(.R,"113251") ZW @R
 ;; RSLT = result set returned as golbal array
 ;; REFIEN = referral ien of RCIS REFERRAL file
 ;; D GTRFBYID^BMCRPC1(.R,"113252") ZW @R
 N SCR,REFNUM,CMNTSX,CMNTSB,PRIMREF,FIELDS
 I '$D(REFIEN) Q
 I REFIEN="" Q
 I $$GET1^DIQ(90001,REFIEN_",",.01,"")="" S RSLT="Not a valid Referral Ien" Q RSLT
 LOCK +^BMCREF(REFIEN):0.2 ;;check if record is being locked else where
 ELSE  S RSLT="The referral record cannot be opened becuase it is locked. Please try again later." Q RSLT
 S SCR="I Y="_REFIEN
 K ^TMP($J,"PRNRCTMP"),^TMP($J,"PRNRC")
 S REFNUM=$$GET1^DIQ(90001,REFIEN_",",.02,"") ;;get Ref Number... to use index in search... fast fetch
 S PRIMREF=$$GET1^DIQ(90001,REFIEN_",",102,"") ;;get primary referral  - if exsits; fetch Med Hx for primary ref too
 S FIELDS="@;.01;.02;.06;.0999;.15;101;1105;1111;1112;1201;1114;1301;1302;401;402;403;404;405;406;407;408;409;410;411;412;.03IE;.04I;.05I;.12I;.13I;.14I;.07I;.08I;.09I;.23I;.32;1306;1307;1308"
 D LIST^DIC(90001,"",FIELDS,"Q","1",,REFNUM,"C",SCR,"","^TMP($J,""PRNRCTMP"")")
 LOCK -^BMCREF(REFIEN) ;; unlock the record
 D CRTMSG^BMCRPC4(.RSLT,1) ;;package data to be returned
 ;; fetch MED HX comments for the Referral
 ;S CMNTSX=$$GETMEDHX("",REFIEN,"M")
 ;S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSX,1,$L(CMNTSX)-4)
 ;; fetch Business Office/CHS comments for the Referral
 ;S CMNTSB=$$GETMEDHX("",REFIEN,"B")
 ;S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSB,1,$L(CMNTSB)-4)
 ;; fetch MED HX comments for the Primary referral too, if this is a secondary referral
 ;I PRIMREF>0 S CMNTSX=$$GETMEDHX("",PRIMREF,"M") S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSX,1,$L(CMNTSX)-4)
  ;; fetch Business Office/CHS comments for the Primary referral too, if this is a secondary referral
 ;I PRIMREF>0 S CMNTSB=$$GETMEDHX("",PRIMREF,"B") S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSB,1,$L(CMNTSB)-4)
  ;; fetch MED HX comments for the Primary referral too, if this is a secondary referral
 I PRIMREF>0 D
 . S CMNTSX=$$GETMEDHX("",PRIMREF,"M")
 . I $G(CMNTSX)="~`M'~M" S CMNTSX=""
 . I $G(CMNTSX)'="~`M'~M" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSX,1,$L(CMNTSX)-4)
 ;; fetch MED HX comments for the Referral
 I $G(CMNTSX)'="" D
 . S CMNTSXX=$$GETMEDHX("",REFIEN,"M")
 . I $G(CMNTSXX)="~`M'~M" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)
 . I $G(CMNTSXX)'="~`M'~M" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSXX,3,$L(CMNTSXX)-4)
  ;; fetch Business Office/CHS comments for the Primary referral too, if this is a secondary referral
  I $G(CMNTSX)="" D
 . S CMNTSXX=$$GETMEDHX("",REFIEN,"M")
 . I $G(CMNTSXX)="~`M'~M" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$G(CMNTSXX)
 . I $G(CMNTSXX)'="~`M'~M" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSXX,1,$L(CMNTSXX)-4)
 I PRIMREF>0 D
 . S CMNTSB=$$GETMEDHX("",PRIMREF,"B")
 . I $G(CMNTSB)="~`B'~B" S CMNTSB=""
 . I $G(CMNTSB)'="~`B'~B" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSB,1,$L(CMNTSB)-4)
 ;; fetch Business Office/CHS comments for the Referral
 I $G(CMNTSB)'="" D
 . S CMNTSBB=$$GETMEDHX("",REFIEN,"B")
 . I $G(CMNTSBB)="~`B'~B" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)
 . I $G(CMNTSBB)'="~`B'~B" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSBB,3,$L(CMNTSBB)-4)
 I $G(CMNTSB)="" D
 . S CMNTSBB=$$GETMEDHX("",REFIEN,"B")
 . I $G(CMNTSBB)="~`B'~B" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$G(CMNTSBB)
 . I $G(CMNTSBB)'="~`B'~B" S ^TMP($J,"PRNRC",1)=^TMP($J,"PRNRC",1)_$E(CMNTSBB,1,$L(CMNTSBB)-4)
 ;
 S RSLT=$NA(^TMP($J,"PRNRC"))
 Q RSLT
GETMEDHX(RSLT,REFIEN,TYPE) ;; Get Medical History or Business Office/CHS notes for a referral
 ; D GETMEDHX^BMCRPC1(.R,"113251","M") W R
 N CMNTS,IND,ERR,INDEX,CMDATE,RFCMTIEN,REVIEWER,OUT,SCR,CMNTSX
 S RFCMTIEN="",REVIEWER="",CMDATE="",IND="",INDEX="",CMNTS="",CMNTSX="~`"_TYPE_"'~"_TYPE,ERR=""
 S SCR="I ((($P($G("_"^"_"(0)),""^"",5))="""_TYPE_""") & (($P($G(^(0)),""^"",3))="_REFIEN_"))" ;;fetch only MED HX comments, for the Primary Referral
 D LIST^DIC(90001.03,"","@;.01;.04","BQ","*",,REFIEN,"AD",SCR,"","OUT")
 ;S RFCMTIEN=$$FIND1^DIC(90001.03,"","BQX",REFIEN,"AD")
 S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S RFCMTIEN=$G(OUT("DILIST",2,INDEX))
 .S CMDATE=$G(OUT("DILIST","ID",INDEX,".01"))
 .S REVIEWER=$G(OUT("DILIST","ID",INDEX,".04"))
 .K WP N WP
 .I RFCMTIEN>0 D GET1^DIQ(90001.03,RFCMTIEN_",",1,,"WP")
 .S IND=$O(WP(IND))
 .I +IND>0 F  D  Q:(+IND'>0)
 ..S CMNTS=CMNTS_WP(IND)_"~"
 ..S IND=$O(WP(IND))
 .I CMNTS'="" S CMNTSX=CMNTSX_RFCMTIEN_"^"_CMDATE_"^"_REVIEWER_"^"_$E(CMNTS,1,$L(CMNTS)-1)_TYPE_"'~"_TYPE
 .S INDEX=$O(OUT("DILIST","ID",INDEX)),CMNTS=""
 S RSLT=CMNTSX
 Q RSLT
 ;
GETREFDT(RSLT) ;; get Reference data for Refferal i-e ICD/CPT Categories
 ; D GETREFDT^BMCRPC1(.R) ZW R
 K ^TMP($J)
 N OUT,OUT1,OUT2,OUT3,ICDIEN,ICDCAT,ICDACTDT,ICDINADT,CPTIEN,CPTCAT,PRPIEN,PRPTXT,I
 S ^TMP($J,"PRNRCRF",1)="~`" ;; RCIS ICD DIAGNOSTIC CATEGORY
 S ^TMP($J,"PRNRCRF",2)="~`" ;; RCIS CPT PROCEDURE CATEGORY
 S ^TMP($J,"PRNRCRF",3)="~`" ;; RCIS PURPOSE TEXT LIST
 S ^TMP($J,"PRNRCRF",4)="~`" ;; RCIS STATUS OF REFERRAL LIST
 D LIST^DIC(90001.51,"","@;.01","","*",,,"",,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S ICDIEN=$G(OUT("DILIST",2,INDEX))
 .S ICDCAT=$G(OUT("DILIST","ID",INDEX,".01"))
 .S ICDACTDT=$$GET1^DIQ(90001.51,$G(ICDIEN)_",",.02,"")
 .S ICDINADT=$$GET1^DIQ(90001.51,$G(ICDIEN)_",",.03,"")
 .S ^TMP($J,"PRNRCRF",1)=$G(^TMP($J,"PRNRCRF",1))_ICDIEN_"^"_ICDCAT_"^"_ICDACTDT_"^"_ICDINADT_"~"
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 D LIST^DIC(90001.52,"","@;.01","","*",,,"",,"","OUT1")
 S INDEX=$O(OUT1("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S CPTIEN=$G(OUT1("DILIST",2,INDEX))
 .S CPTCAT=$G(OUT1("DILIST","ID",INDEX,".01"))
 .S ^TMP($J,"PRNRCRF",2)=$G(^TMP($J,"PRNRCRF",2))_CPTIEN_"^"_CPTCAT_"~"
 .S INDEX=$O(OUT1("DILIST","ID",INDEX))
 D LIST^DIC(90001.58,"","@;.01","","*",,,"",,"","OUT2")
 S INDEX=$O(OUT2("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S PRPIEN=$G(OUT2("DILIST",2,INDEX))
 .S PRPTXT=$G(OUT2("DILIST","ID",INDEX,".01"))
 .S ^TMP($J,"PRNRCRF",3)=$G(^TMP($J,"PRNRCRF",3))_PRPIEN_"^"_PRPTXT_"~"
 .S INDEX=$O(OUT2("DILIST","ID",INDEX))
 S OUT3=$P($G(^DD(90001,.15,0)),"^",3)
 S PIECE=$P($G(OUT3),";"),I=1
 I PIECE'="" F  D  Q:(PIECE="")
 .S RSCODE=$P($G(PIECE),":",1)
 .S RSDESC=$P($G(PIECE),":",2)
 .S ^TMP($J,"PRNRCRF",4)=$G(^TMP($J,"PRNRCRF",4))_RSCODE_"^"_RSDESC_"~"
 .S I=I+1,PIECE=$P($G(OUT3),";",I)
 S RSLT=$NA(^TMP($J,"PRNRCRF"))
 Q RSLT
SRRFRDTO(RSLT,SRHSTRNG,REFTYPE) ;; Search Vendor ; Specific Provider ; Clinic Stop ; Location
 ;  search varies on Refferal type
 K ^TMP($J)
 I (('$D(REFTYPE))!('$D(SRHSTRNG))) S RSLT="Either search string or Referral Type is not present" Q RSLT
 I REFTYPE="C" D SRVNDR(.RSLT,SRHSTRNG) Q RSLT ;CHS
 I REFTYPE="I" D SRIHSFC(.RSLT,SRHSTRNG) Q RSLT ;IHS (ANOTHER FACILITY)
 I REFTYPE="O" D SROTPRV(.RSLT,SRHSTRNG) Q RSLT ;OTHER
 I REFTYPE="N" D SRCLNCST(.RSLT,SRHSTRNG) Q RSLT ;IN-HOUSE
 Q
SRVNDR(RSLT,VNRSTRNG) ;; search vendor from VENDOR file for type 'CHS' referrel
 N OUT,SCR,INDEX,VNDRIEN,VNDRNM,VNDRDUN,VNDREIN,EINSFX,MAILTO,REMITTO
 S SCR="I (($P($G("_"^"_"(0)),""^"",5)="""") ! ($P($G("_"^"_"(0)),""^"",5)>"_DT_"))"
 D LIST^DIC(9999999.11,"","@;.01;.07;1101;1102;1301;1302;1401;1402;1403","","*",,VNRSTRNG,"B",SCR,"","OUT")
  S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S VNDRIEN=$G(OUT("DILIST",2,INDEX))
 .S VNDRNM=$G(OUT("DILIST","ID",INDEX,".01"))
 .S VNDRDUN=$G(OUT("DILIST","ID",INDEX,".07"))
 .S VNDREIN=$G(OUT("DILIST","ID",INDEX,"1101"))
 .S EINSFX=$G(OUT("DILIST","ID",INDEX,"1102"))
 .S MAILTO=$G(OUT("DILIST","ID",INDEX,"1301"))_","_$G(OUT("DILIST","ID",INDEX,"1302"))
 .S REMITTO=$G(OUT("DILIST","ID",INDEX,"1401"))_","_$G(OUT("DILIST","ID",INDEX,"1402"))_","_$G(OUT("DILIST","ID",INDEX,"1403"))
 .S ^TMP($J,"PRNRCRVND",INDEX)="~`"_VNDRIEN_"^"_VNDRNM_"^"_VNDRDUN_"^"_VNDREIN_"^"_EINSFX_"^"_MAILTO_"^"_REMITTO
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 S RSLT=$NA(^TMP($J,"PRNRCRVND"))
 Q RSLT
SRIHSFC(RSLT,FCSTRNG) ;; search falicity from Location file for type 'IHS (ANOTHER FACILITY)' refferel
 N OUT,INDEX,FACIEN,NAME,AREA,SVCUNIT,CODE,INACTIVE,INACTDT
 D LIST^DIC(9999999.06,"","@;.01;.04;.05;.07;.27","","*",,FCSTRNG,"B",,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S FACIEN=$G(OUT("DILIST",2,INDEX))
 .S NAME=$G(OUT("DILIST","ID",INDEX,".01"))
 .S AREA=$G(OUT("DILIST","ID",INDEX,".04"))
 .S SVCUNIT=$G(OUT("DILIST","ID",INDEX,".05"))
 .S CODE=$G(OUT("DILIST","ID",INDEX,".07"))
 .S INACTIVE="" I ($G(OUT("DILIST","ID",INDEX,".27"))'="") S INACTDT=$G(OUT("DILIST","ID",INDEX,".27")) D DT^DILF("TS",INACTDT,.INACTDT,,"") I INACTDT<=DT S INACTIVE=1
 .S ^TMP($J,"PRNRCRVND",INDEX)="~`"_FACIEN_"^"_NAME_"^"_AREA_"^"_SVCUNIT_"^"_CODE_"^"_INACTIVE_"^"_""  ;; extra empty field to keep inline with return paramaters of RPC
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 S RSLT=$NA(^TMP($J,"PRNRCRVND"))
 Q RSLT
SROTPRV(RSLT,PRVSTRNG) ;; search provider from RCIS SPECIFIC PROVIDER file for type 'OTHER' referrels
 N OUT,INDEX,PRVIEN,NAME
 D LIST^DIC(90001.53,"","@;.01","","*",,PRVSTRNG,"B",,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S PRVIEN=$G(OUT("DILIST",2,INDEX))
 .S NAME=$G(OUT("DILIST","ID",INDEX,".01"))
 .S ^TMP($J,"PRNRCRVND",INDEX)="~`"_PRVIEN_"^"_NAME_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""  ;; extra empty field to keep inline with return paramaters of RPC
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 S RSLT=$NA(^TMP($J,"PRNRCRVND"))
 Q RSLT
SRCLNCST(RSLT,CLNSTRNG) ;; search from CLINIC STOP file for IN-HOUSE referrals
 N OUT,INDEX,CLNIEN,NAME,CODE
 D LIST^DIC(40.7,"","@;.01;1","","*",,CLNSTRNG,"B",,"","OUT")
 S INDEX=$O(OUT("DILIST","ID",0))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .S CLNIEN=$G(OUT("DILIST",2,INDEX))
 .S NAME=$G(OUT("DILIST","ID",INDEX,".01"))
 .S CODE=$G(OUT("DILIST","ID",INDEX,"1"))
 .S ^TMP($J,"PRNRCRVND",INDEX)="~`"_CLNIEN_"^"_NAME_"^"_CODE_"^"_""_"^"_""_"^"_""_"^"_""  ;; extra empty field to keep inline with return paramaters of RPC
 .S INDEX=$O(OUT("DILIST","ID",INDEX))
 S RSLT=$NA(^TMP($J,"PRNRCRVND"))
 Q RSLT
 ;
