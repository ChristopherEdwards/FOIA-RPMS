BEHOPTP1 ;MSC/IND/DKM - Patient List Management ;16-Feb-2008 10:02;DKM
 ;;1.1;BEH COMPONENTS;**004004**;Mar 20, 2007
 ;=================================================================
 ; Return list of patients with clinic appt w/in range
CLINPTS(DATA,LOC,START,END,MAX) ;EP
 I +$G(LOC)<1 S DATA(1)="^No clinic identified" Q
 I '$$ACTLOC^BEHOENCX(LOC) S DATA(1)="^Clinic is not active" Q
 N DFN,CNT,J,X,DAT,DATX,QUALS,VIEN,VSTR
 S MAX=$G(MAX,200),CNT=0
 D:START="" GETPAR^CIAVMRPC(.START,"ORLP DEFAULT CLINIC START DATE",,,"E")
 D:END="" GETPAR^CIAVMRPC(.END,"ORLP DEFAULT CLINIC STOP DATE",,,"E")
 D DT^DILF("T",START,.START,"","")
 D DT^DILF("T",END,.END,"","")
 I (START=-1)!(END=-1) S DATA(1)="^Error in date range." Q
 S END=END\1+.9,DAT=START,LOC=+LOC,DATX=$S(START\1=(END\1):"",1:" ")
 F  S DAT=$O(^SC(LOC,"S",DAT)),J=0 Q:'DAT!(DAT>END)  D:$L($G(^SC(LOC,"S",DAT,1,0)))  Q:CNT'<MAX
 .S:$L(DATX) DATX=" on "_$$ENTRY^CIAUDT(DAT)
 .F  S J=$O(^SC(+LOC,"S",DAT,1,J)) Q:'J!(CNT'<MAX)  D
 ..S X=^SC(LOC,"S",DAT,1,J,0)
 ..Q:$P(X,U,9)="C"                                                     ; cancelled clinic availability
 ..S DFN=+X
 ..S X=$G(^DPT(DFN,"S",DAT,0))
 ..Q:+X'=LOC                                                           ; appt cancelled/resched
 ..I $P(X,U,2)'="NT",($P(X,U,2)["C")!($P(X,U,2)["N") Q                 ; quit if appt cancelled or no show
 ..S VIEN=+$P($G(^SCE(+$P(X,U,20),0)),U,5)
 ..I VIEN,$D(^AUPNVSIT(VIEN,0)) S VSTR=LOC_";"_+^(0)_";A;"_VIEN
 ..E  S VSTR=LOC_";"_DAT_";A"
 ..S:$$ISACTIVE^BEHOPTCX(DFN,.QUALS) CNT=CNT+1,DATA(CNT)=DFN_U_$P(^DPT(DFN,0),U)_U_DATX_U_VSTR
 I CNT'<MAX D                                                          ;maximum allowable appointments exceeded
 .K DATA
 .S DATA(1)="^Too many appointments found; please narrow search range."
 S:'$D(DATA) DATA(1)="^No appointments."
 Q
 ; Return appts for a patient between beginning and end dates for a clinic, if no clinic return all appointments
PTAPPTS(DATA,DFN,START,END,LOC) ;EP
 I '$$ACTLOC^BEHOENCX(LOC) S DATA(1)="^Clinic is not active" Q
 N VASD,VAERR,NUM,CNT,INVDT,INT,EXT,ORSRV
 S NUM=0,CNT=0
 I START="" D
 .D:'$L(LOC) GETPAR^CIAVMRPC(.START,"ORQQAP SEARCH RANGE START",,,"E")
 .S:START="" START="T"                                                 ;default start date across all clinics is today
 I END="" D
 .D:'$L(LOC) GETPAR^CIAVMRPC(.START,"ORQQAP SEARCH RANGE STOP",,,"E")
 .S:END="" END="T"                                                     ;default end date across all clinics is today
 D DT^DILF("T",START,.START,"","")
 D DT^DILF("T",END,.END,"","")
 I (START=-1)!(END=-1) S DATA(1)="^Error in date range." Q
 S VASD("F")=START
 S VASD("T")=END\1+.5
 S:$L(LOC) VASD("C",LOC)=""
 S DATA(1)="^No appointments."
 D SDA^VADPT
 Q:VAERR=1
 F  S NUM=$O(^UTILITY("VASD",$J,NUM)) Q:'NUM  D
 .S INT=^UTILITY("VASD",$J,NUM,"I"),INVDT=9999999-$P(INT,U)
 .S EXT=^UTILITY("VASD",$J,NUM,"E")
 .S CNT=CNT+1,DATA(CNT)=$P(INT,U)_U_$P(EXT,U,2)_U_$P(EXT,U,3)_U_$P(EXT,U,4)_U_INVDT
 K ^UTILITY("VASD",$J)
 Q
 ; Return provider list
