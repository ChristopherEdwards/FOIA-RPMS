DGMTU22 ;ALB/CAW - COPY PRIOR YEAR INCOME INFORMATION; 6/18/92
 ;;5.3;Registration;**33,45**;Aug 13, 1993
 ;
COPY(DFN,DGDT,DGMTI) ;
 ;  Input:
 ;        DFN - Patient IFN
 ;       DGDT - Date passed in where you want the prior years
 ;              income data to be copied into the last year
 ;              Ex.  If DGDT is 6/30/92 the income from 1990 can
 ;                   be optionally copied into 1991 if available.
 ;      DGMTI - Current MT IEN (optional)
 ;  Output:
 ;          Y - 0 not copied
 ;              1 copied
 ;             -1 timed out or ^
 N DGIN1,DGMT,DGPRI,DGFL,DGLY,DGLST,DGPY,DGI,DGINI,DGIRI,DGERR,DGREL,DGINC,DGINR,DGDEP,DEP,DGMTS,DGMTD
 D INIT I Y'>0 W !,"Cannot copy information.  Either there is no prior year income",!,"or there is income already on file for this year." H 2 G COPYQ
 D ASK I Y'>0 W !,"Cannot copy information.  Either there is no prior year income",!,"or there is income already on file for this year." H 2 G COPYQ
 D STUFF
COPYQ ;
 K DTOUT Q
INIT ; Init
 D NEW^DGRPEIS1 I DGPRI'>0 S Y=0 G INITQ ; obtain pt's relation IEN
 S DGLY=$$LYR^DGMTSCU1(DGDT),DGPY=$$LYR^DGMTSCU1(DGLY)
 S DGLST=$$LST^DGMTU(DFN,DGDT-1) I DGLST']"" S Y=1 G INITQ
 F DGI=4,5,15 I $P(^DGMT(408.31,+DGLST,0),U,DGI)["-" W !,"Previous year data contains a negative amount.  Data cannot be copied." H 3 S Y=0 G INITQ
 S Y=1
INITQ Q
ASK ; Can user copy?
 N DGINR S Y=1
 I '$D(^DGMT(408.21,"AI",+DGPRI,-DGPY)) S Y=0 Q
 I $D(^DGMT(408.21,"AI",+DGPRI,-DGLY)) D
 .S Y=$$NOBUCKS(DFN,DGDT)
 Q
 ;
STUFF ; Copy infomation into last year
 ;
 ; Get prior year info IENs
 I $G(DGMTI) N DGMT S DGMT=$$LST^DGMTU(DFN,$P(^DGMT(408.31,DGMTI,0),U)),DGMT=+$$LST^DGMTU(DFN,($P(DGMT,U,2)-1))
 N Y D ALL^DGMTU21(DFN,"VSD",DGLY,"IPR",$G(DGMT))
 ; Save prior year info
 N DGCNT,DGPRTY
 S DGCNT=0 F DGPRTY="V","S","D" I $D(DGREL(DGPRTY)) D
 .I "D"[DGPRTY F  S DGCNT=$O(DGREL(DGPRTY,DGCNT)) Q:'DGCNT  D SET(DFN,DGDT,+DGREL(DGPRTY,DGCNT),+$G(DGINC(DGPRTY,DGCNT)),+$G(DGINR(DGPRTY,DGCNT)),$G(DGMTI))
 .I "SV"[DGPRTY D SET(DFN,DGDT,+DGREL(DGPRTY),+$G(DGINC(DGPRTY)),+$G(DGINR(DGPRTY)),+$G(DGMTI))
 Q
SET(DFN,DGDT,DGPRI,DGPINI,DGPINR,DGMTI) ; Create last year IENs
 ;
 N DGERR,DGINI,DGIRI,DGMT,I
 F I=0:1:2 S DGMT(I)=$G(^DGMT(408.21,DGPINI,I))
 S DGMT(3)=$G(^DGMT(408.22,DGPINR,0))
 D GETIENS^DGMTU2(DFN,DGPRI,DGDT) G SETQ:DGERR
 ; Set info into global and index
 S $P(^DGMT(408.22,+DGIRI,0),U,3,99)=$P(DGMT(3),U,3,99)
 I $G(DGMTI) S ^DGMT(408.22,+DGIRI,"MT")=+DGMTI
 S DIK="^DGMT(408.22,",DA=DGIRI D IX^DIK K DA,DIK
 S $P(^DGMT(408.21,+DGINI,0),U,3,99)=$P(DGMT(0),U,3,99)
 F I=1:1:2 I DGMT(I)'="" S ^DGMT(408.21,+DGINI,I)=DGMT(I)
 S DIK="^DGMT(408.21,",DA=DGINI D IX^DIK K DA,DIK
SETQ Q
NOBUCKS(DFN,DGDT) ; Used by Income Screen Checks if BOTH
 ;  NO meaningful Income Data for Prior Year
 ;  AND there is data for Year before Prior Year
 ;  2=YES (but some edit/entry in 408.22),1=YES & 0=NO
 ;  ** REQUIRES DGINR("V")
 N DGCURR,DGPRIEN,DGPRIOR,DGPY,DGLY,DGIAI,DGIR,DGY,DGINP
 I $G(DGNOCOPY) S DGY=0 G QTNB
 S:'$D(DGDT) DGDT=DT
 S DGLY=$E(DGDT,1,3)_"0000"-10000,DGPY=DGLY-10000
 S (DGPRIOR,DGCURR)=0
 F DGPRIEN=0:0 S DGPRIEN=$O(^DGPR(408.12,"B",DFN,DGPRIEN)) Q:'DGPRIEN  D
 .S:$D(^DGMT(408.21,"AI",+DGPRIEN,-DGPY)) DGPRIOR=DGPRIOR+1
 .S DGIAI=$$IAI^DGMTU3(+DGPRIEN,DGLY)
 .I DGIAI]"" D
 ..S DGCURR=DGCURR+$S($P($G(^DGMT(408.21,DGIAI,0)),U,8,18)'?."^":1,($P($G(^(1)),U,1,3)]""):1,($P($G(^(2)),U,1,5)]""):1,1:0)
 ..;S DGINP=$O(^DGMT(408.22,"AIND",+DGIAI,"")) I $P($G(^DGMT(408.22,+DGINP,"MT")),U) S DGCURR=DGCURR+1
 I 'DGPRIOR!DGCURR S DGY=0 G QTNB
 S DGIR=$G(^DGMT(408.22,+$G(DGINR("V")),0))
 S DGY=$S($P(DGIR,U,5)]"":2,($P(DGIR,U,13)]""):2,1:1)
QTNB Q DGY
