AUM141 ;IHS/OIT/NKD - ICD 9 UPDATE FY2014 08/20/2013 ;
 ;;14.0;TABLE MAINTENANCE;;AUG 20,2013;Build 1
 ;
 Q
UPDATE ; EP - MAIN DRIVER
 N YEAR,ROOT
 F YEAR=2014  D
 . S ROOT="^ICD9("
 . D UPDDX(YEAR)
 . S ROOT="^ICD0("
 . D UPDPX(YEAR)
 Q
UPDDX(YEAR) ; ICD9 DIAGNOSIS FILE DRIVER
 N TYPE,ICDCNT
 F TYPE="REV"  D
 . D RSLT^AUM14EN("ICD 9 DIAGNOSIS, "_YEAR_" "_$S(TYPE="NEW":TYPE,TYPE="REV":"REVISED",TYPE="INA":"INACTIVATED",1:"")_" CODES:",1)
 . D RSLT^AUM14EN($J("",4)_"CODE"_$J("",6)_"DIAGNOSIS"_$J("",18)_"NEW"_$J("",1)_"SHORT"_$J("",1)_"LONG"_$J("",1)_"SEX"_$J("",1)_"AGE"_$J("",1)_"CC")
 . D RSLT^AUM14EN($J("",4)_"----"_$J("",6)_"---------"_$J("",18)_"---"_$J("",1)_"-----"_$J("",1)_"----"_$J("",1)_"---"_$J("",1)_"---"_$J("",1)_"--")
 . S ICDCNT=0 F  S ICDCNT=$O(^AUMDATA(ICDCNT)) Q:'ICDCNT  D
 . . Q:$P(^AUMDATA(ICDCNT,0),U,2)'=(TYPE_"DX")
 . . Q:$P(^AUMDATA(ICDCNT,0),U,3)'=YEAR
 . . D DXUPD($P(^AUMDATA(ICDCNT,0),U,3,9),TYPE)
 Q
