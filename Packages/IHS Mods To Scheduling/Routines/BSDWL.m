BSDWL ; IHS/ANMC/LJF - WAITING LIST REPORTS ; [ 01/09/2003  1:31 PM ]
 ;;5.3;PIMS;**1004,1007**;MAY 28, 2004
 ;IHS/OIT/LJF 07/21/2005 PATCH 1004 add choice to print each sort on separate paper
 ;            07/22/2005 PATCH 1004 fixed so Include Removed? is pre-answered if using Date Removed
 ;            08/31/2005 PATCH 1004 check for patient trying to quit before asking paper question
 ;cmi/anch/maw 01/15/2007 PATCH 1007 includes print by for wait list report 
 ;
ASK ; ask user questions
 NEW BSDWLN,BSDA,BSDATE,BSDSRT,I,BSDBD,BSDED,BSDREM
 S BSDWLN=+$$READ^BDGF("PO^9009017.1:EMQ","Select Clinic or Ward")
 Q:BSDWLN<1
 ;
 W !! F I=1:1:3 S BSDA(I)=$J(I,4)_")  "_$P($T(DATE+I),";;",2)
 S BSDATE=$$READ^BDGF("NO^1:3","Select Date Range Type","","","",.BSDA)
 I (BSDATE=U)!(BSDATE="") Q
 S BSDATE=$P($T(DATE+BSDATE),";;",2,3),BSDATE=$P(BSDATE,";;",2)_U_$P(BSDATE,";;")
 ;
 W ! S BSDBD=$$READ^BDGF("DO^::EX","Select Beginning Date") I BSDBD<1 Q
 S BSDED=$$READ^BDGF("DO^::EX","Select Ending Date") I BSDED<1 Q
 ;
 ;I BSDATE=".07" S BSDREM=1    ;include removed entries
 I $P(BSDATE,U)=".07" S BSDREM=1    ;include removed entries   ;IHS/OIT/LJF 7/22/2005 PATCH 1004
 E  W ! S BSDREM=$$READ^BDGF("Y","Include Entries Already Removed from List","NO")
 I BSDREM=U Q
 ;
 W !! K BSDA F I=1:1:5 S BSDA(I)=$J(I,4)_")  "_$P($T(SORT+I),";;",2)
 S BSDSRT=$$READ^BDGF("NO^1:5","Select Sort","","","",.BSDA)
 I (BSDSRT=U)!(BSDSRT="") Q
 I BSDSRT=1 S BSDSRT=BSDSRT_U_BSDATE               ;sorting by date
 E  S BSDSRT=BSDSRT_U_$P($T(SORT+BSDSRT),";;",3)   ;sort field
 ;
 ;cmi/anch/maw added patch 1007 item 1007.28
 S BSDPRTYN=$$READ^BDGF("Y","Select item to Print By","NO")
 K BSDSEL
 I $G(BSDPRTYN) D
 . W !! K BSDA F I=1:1:5 S BSDA(I)=$J(I,4)_")  "_$P($T(SORT+I),";;",2)
 . S BSDPRTB=$$READ^BDGF("NO^1:5","Print By","","","",.BSDA)
 . I (BSDPRTB=U)!(BSDPRTB="") Q
 . I BSDPRTB=1 S BSDPRTB=BSDPRTB_U_BSDATE               ;printing by date
 . I BSDPRTB'=1 D  ;print field
 .. I BSDPRTB=2 D PRI Q
 .. I BSDPRTB=3 D PROV Q
 .. I BSDPRTB=4 D REA Q
 .. I BSDPRTB=5 D RES Q
 I '$G(BSDSEL) K BSDPRTYN
 ;cmi/anch/maw end of mods
 ;
 ;IHS/OIT/LJF 8.31.2005 PATCH 1004 check for user ^ out too
 ;I $$BROWSE^BDGF="B" D EN^BSDWLL Q
 S X=$$BROWSE^BDGF I X=U Q
 I X="B" D EN^BSDWLL Q
 ;
 ;IHS/OIT/LJF 7/21/2005 PATCH 1004
 NEW BSDPAG S BSDPAG=$$READ^BDGF("Y","Print each "_$P($T(SORT+BSDSRT),";;",4)_" on separate piece of paper","NO") Q:BSDPAG=U
 ;
 D ZIS^BDGF("PQ","EN^BSDWLL","Waiting List Report","BSD*")
 Q
 ;
PRI ;-- get priority
 ;cmi/anch/maw added 1/15/2007 PATCH 1007 item 1007.28
 S DIR(0)="S^"_$P(^DD(9009017.11,.02,0),U,3),DIR("A")="Select Priority: "
 D ^DIR
 Q:$D(DIRUT)
 S BSDPRI(+Y)=""
 S BSDSEL=1
 N BSDAN
 S BSDAN=$$READ^BDGF("Y","Select Another","NO")
 I $G(BSDAN) G PRI
 Q
 ;
PROV ;--get provider(s)
 ;cmi/anch/maw added 1/15/2007 PATCH 1007 item 1007.28
 S DIC(0)="AEMQZ",DIC=200,DIC("A")="Select Provider: "
 D ^DIC
 Q:'+$G(Y)
 S BSDPROV(+Y)=""
 S BSDSEL=1
 N BSDAN
 S BSDAN=$$READ^BDGF("Y","Select Another","NO")
 I $G(BSDAN) G PROV
 Q
 ;
REA ;-- get reason(s)
 ;cmi/anch/maw added 1/15/2007 PATCH 1007 item 1007.28
 S DIC(0)="AEMQZ",DIC=9009017.4,DIC("A")="Select Reason: "
 D ^DIC
 Q:'+$G(Y)
 S BSDREA(+Y)=""
 S BSDSEL=1
 N BSDAN
 S BSDAN=$$READ^BDGF("Y","Select Another","NO")
 I $G(BSDAN) G REA
 Q
 ;
RES ;-- get resolution(s)
 ;cmi/anch/maw added 1/15/2007 PATCH 1007 item 1007.28
 S DIC(0)="AEMQZ",DIC=9009017.4,DIC("A")="Select Resolution: "
 D ^DIC
 Q:'+$G(Y)
 S BSDRES(+Y)=""
 S BSDSEL=1
 N BSDAN
 S BSDAN=$$READ^BDGF("Y","Select Another","NO")
 I $G(BSDAN) G RES
 Q
 ;
DATE ;;
 ;;Date Added to List;;.03;;
 ;;Recall Date;;.05;;
 ;;Date Removed from List;;.07;;
 ;;
SORT ;;
 ;;By Dates Selected;;;;DATE
 ;;By Priority;;.02;;PRIORITY
 ;;By Provider;;.06;;PROVIDER
 ;;By Reason Added;;.09;;REASON
 ;;By Resolution;;.08;;RESOLUTION