PROVLST(DATA,FROM,DIR,MAX) ;EP
 N IEN,CNT
 S FROM=$G(FROM),DIR=$G(DIR,1),MAX=$G(MAX,44),CNT=0
 F  S FROM=$O(^VA(200,"B",FROM),DIR),IEN="" Q:FROM=""  D:$E(FROM)'="*"  Q:CNT'<MAX
 .F  S IEN=$O(^VA(200,"B",FROM,IEN),DIR) Q:'IEN  D
 ..I $D(^XUSEC("PROVIDER",IEN)),$$ACTIVE^XUSER(IEN) S CNT=CNT+1,DATA(CNT)=IEN_U_FROM
 Q
 ; Return list of patients associated w/ primary provider
PROVPTS(DATA,PROV) ;EP
 I +$G(PROV)<1 S DATA(1)="^No provider identified" Q
 N DFN,CNT,QUALS
 S (CNT,DFN)=0,DATA(1)="^No patients found."
 F  S DFN=+$O(^DPT("APR",PROV,DFN)) Q:'DFN  D
 .S:$$ISACTIVE^BEHOPTCX(DFN,.QUALS) CNT=CNT+1,DATA(CNT)=DFN_U_$P(^DPT(DFN,0),U)
 Q
 ; Return list of treating specialties
SPECLST(DATA,FROM,DIR,MAX) ;EP
 N CNT,IEN
 S FROM=$G(FROM),DIR=$G(DIR,1),MAX=$G(MAX,44),CNT=0
 F  S FROM=$O(^DIC(45.7,"B",FROM),DIR),IEN="" Q:FROM=""  D  Q:CNT'<MAX
 .F  S IEN=$O(^DIC(45.7,"B",FROM,IEN),DIR) Q:'IEN  D
 ..S:$$ACTIVE^DGACT(45.7,IEN) CNT=CNT+1,DATA(CNT)=IEN_U_FROM
 Q
 ; Return list of patients associated w/ treating specialty
SPECPTS(DATA,SPEC) ;EP
 I +$G(SPEC)<1 S DATA(1)="^No specialty identified" Q
 N CNT,DFN,QUALS
 S (CNT,DFN)=0,DATA(1)="^No patients found."
 F  S DFN=+$O(^DPT("ATR",SPEC,DFN)) Q:'DFN  D
 .S:$$ISACTIVE^BEHOPTCX(DFN,.QUALS) CNT=CNT+1,DATA(CNT)=DFN_U_$P(^DPT(DFN,0),U)
 Q
 ; Return list of patients on a ward
WARDPTS(DATA,LOC) ;EP
 N CNT,DFN,WARD,QUALS
 I +$G(LOC)<1 S DATA(1)="^No ward identified." Q
 S WARD=+$G(^SC(+LOC,42))
 I '$D(^DIC(42,WARD,0)) S DATA(1)="^Not a valid ward." Q
 S (CNT,DFN)=0,WARD=$P(^DIC(42,WARD,0),U),DATA(1)="^No patients found."
 F  S DFN=+$O(^DPT("CN",WARD,DFN)) Q:'DFN  D:$$ISACTIVE^BEHOPTCX(DFN,.QUALS)
 .S CNT=CNT+1,DATA(CNT)=DFN_U_$P(^DPT(DFN,0),U)_U_$P($G(^DPT(DFN,.101)),U)
 .S DATA(CNT)=DATA(CNT)_U_$P($$ADMITINF^BEHOENCX(DFN,^DPT("CN",WARD,DFN)),U)
 Q
 ; Returns all teams to which a user belongs
 ;   PER = If nonzero, return personal lists.  Otherwise, return team lists.
TEAMLST(DATA,PER) ;EP
 N CNT,IEN,X
 S (CNT,IEN)=0,PER=''$G(PER)
 F  S IEN=$O(^OR(100.21,"C",DUZ,IEN)) Q:'IEN  D
 .S X=$G(^OR(100.21,IEN,0))
 .S:$P(X,U,2)="P"=PER CNT=CNT+1,DATA(CNT)=IEN_U_X
 Q
 ; Return list of patients belonging to a team
TEAMPTS(DATA,TEAM) ;EP
 N CNT,IEN,DFN,QUALS
 S DATA(1)="^No patients found.",(CNT,IEN)=0,TEAM=+TEAM
 I '$D(^OR(100.21,TEAM,0)) S DATA(1)="^Not a valid team." Q
 F  S IEN=$O(^OR(100.21,TEAM,10,IEN)) Q:'IEN  S DFN=+$G(^(IEN,0)) D
 .S:$$ISACTIVE^BEHOPTCX(DFN,.QUALS) CNT=CNT+1,DATA(CNT)=DFN_U_$P(^DPT(DFN,0),U)
 Q
 ; Return list of locations
HOSPLOC(DATA,FROM,DIR,MAX,TYPE,START,END) ;EP
 D HOSPLOC^BEHOENCX(.DATA,.FROM,.DIR,.MAX,.TYPE,.START,.END)
 Q