DXUPD(AUMDATA,TYPE) ; ICD9 DIAGNOSIS FILE UPDATE
 N ICDIEN,CNT,FDA,NEWIEN,ERR,ICDRES,ICDMOD
 N ICDYR,ICDCOD,ICDDX,ICDDES,ICDSEX,ICDAGE,ICDRNG,ICDCC,ICDMDRG,ICDMDC,ICDDRG,ICDPYR
 S (ICDMOD,ICDRNG,ICDMDC,ICDDRG)=""
 S ICDYR=$P(AUMDATA,U,1),ICDYR=$E(ICDYR,3,4)+299,ICDYR=ICDYR_"1001"
 S ICDCOD=$P(AUMDATA,U,2)
 S ICDDX=$P(AUMDATA,U,3)
 S ICDDES=$P(AUMDATA,U,4)
 S ICDSEX=$P($P(AUMDATA,U,5),"~",1)
 S ICDAGE=$P($P(AUMDATA,U,5),"~",2)
 S ICDCC=$P(AUMDATA,U,6)
 S ICDMDRG=$P(AUMDATA,U,7)
 ;
 S ICDIEN=$O(@(ROOT_"""BA"","""_ICDCOD_" "","""")"),-1)
 S:('ICDIEN&(ICDCOD'[".")) ICDCOD=ICDCOD_"."
 S ICDIEN=$O(@(ROOT_"""BA"","""_ICDCOD_" "","""")"),-1)
 ;
 I TYPE'="INA",'ICDIEN D
 . K FDA,NEWIEN,ERR
 . S FDA(80,"+1,",.01)=ICDCOD ; Code Number (.01)
 . S FDA(80,"+1,",3)=ICDDX ; Diagnosis (3)
 . D UPDATE^DIE(,"FDA","NEWIEN","ERR")
 . I $D(ERR) D RSLT^AUM14EN("ERROR:  Lookup/Add of CODE '"_ICDCOD_"' FAILED.") Q
 . E  S ICDMOD=ICDMOD_"N"_$J("",3)
 . S ICDIEN=NEWIEN(1)
 Q:'ICDIEN
 I $L(ICDMOD)<1 S ICDMOD=" "_$J("",3)
 ; MDC EXTRACTOR
 F CNT=1:1:$L(ICDMDRG,"~") S ICDMDC=ICDMDC_$S(CNT>1:"^",1:"")_$P($P(ICDMDRG,"~",CNT),"-",1)
 F CNT=1:1:$L(ICDMDRG,"~") S ICDDRG=ICDDRG_$S(CNT>1:"^",1:"")_$TR($P($P(ICDMDRG,"~",CNT),"-",2),",","^")
 ; AGE RANGE EXTRACTOR
 I $L(ICDAGE)>0 D
 . S ICDRNG=$$GETRNG(ICDAGE)
 . I $L(ICDRNG)<1 D RSLT^AUM14EN("ERROR:  Incorrect Age Range")
 ; STORE PREVIOUS ACTIVATION DATE
 S ICDPYR=$$GET1^DIQ(80,ICDIEN,16,"I")
 ;
 K FDA
 I TYPE'="INA" D
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80,ICDIEN,3,"I")'=ICDDX:"S",1:" ")_$J("",5)
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80,ICDIEN,10,"I")'=ICDDES:"L",1:" ")_$J("",4)
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80,ICDIEN,9.5,"I")'=ICDSEX:"X",1:" ")_$J("",3)
 . S ICDMOD=ICDMOD_$S(($$GET1^DIQ(80,ICDIEN,14,"I")_$$GET1^DIQ(80,ICDIEN,15,"I"))'=($P(ICDRNG,"^",2)_$P(ICDRNG,"^",3)):"A",1:" ")_$J("",3)
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80,ICDIEN,70,"I")'=$S(ICDCC["CC":1,1:""):"C",1:" ")
 . S FDA(80,ICDIEN_",",.01)=ICDCOD ; Code Number (.01)
 . S:ICDDX]"" FDA(80,ICDIEN_",",3)=ICDDX ; Diagnosis (3)
 . S:ICDMDC]"" FDA(80,ICDIEN_",",5)=$P(ICDMDC,"^",1) ; Major Diagnostic Category (5)
 . S FDA(80,ICDIEN_",",9.5)=$S(ICDSEX]"":ICDSEX,1:"@") ; Sex (9.5)
 . S:ICDDES]"" FDA(80,ICDIEN_",",10)=ICDDES ; Description (10)
 . S:'ICDPYR FDA(80,ICDIEN_",",16)=ICDYR ; Activation Date (16)
 . S:$P(ICDDRG,"^",1)]"" FDA(80,ICDIEN_",",60)=$P(ICDDRG,"^",1) ; DRGa (60)
 . S:$P(ICDDRG,"^",2)]"" FDA(80,ICDIEN_",",61)=$P(ICDDRG,"^",2) ; DRGb (61)
 . S:$P(ICDDRG,"^",3)]"" FDA(80,ICDIEN_",",62)=$P(ICDDRG,"^",3) ; DRGc (62)
 . S:$P(ICDDRG,"^",4)]"" FDA(80,ICDIEN_",",63)=$P(ICDDRG,"^",4) ; DRGd (63)
 . S:$P(ICDDRG,"^",5)]"" FDA(80,ICDIEN_",",64)=$P(ICDDRG,"^",5) ; DRGe (64)
 . S:$P(ICDDRG,"^",6)]"" FDA(80,ICDIEN_",",65)=$P(ICDDRG,"^",6) ; DRGf (65)
 . S FDA(80,ICDIEN_",",14)=$S($P(ICDRNG,"^",2)]"":$P(ICDRNG,"^",2),1:"@") ; Age Low (14)
 . S FDA(80,ICDIEN_",",15)=$S($P(ICDRNG,"^",3)]"":$P(ICDRNG,"^",3),1:"@") ; Age High (15)
 . S FDA(80,ICDIEN_",",9999999.01)=$S($P(ICDRNG,"^",2)]"":$P(ICDRNG,"^",2),1:"@") ; Lower Age (9999999.01)
 . S FDA(80,ICDIEN_",",9999999.02)=$S($P(ICDRNG,"^",3)]"":$P(ICDRNG,"^",3),1:"@") ; Upper Age (9999999.02)
 . S FDA(80,ICDIEN_",",70)=$S(ICDCC["CC":1,1:"@") ; Complication/Comorbidity (70)
 . S FDA(80,ICDIEN_",",100)="@" ; Inactive Flag (100)
 . S FDA(80,ICDIEN_",",102)="@" ; Inactive Date (102)
 . S FDA(80,ICDIEN_",",2100000)=ICDYR ; Date Last Update (2100000)
 . S:ICDMOD["N" FDA(80,ICDIEN_",",9999999.04)=ICDYR ; Date Added (9999999.04)
 E  D
 . S FDA(80,ICDIEN_",",100)=1 ; Inactive Flag (100)
 . S FDA(80,ICDIEN_",",102)=ICDYR ; Inactive Date (102)
 . S FDA(80,ICDIEN_",",2100000)=ICDYR ; Date Last Update (2100000)
 D UPDATE^DIE(,"FDA",)
 ; Effective Date (Versioned) (66)
 K FDA
 S FDA(80.066,"?+1,"_ICDIEN_",",.01)=ICDYR ; Effective Date (.01)
 S FDA(80.066,"?+1,"_ICDIEN_",",.02)=$S(TYPE="INA":0,1:1) ; Status (.02)
 D UPDATE^DIE(,"FDA",)
 ; Diagnosis (Versioned) (67)
 K FDA
 I TYPE'="INA" D
 . S FDA(80.067,"?+1,"_ICDIEN_",",.01)=ICDYR ; Version Date (.01)
 . S FDA(80.067,"?+1,"_ICDIEN_",",1)=$S(ICDDX]"":ICDDX,1:"@") ; Diagnosis (Versioned) (1)
 . D UPDATE^DIE(,"FDA",)
 ; Description (Versioned) (68)
 K FDA
 I TYPE'="INA" D
 . S FDA(80.068,"?+1,"_ICDIEN_",",.01)=ICDYR ; Version Date (.01)
 . S FDA(80.068,"?+1,"_ICDIEN_",",1)=$S(ICDDES]"":ICDDES,1:"@") ; Description (Versioned) (1)
 . D UPDATE^DIE(,"FDA",)
 ; DRG Grouper Effective Date (Versioned) (71)
 K FDA,NEWIEN
 I TYPE'="INA",ICDDRG]"" D
 . S FDA(80.071,"?+1,"_ICDIEN_",",.01)=ICDYR ; DRG Grouper Effective Date (.01)
 . D UPDATE^DIE(,"FDA","NEWIEN")
 . I $D(NEWIEN) D
 . . ; Remove previous DRGs
 . . K ICDRES
 . . D GETS^DIQ(80.071,NEWIEN(1)_","_ICDIEN,"1*","","ICDRES")
 . . S CNT=0 F  S CNT=$O(ICDRES(80.711,CNT)) Q:'CNT  D
 . . . S ICDRES(80.711,CNT,.01)="@"
 . . D UPDATE^DIE(,"ICDRES",)
 . . ; Add new DRGs
 . . F CNT=1:1:$L(ICDDRG,"^") S FDA(80.711,"+"_CNT_","_NEWIEN(1)_","_ICDIEN_",",.01)=$P(ICDDRG,"^",CNT)
 . . D UPDATE^DIE(,"FDA",)
 ; MDC Effective Date (Versioned) (72)
 K FDA
 I TYPE'="INA",ICDMDC]"" D
 . S FDA(80.072,"?+1,"_ICDIEN_",",.01)=ICDYR ; MDC Effective Date (.01)
 . S FDA(80.072,"?+1,"_ICDIEN_",",1)=$S(ICDMDC]"":$P(ICDMDC,"^",1),1:"@") ; MDC (1)
 . D UPDATE^DIE(,"FDA",)
 ; Versioned CC (Versioned) (103)
 K FDA
 I TYPE'="INA",ICDCC]"" D
 . S FDA(80.0103,"?+1,"_ICDIEN_",",.01)=ICDYR ; Effective Date (.01)
 . S FDA(80.0103,"?+1,"_ICDIEN_",",1)=$S(ICDCC="N":0,ICDCC="CC":1,ICDCC="MCC":2,1:"@") ; Complication/Comorbidity (1)
 . D UPDATE^DIE(,"FDA",)
 ; Restore Activation Date (16)
 K FDA
 I TYPE'="INA",ICDPYR'=$$GET1^DIQ(80,ICDIEN,16,"I") D
 . S FDA(80,ICDIEN_",",16)=ICDPYR ; Activation Date (16)
 . D UPDATE^DIE(,"FDA",)
 ;
 S:ICDMOD["N" ICDMOD="N"
 I ICDMOD'=$J("",24) D RSLT^AUM14EN($J("",4)_ICDCOD_$J("",10-$L(ICDCOD))_$E(ICDDX,1,24)_$J("",27-$L($E(ICDDX,1,24)))_ICDMOD)
 ;
 Q
UPDPX(YEAR) ;ICD9 OPERATION/PROCEDURE FILE DRIVER
 N TYPE,ICDCNT
 F TYPE="REV"  D
 . D RSLT^AUM14EN("ICD 9 OPERATION/PROCEDURE, "_YEAR_" "_$S(TYPE="NEW":TYPE,TYPE="REV":"REVISED",TYPE="INA":"INACTIVATED",1:"")_" CODES:",1)
 . D RSLT^AUM14EN($J("",4)_"CODE"_$J("",6)_"DESCRIPTION"_$J("",16)_"NEW"_$J("",1)_"SHORT"_$J("",1)_"LONG"_$J("",1)_"SEX")
 . D RSLT^AUM14EN($J("",4)_"----"_$J("",6)_"-----------"_$J("",16)_"---"_$J("",1)_"-----"_$J("",1)_"----"_$J("",1)_"---")
 . S ICDCNT=0 F  S ICDCNT=$O(^AUMDATA(ICDCNT)) Q:'ICDCNT  D
 . . Q:$P(^AUMDATA(ICDCNT,0),U,2)'=(TYPE_"PX")
 . . Q:$P(^AUMDATA(ICDCNT,0),U,3)'=YEAR
 . . D PXUPD($P(^AUMDATA(ICDCNT,0),U,3,9),TYPE)
 Q
PXUPD(AUMDATA,TYPE) ;ICD9 OPERATION/PROCEDURE FILE UPDATE
 N ICDIEN,CNT,CNT2,FDA,FDAIEN,NEWIEN,ERR,ICDRES,ICDTMP,ICDMOD
 N ICDYR,ICDCOD,ICDPX,ICDDES,ICDSEX,ICDMDRG,ICDMDC,ICDDRG,ICDPYR
 S ICDMOD=""
 S ICDYR=$P(AUMDATA,U,1),ICDYR=$E(ICDYR,3,4)+299,ICDYR=ICDYR_"1001"
 S ICDCOD=$P(AUMDATA,U,2)
 S ICDPX=$P(AUMDATA,U,3)
 S ICDDES=$P(AUMDATA,U,4)
 S ICDSEX=$P(AUMDATA,U,5)
 S ICDMDRG=$P(AUMDATA,U,7)
 ;
 S ICDIEN=$O(@(ROOT_"""BA"","""_ICDCOD_" "","""")"),-1)
 ;
 I TYPE'="INA",'ICDIEN D
 . K FDA,NEWIEN,ERR
 . S FDA(80.1,"+1,",.01)=ICDCOD ; Code Number (.01)
 . S FDA(80.1,"+1,",4)=ICDPX ; Operation/Procedure (4)
 . D UPDATE^DIE(,"FDA","NEWIEN","ERR")
 . I $D(ERR) D RSLT^AUM14EN("ERROR:  Lookup/Add of CODE '"_ICDCOD_"' FAILED.") Q
 . E  S ICDMOD=ICDMOD_"N"_$J("",3)
 . S ICDIEN=NEWIEN(1)
 Q:'ICDIEN
 I $L(ICDMOD)<1 S ICDMOD=" "_$J("",3)
 ; STORE PREVIOUS ACTIVATION DATE
 S ICDPYR=$$GET1^DIQ(80.1,ICDIEN,12,"I")
 ;
 K FDA
 I TYPE'="INA" D
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80.1,ICDIEN,4,"I")'=ICDPX:"S",1:" ")_$J("",5)
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80.1,ICDIEN,10,"I")'=ICDDES:"L",1:" ")_$J("",4)
 . S ICDMOD=ICDMOD_$S($$GET1^DIQ(80.1,ICDIEN,9.5,"I")'=ICDSEX:"X",1:" ")
 . S FDA(80.1,ICDIEN_",",.01)=ICDCOD ; Code Number (.01)
 . S:ICDPX]"" FDA(80.1,ICDIEN_",",4)=ICDPX ; Operation/Procedure (4)
 . S FDA(80.1,ICDIEN_",",9.5)=$S(ICDSEX]"":ICDSEX,1:"@") ; Sex (9.5)
 . S:ICDDES]"" FDA(80.1,ICDIEN_",",10)=ICDDES ; Description (10)
 . S:'ICDPYR FDA(80.1,ICDIEN_",",12)=ICDYR ; Activation Date (12)
 . S FDA(80.1,ICDIEN_",",100)="@" ; Inactive Flag (100)
 . S FDA(80.1,ICDIEN_",",102)="@" ; Inactive Date (102)
 . S FDA(80.1,ICDIEN_",",2100000)=ICDYR ; Date Last Update (2100000)
 . S:ICDMOD["N" FDA(80.1,ICDIEN_",",9999999.04)=ICDYR ; Date Added (9999999.04)
 E  D
 . S FDA(80.1,ICDIEN_",",100)=1 ; Inactive Flag (100)
 . S FDA(80.1,ICDIEN_",",102)=ICDYR ; Inactive Date (102)
 . S FDA(80.1,ICDIEN_",",2100000)=ICDYR ; Date Last Update (2100000)
 D UPDATE^DIE(,"FDA",)
 ; Major Diagnostic Category (7)
 K FDA,FDAIEN,ICDRES
 I TYPE'="INA",ICDMDRG]"" D
 . ; Remove previous MDCs
 . K ICDRES
 . D GETS^DIQ(80.1,ICDIEN_",","7*","","ICDRES")
 . S CNT=0 F  S CNT=$O(ICDRES(80.12,CNT)) Q:'CNT  D
 . . S ICDRES(80.12,CNT,.01)="@"
 . D UPDATE^DIE(,"ICDRES",)
 . K FDA,FDAIEN
 . F CNT=1:1:$L(ICDMDRG,"~") S ICDTMP=$P(ICDMDRG,"~",CNT) Q:'ICDTMP  D
 . . S ICDMDC=$P(ICDTMP,"-",1)
 . . S ICDDRG=$P(ICDTMP,"-",2)
 . . S FDA(80.12,"+"_CNT_","_ICDIEN_",",.01)=ICDMDC
 . . S FDAIEN(CNT)=+ICDMDC
 . . F CNT2=1:1:$S($L(ICDDRG,",")<7:$L(ICDDRG,","),1:6) S FDA(80.12,"+"_CNT_","_ICDIEN_",",CNT2)=$P(ICDDRG,",",CNT2)
 . . D UPDATE^DIE(,"FDA","FDAIEN")
 ; Effective Date (Versioned) (66)
 K FDA
 S FDA(80.166,"?+1,"_ICDIEN_",",.01)=ICDYR ; Effective Date (.01)
 S FDA(80.166,"?+1,"_ICDIEN_",",.02)=$S(TYPE="INA":0,1:1) ; Status (.02)
 D UPDATE^DIE(,"FDA",)
 ; Operation/Proc (Versioned) (67)
 K FDA
 I TYPE'="INA" D
 . S FDA(80.167,"?+1,"_ICDIEN_",",.01)=ICDYR ; Version Date (.01)
 . S FDA(80.167,"?+1,"_ICDIEN_",",1)=$S(ICDPX]"":ICDPX,1:"@") ; Operation/Proc (Versioned) (1)
 . D UPDATE^DIE(,"FDA",)
 ; Description (Versioned) (68)
 K FDA
 I TYPE'="INA" D
 . S FDA(80.168,"?+1,"_ICDIEN_",",.01)=ICDYR ; Version Date (.01)
 . S FDA(80.168,"?+1,"_ICDIEN_",",1)=$S(ICDDES]"":ICDDES,1:"@") ; Description (Versioned) (1)
 . D UPDATE^DIE(,"FDA",)
 ; DRG Grouper Effective Date (Versioned) (71)
 K FDA,NEWIEN
 I TYPE'="INA",ICDMDRG]"" D
 . S FDA(80.171,"?+1,"_ICDIEN_",",.01)=ICDYR ; DRG Grouper Effective Date (.01)
 . D UPDATE^DIE(,"FDA","NEWIEN")
 . I $D(NEWIEN) D
 . . ; Remove previous MDCs
 . . K ICDRES
 . . D GETS^DIQ(80.171,NEWIEN(1)_","_ICDIEN,"1*","","ICDRES")
 . . S CNT=0 F  S CNT=$O(ICDRES(80.1711,CNT)) Q:'CNT  D
 . . . S ICDRES(80.1711,CNT,.01)="@"
 . . D UPDATE^DIE(,"ICDRES",)
 . . ; Add new MDCs
 . . F CNT=1:1:$L(ICDMDRG,"~") S ICDTMP=$P(ICDMDRG,"~",CNT) Q:'ICDTMP  D
 . . . K FDA
 . . . S ICDMDC=$P(ICDTMP,"-",1)
 . . . S ICDDRG=$P(ICDTMP,"-",2)
 . . . S FDA(80.1711,"+1,"_NEWIEN(1)_","_ICDIEN_",",.01)=ICDMDC
 . . . F CNT2=1:1:$L(ICDDRG,",") S FDA(80.17111,"+"_(CNT2+1)_",+1,"_NEWIEN(1)_","_ICDIEN_",",.01)=$P(ICDDRG,",",CNT2)
 . . . D UPDATE^DIE(,"FDA",)
 ; Restore Activation Date (12)
 K FDA
 I TYPE'="INA",ICDPYR'=$$GET1^DIQ(80.1,ICDIEN,12,"I") D
 . S FDA(80.1,ICDIEN_",",12)=ICDPYR ; Activation Date (12)
 . D UPDATE^DIE(,"FDA",)
 ;
 S:ICDMOD["N" ICDMOD="N"
 I ICDMOD'=$J("",16) D RSLT^AUM14EN($J("",4)_ICDCOD_$J("",10-$L(ICDCOD))_$E(ICDPX,1,24)_$J("",27-$L($E(ICDPX,1,24)))_ICDMOD)
 ;
 Q
REMVER(FILE,IEN,YEAR) ; REMOVE VERSIONED DATA MORE RECENT THAN UPDATE DATE
 N RES,CNT,FDA,TMP
 D LIST^DIC(FILE,","_IEN_",","@;.01","IP",,,,,,,"RES")
 S CNT=0 F  S CNT=$O(RES("DILIST",CNT)) Q:'CNT  D
 . S TMP=RES("DILIST",CNT,0)
 . I $P(TMP,"^",2)>YEAR D
 . . K FDA
 . . S FDA(FILE,$P(TMP,"^",1)_","_IEN_",",.01)="@"
 . . D UPDATE^DIE(,"FDA",)
 Q
GETRNG(AGE) ; RETURN DELIMITED AGE RANGE
 N CNT,TEXT,RES
 F CNT=1:1 S TEXT=$P($T(AGES+CNT),";;",2) Q:TEXT="END"  I $P(TEXT,"^",1)=AGE S RES=TEXT
 Q:$D(RES) RES
 Q ""
 ;
 ;AGE RANGES
 ;Medicare Age Category^Age Low^Age High
AGES ;;
 ;;NEWBORN^0^365
 ;;PEDIATRIC^0^6209
 ;;MATERNITY^4383^20088
 ;;ADULT^5478^45291
 ;;END
